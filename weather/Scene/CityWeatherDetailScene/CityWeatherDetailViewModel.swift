//
//  CityWeatherDetailViewModel.swift
//  weather
//
//  Created by JiangXiaoMing on 2019/6/6.
//  Copyright © 2019 JiangXiaoMing. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import UIKit

class CityWeatherDetailViewModel {


    let cities = realm.objects(CityWeatherModel.self)
    var previousCity: CityWeatherModel? {
        get {
            let cityIndex = cities.firstIndex(of: city!)!
            return cities[(cityIndex - 1 + cities.count) % cities.count]
        }
    }
    var nextCity: CityWeatherModel? {
        get {
            let cityIndex = cities.firstIndex(of: city!)!
            return cities[(cityIndex + 1) % cities.count]
        }
    }

    var city: CityWeatherModel? {
        didSet {
            //map data after set
            
            let rx_city = Observable.from(object: self.city!)
            rx_city.map {
                $0.city
            }.bind(to: rx_cityName).disposed(by: disposeBag)
            rx_city.map {
                "\($0.temperature) ℃"
            }.bind(to: rx_temperature).disposed(by: disposeBag)
            rx_city.map {
                "\($0.windSpeed) km/h"
            }.bind(to: rx_windSpeed).disposed(by: disposeBag)
            rx_city.map {
                $0.conditionText ?? ""
            }.bind(to: rx_conditionText).disposed(by: disposeBag)
            rx_city.map {
                URL(string: $0.conditionIcon ?? "")
            }.bind(to: rx_conditionIcon).disposed(by: disposeBag)
            rx_city.map {
                $0.updateTime?.standardText() ?? ""
            }.bind(to: rx_updateTime).disposed(by: disposeBag)
            rx_cityIndex.accept(cities.firstIndex(of: city!)!)
            self.city?.updateWeather()
        }
    }
    let disposeBag = DisposeBag()
    let rx_cityName = BehaviorRelay(value: "")
    let rx_temperature = BehaviorRelay(value: "")
    let rx_conditionIcon = BehaviorRelay(value: URL(string: ""))
    let rx_conditionText = BehaviorRelay(value: "")
    let rx_windSpeed = BehaviorRelay(value: "")
    let rx_updateTime = BehaviorRelay(value: "")
    let rx_cityIndex = BehaviorRelay(value: 0)
    let rx_citiesNumber: BehaviorRelay<Int>!

    init() {
        rx_citiesNumber = BehaviorRelay(value: cities.count)
    }

    func viewDidLoad() {
        
    
        Observable.collection(from: cities)
                .subscribe(onNext: { cities in
                    
                    //update city list
                    self.rx_citiesNumber.accept(cities.count)
                    if (self.city == nil && cities.count > 0) {
                        
                        //using the first city for the very first time ,there's no city passed in at that time
                        self.city = cities.first;
                    }
                })
                .disposed(by: disposeBag)
    }


}
