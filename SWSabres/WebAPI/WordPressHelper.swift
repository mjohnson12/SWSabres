//
//  WordPressHelper.swift
//  SWSabres
//
//  Created by Mark Johnson on 11/3/15.
//  Copyright © 2015 swdev.net. All rights reserved.
//

import Foundation

final class WordPressHelper
{
    class func appendModifiedAfterDateQueryParams(_ date: Date, url: String) -> String
    {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH:mm:ss"
        
        return url + "&date_query[column]=post_modified&date_query[after]=\(dateFormatter.string(from: date))"
    }
}
