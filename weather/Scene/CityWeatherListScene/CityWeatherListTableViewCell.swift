//
//  CityWeatherListTableViewCell.swift
//  weather
//
//  Created by JiangXiaoMing on 2019/6/8.
//  Copyright © 2019 JiangXiaoMing. All rights reserved.
//

import UIKit

class CityWeatherListTableViewCell: UITableViewCell {
    static var identifier = "CityWeatherListTableViewCell"
    @IBOutlet weak var conditionIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    var city: CityWeatherModel? {
        didSet {
            self.conditionIcon.kf.setImage(with: URL(string: city!.conditionIcon ?? ""))
            self.cityLabel.text = city!.city
            self.temperatureLabel.text = "\(city!.temperature) ℃"
            cityLabel.hero.id = city!.city
            self.conditionIcon.hero.id = "\(city!.city!):icon"
            self.temperatureLabel.hero.id = "\(city!.city!):temperature"
        }
    }
}
