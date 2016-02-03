//
//  PopoverViewController.swift
//  WeatherApp
//
//  Created by Michał Talaga on 27.01.2016.
//  Copyright © 2016 Michal Talaga. All rights reserved.
//

import UIKit

class PopoverViewController: UITableViewController {

    var types = ["By name - ascending", "By name - descending", "By temperature - ascending", "By temperature - descending", "By last update - ascending", "By last update - descending"]
    var delegate: SortingArrayDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("PopoverCell", forIndexPath: indexPath) as! PopoverCell
        cell.name.text = types[indexPath.row]
        return cell
    }
    
    override var preferredContentSize: CGSize {
        get {
            let height = tableView.rectForSection(0).height
            return CGSize(width: super.preferredContentSize.width, height: height)
        }
        set { super.preferredContentSize = newValue }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if (self.delegate != nil)
        {
           delegate?.sortArray(types[indexPath.row])
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

}
