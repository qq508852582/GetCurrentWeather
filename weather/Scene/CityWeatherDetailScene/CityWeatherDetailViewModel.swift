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

class CityWeatherDetailViewModel {
    let cities = realm.objects(CityModel.self)
    var city:CityModel?{
        didSet{
           let rx_city = Observable.from(object: self.city!)
            rx_city.map {$0.name}.bind(to: rx_cityName).disposed(by: disposeBag)
            self.city?.updateWeather()
        }
    }
    let disposeBag = DisposeBag()
    
    let rx_cityName = BehaviorRelay(value: "🔴")
    
    init() {
        if (self.city == nil){
            Observable.collection(from: cities)
                .subscribe(onNext: { cities in
                    print(cities)
                    if (self.city == nil && cities.count > 0){
                        self.city = cities.first;
                    }
                })
                .disposed(by: disposeBag)
        }
    }
    
    
}
