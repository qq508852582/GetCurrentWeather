//
//  CityModel.swift
//  weather
//
//  Created by JiangXiaoMing on 2019/6/7.
//  Copyright © 2019 JiangXiaoMing. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa

class CityModel: Object {
    @objc dynamic var name: String!
    
    
    override static func primaryKey() -> String? {
        return "name"
    }
    convenience required init(name:String!) {
        self.init()
        self.name=name

    }
    
    
    func updateWeather()  {
        
    }
    
    private func save()  {
        
    }
}
