//
//  TableViewController.swift
//  WeatherApp
//
//  Created by Michał Talaga on 26.01.2016.
//  Copyright © 2016 Michal Talaga. All rights reserved.
//

import UIKit


protocol SortingArrayDelegate
{
    func sortArray(order: String)
}

class TableViewController: UITableViewController, UIPopoverPresentationControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating, SortingArrayDelegate {
    
    let searchController = UISearchController(searchResultsController: nil)
    var alert: UIActivityIndicatorView!
    var locations = [Location]()
    var filteredLocations = [Location]()
    let JSONurl = "https://dnu5embx6omws.cloudfront.net/venues/weather.json"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        self.definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        self.tableView.tableHeaderView = searchController.searchBar
        
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        alert = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        alert.color = self.navigationController?.navigationBar.barTintColor
        alert.frame = CGRectMake(0,0,30,30)
        alert.center = self.view.center
        self.view.addSubview(alert)
        alert.startAnimating()
        
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != ""
        {
            return filteredLocations.count
        }
        else
        {
            return locations.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell", forIndexPath: indexPath) as! TableCell
        let actualLocation: Location
        
        if searchController.active && searchController.searchBar.text != ""
        {
            actualLocation = filteredLocations[indexPath.row]
        }
        else
        {
            actualLocation = locations[indexPath.row]
        }
        
        cell.locationLabel.text = actualLocation.getName()
        if (actualLocation.getActTemperature() == Int.min)
        {
            cell.temperatureLabel.text = "No Data"
        }
        else
        {
            cell.temperatureLabel.text = ("\(actualLocation.getActTemperature())°")
        }
        if (actualLocation.getTimeStamp() == -1.0)
        {
            cell.dayLabel.text = "No Data"
            cell.timeLabel.text = "No Data"
        }
        else
        {
            cell.dayLabel.text = dateToString("day", timeStamp: actualLocation.getTimeStamp())
            cell.timeLabel.text = dateToString("time", timeStamp: actualLocation.getTimeStamp())
            
        }
    
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let identifier = segue.identifier
        {
            switch identifier
            {
                case "Show Details":
                    let locationVC = segue.destinationViewController as! LocationViewController
                    if let indexPath = self.tableView?.indexPathForCell(sender as! TableCell)
                    {
                        if (searchController.active && searchController.searchBar.text != "")
                        {
                            locationVC.location = filteredLocations[indexPath.row]
                        }
                        else
                        {
                            locationVC.location = locations[indexPath.row]
                        }
                    }
                
                case "ShowPopover":
                    let popoverVC = segue.destinationViewController as! PopoverViewController
                    popoverVC.modalPresentationStyle = UIModalPresentationStyle.Popover
                    popoverVC.popoverPresentationController?.delegate = self
                    popoverVC.delegate = self
                    popoverVC.preferredContentSize = popoverVC.tableView.contentSize
                
                default: break
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }

    func searchBar(searchBar: UISearchBar)
    {
        filterContentForSearchText(searchBar.text!)
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(searchText: String)
    {
        filteredLocations = self.locations.filter({(location: Location) -> Bool in
            return location.getName().lowercaseString.containsString(searchText.lowercaseString)
        })
        self.tableView.reloadData()
    }
    
    func refresh(sender:AnyObject)
    {
        getData()
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    func sortArray(order: String)
    {
        switch order
        {
            case "By name - ascending":
                locations.sortInPlace({$0.getName() < $1.getName()})
            
            case "By name - descending":
                locations.sortInPlace({$0.getName() > $1.getName()})
            
            case "By temperature - ascending":
                locations.sortInPlace({$0.getActTemperature() < $1.getActTemperature()})
            
            case "By temperature - descending":
                locations.sortInPlace({$0.getActTemperature() > $1.getActTemperature()})
            
            case "By last update - ascending":
                locations.sortInPlace({$0.getTimeStamp() < $1.getTimeStamp()})
            
            case "By last update - descending":
                locations.sortInPlace({$0.getTimeStamp() > $1.getTimeStamp()})
            
        default: break
        }
        
        self.tableView.reloadData()
        self.tableView.scrollRectToVisible(CGRectMake(0,0,1,1), animated: true)
    }
    
    func getData()
    {
        if (locations.count>0)
        {
            locations.removeAll()
        }        
        let url: NSURL! = NSURL(string: JSONurl)
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            if (error != nil)
            {
                print(error)
            }
            else if let httpResponse = response as? NSHTTPURLResponse
            {
                if (httpResponse.statusCode != 200)
                {
                    print(httpResponse.statusCode)
                }
                else
                {
                    do {
                        let result = (try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary)
                        self.parseData(result)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.tableView.reloadData()
                        })
                        self.alert.stopAnimating()
                        self.alert.removeFromSuperview()
                    }
                    catch let error as NSError
                    {
                        print(error)
                    }
                }
            }
        })
        dataTask.resume()
    }
    
    func parseData(result: NSDictionary)
    {
        let icons = ["cloudy":"Cloudy", "partlycloudy":"Partly Cloudy", "clear":"Clear", "mostlycloudy":"Mostly Cloudy", "hazy":"Haze", "fog":"Fog", "rain":"Rain", "snow":"Snow", "tstorms":"Thunderstorms"]
        
        if let locationsJSONArray = result["data"] as? NSArray
        {
            for i in 0...locationsJSONArray.count-1
            {
                let loc = Location()
                if let location = locationsJSONArray[i] as? NSDictionary
                {
                    if let locatonID = location["_venueID"] as? String
                    {
                        loc.setLocationID(Int(locatonID)!)
                    }
                    
                    if let name = location["_name"] as? String
                    {
                        loc.setName(name)
                    }
                    
                    if let windSpeed = location["_weatherWind"] as? String
                    {
                        let splitted = windSpeed.characters.split{$0 == " "}.map{String($0)}
                        if (splitted.count < 4)
                        {
                            loc.setWindSpeed(splitted[2])
                        }
                        else
                        {
                            loc.setWindSpeed("\(splitted[1]) \(splitted[3])")
                        }
                    }
                    
                    if let actTemperature = location["_weatherTemp"] as? String
                    {
                        loc.setActTemperature(Int(actTemperature)!)
                    }
                    
                    if let feelTemperature = location["_weatherFeelsLike"] as? String
                    {
                        loc.setFeelTemperature(Int(feelTemperature)!)
                    }
                    
                    if let timeStamp = location["_weatherLastUpdated"] as? Double
                    {
                        loc.setTimeStamp(timeStamp)
                    }
                    
                    if let weatherCondition = location["_weatherCondition"] as? String
                    {
                        loc.setWeatherCondition(weatherCondition)
                    }
                        
                    else if let weatherConditionIcon = location["_weatherConditionIcon"] as? String
                    {
                        if (icons[weatherConditionIcon] != nil)
                        {
                            loc.setWeatherCondition(icons[weatherConditionIcon]!)
                        }
                        else
                        {
                            loc.setWeatherCondition("")
                        }
                        
                    }
                }
                
                locations.append(loc)
            }
        }
        
    }
    
    func dateToString(type: String, timeStamp: Double) -> String
    {
        let date = NSDate(timeIntervalSince1970: timeStamp)
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone(name: "UTC")
        if (type == "day")
        {
            formatter.dateFormat = "dd-MM-YYYY"
            let day = formatter.stringFromDate(date)
            return day
        }
        if (type == "time")
        {
            formatter.dateFormat = "hh:mm aa"
            let time = formatter.stringFromDate(date)
            return time
        }
        else
        {
            return ""
        }
        
    }
}