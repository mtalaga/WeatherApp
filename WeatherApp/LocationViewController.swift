//
//  LocationViewController.swift
//  WeatherApp
//
//  Created by Michał Talaga on 26.01.2016.
//  Copyright © 2016 Michal Talaga. All rights reserved.
//

import UIKit

class LocationViewController : UIViewController
{
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var actTemperatureLabel: UILabel!
    @IBOutlet var feelTemperatureLabel: UILabel!
    @IBOutlet var windLabel: UILabel!
    @IBOutlet var conditionLabel: UILabel!
    
    var location: Location?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if (location != nil)
        {
            if (location!.getName() != "")
            {
                nameLabel.text = location!.getName()
            }
            else
            {
                nameLabel.text = "No Data"
            }
            if (location!.getActTemperature() != Int.min)
            {
                actTemperatureLabel.text = "\(location!.getActTemperature())°"
            }
            else
            {
                actTemperatureLabel.text = "No Data"
            }
            if (location!.getFeelTemperature() != Int.min)
            {
                feelTemperatureLabel.text = "\(location!.getFeelTemperature())°"
            }
            else
            {
                feelTemperatureLabel.text = "No Data"
            }
            if (location!.getWindSpeed() != "")
            {
                windLabel.text = location!.getWindSpeed()
            }
            else
            {
                windLabel.text = "No Data"
            }
            if (location!.getWeatherCondition() != "")
            {
                conditionLabel.text = location!.getWeatherCondition()
            }
            else
            {
                conditionLabel.text = "No Data"
            }
        }
    }
}
