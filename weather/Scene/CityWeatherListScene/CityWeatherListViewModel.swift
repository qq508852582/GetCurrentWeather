//
//  CityWeatherListViewModel.swift
//  weather
//
//  Created by JiangXiaoMing on 2019/6/6.
//  Copyright © 2019 JiangXiaoMing. All rights reserved.
//

import UIKit
import RxSwift

class CityWeatherListViewModel {
    let cities = realm.objects(CityWeatherModel.self)
    let disposeBag = DisposeBag()

    init() {
    }
}
