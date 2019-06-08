//
//  CityWeatherModel.swift
//  weather
//
//  Created by JiangXiaoMing on 2019/6/7.
//  Copyright © 2019 JiangXiaoMing. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa
import Moya

class CityWeatherModel: Object {
    @objc dynamic var city: String!
    @objc dynamic var updateTime: Date? = nil
    @objc dynamic var conditionText: String?
    @objc dynamic var conditionIcon: String?
    @objc dynamic var temperature: Float = 0.0
    @objc dynamic var windSpeed: Float = 0.0


    override static func primaryKey() -> String? {
        return "city"
    }

    convenience required init(city: String!) {
        self.init()
        self.city = city

    }


    func updateWeather() {
        _ = weatherProvider.rx.request(.get(city: city))
                .filterSuccessfulStatusCodes()
                .mapJSON()
                .subscribe { [weak self] event in
                    switch event {
                    case .success(let res):
                        do {
                            let current: [String: AnyObject] = ((res as! [String: AnyObject])["current"]) as! [String: AnyObject]
                            try! self?.realm?.write {
                                self?.conditionText = current["condition"]?["text"] as? String
                                self?.conditionIcon = "https:\(current["condition"]!["icon"]! ?? "")"
                                self?.temperature = current["temp_c"] as? Float ?? 0.0
                                self?.windSpeed = current["wind_kph"] as? Float ?? 0.0
                                self?.updateTime = Date(timeIntervalSince1970: current["last_updated_epoch"] as! TimeInterval)
                            }
                        }
                    case .error(_):
                        break

                    }
                }

    }

    private func save() {

    }
}
