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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
