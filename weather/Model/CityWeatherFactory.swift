//
//  CityWeatherFactory.swift
//  weather
//
//  Created by JiangXiaoMing on 2019/6/7.
//  Copyright © 2019 JiangXiaoMing. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift
import RxRealm
let realm = try! Realm()
class CityWeatherFactory {
    
    static func initCities(){
        //Maybe we should use GPS or cloud data to init the list in real case.
        //As a demo, we use an array to init it .
        if (realm.objects(CityModel.self).count == 0) {
            let cities = [CityModel(name: "Sydney"),CityModel(name: "Melbourne"),CityModel(name: "Wollongong")]
            _ = Observable.from(optional: cities)
                .subscribe(Realm.rx.add())
        }
    }
    
    static func addCity(){
        
    }
    
    static func removeCity(){
        
    }
}
