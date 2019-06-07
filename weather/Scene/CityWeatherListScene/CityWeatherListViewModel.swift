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
    let cities = realm.objects(CityModel.self)
    let disposeBag = DisposeBag()

    init() {
        Observable.collection(from: cities)
            .subscribe { event in
                print(event.element)
            }
            .disposed(by: disposeBag)
    }
}
