//
//  AnnouncementsTableViewController.swift
//  SWSabres
//
//  Created by Mark Johnson on 11/2/15.
//  Copyright © 2015 swdev.net. All rights reserved.
//

import UIKit

class AnnouncementsTableViewController: UITableViewController {

    lazy var dateFormatter: NSDateFormatter = NSDateFormatter()
    weak var contentManager: ContentManager?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        dateFormatter.dateStyle = .FullStyle
        dateFormatter.timeStyle = .NoStyle
        
        if let logoTitleView: LogoTitleView = LogoTitleView.loadFromNibNamed("LogoTitleView") as? LogoTitleView
        {
            logoTitleView.backgroundColor = AppTintColors.backgroundTintColor
            logoTitleView.titleLabel.textColor = UIColor.whiteColor()
            
            if let size = self.navigationController?.navigationBar.bounds
            {
                logoTitleView.frame = size
            }
            self.navigationItem.titleView = logoTitleView
        }
        
        if let delegate:AppDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        {
            contentManager = delegate.contentManager
            
            if delegate.contentManager.isLoadingContent
            {
                delegate.contentManager.announcementsLoadedCallback = {
                    
                    //delegate.contentManager.announcementsLoadedCallback = nil
                    self.tableView.reloadData()
                }
            }
            
//            delegate.contentManager.loadAnnouncements {
//                
//                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//                self.tableView.reloadData()
//            }
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let contentManager = contentManager
        {
            return contentManager.announcements.count
        }
        else
        {
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("announcementCellIdentifier", forIndexPath: indexPath)

//        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier")
//        if (cell == nil)
//        {
//            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "reuseIdentifier")
//        }
        
        // Configure the cell...

        if let contentManager = contentManager
        {
            let announcement = contentManager.announcements[indexPath.row]
            
            if let announcementCell: AnnouncementTableViewCell = cell as? AnnouncementTableViewCell
            {
                announcementCell.headlineLabel.text = announcement.title
                announcementCell.dateLabel.text = dateFormatter.stringFromDate(announcement.date)
            }
        }

        //cell.textLabel?.text = announcement.title
        //cell.detailTextLabel?.text = dateFormatter.stringFromDate(announcement.date)
        
        return cell
    }

    /*
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if section == 0
        {
            
            let header: UIView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 117))
            header.backgroundColor = ApptTintColors.backgroundTintColor
            
            let imageView: UIImageView = UIImageView(frame: CGRectMake(0, 0, tableView.frame.width, 117))
            imageView.contentMode = .ScaleAspectFit
            imageView.image = UIImage(named: "banner")
            header.addSubview(imageView)
            
            return header
            
        }
        
        return nil
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 117
    }
*/
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let cell: UITableViewCell = sender as? UITableViewCell, let indexPath = self.tableView.indexPathForCell(cell), let viewController: AnnouncementDetailsViewController = segue.destinationViewController as? AnnouncementDetailsViewController, let contentManager = contentManager
        {
            viewController.announcement = contentManager.announcements[indexPath.row]
        }
        
    }

}
