//
//  Team.swift
//  SWSabres
//
//  Created by Mark Johnson on 11/2/15.
//  Copyright © 2015 swdev.net. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

struct Team: ResponseJSONObjectSerializable, UniqueObject, Equatable
{
    static let endpoint: String = "http://www.southwakesabres.org/?json=get_posts&post_type=mstw_ss_team&count=-1"
    
    let teamId: String
    let name: String
    let modified: NSDate
    var logoUrl: String?
    var shortName: String?
    
    init?(coder aDecoder: NSCoder)
    {
        guard let teamId = aDecoder.decodeObjectForKey("teamId") as? String else
        {
            return nil
        }
        self.teamId = teamId
        
        guard let name = aDecoder.decodeObjectForKey("name") as? String else
        {
            return nil
        }
        self.name = name
        
        guard let decodedModified: NSDate = aDecoder.decodeObjectForKey("modified") as? NSDate else
        {
            return nil
        }
        self.modified = decodedModified
        
        logoUrl = aDecoder.decodeObjectForKey("logoUrl") as? String
        shortName = aDecoder.decodeObjectForKey("shortName") as? String
    }
    
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(teamId, forKey: "teamId")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(logoUrl, forKey: "logoUrl")
        aCoder.encodeObject(shortName, forKey: "shortName")
        aCoder.encodeObject(modified, forKey: "modified")
    }
    
    init?(json: SwiftyJSON.JSON)
    {
        guard let team_full_name = json["custom_fields"]["team_full_name"][0].string else
        {
            return nil
        }
        
        guard let team_slug = json["slug"].string else
        {
            return nil
        }
        
        guard let team_modified = json["modified"].string else // 2015-11-01 00:40:53
        {
            return nil
        }
        
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd HH:mm:ss"
        
        guard let parsedModified: NSDate = dateFormatter.dateFromString(team_modified) else
        {
            return nil
        }
        
        self.modified = parsedModified
        
        self.teamId = team_slug
        self.name = team_full_name

        self.logoUrl = json["custom_fields"]["team_alt_logo"][0].string

        var team_short_name = json["custom_fields"]["team_short_name"][0].string
        
        if String.isNilOrEmpty(team_short_name)
        {
            team_short_name = nil
        }

        self.shortName = team_short_name
    }
    
    var uniqueId: String
    {
        get
        {
            return teamId
        }
    }
    
    static func getTeams(completionHandler: (Result<[Team], NSError>) -> Void)
    {
        Alamofire.request(.GET, Team.endpoint).getPostsReponseArray { response in
            completionHandler(response.result)
        }
    }
    
    class Helper: NSObject, NSCoding
    {
        var team: Team?
        
        init(team: Team)
        {
            self.team = team
        }
        
        required init(coder aDecoder: NSCoder)
        {
            team = Team(coder: aDecoder)
        }
        
        func encodeWithCoder(aCoder: NSCoder)
        {
            team?.encodeWithCoder(aCoder)
        }
    }
}

func ==(lhs: Team, rhs: Team) -> Bool {
    return lhs.teamId == rhs.teamId
}
