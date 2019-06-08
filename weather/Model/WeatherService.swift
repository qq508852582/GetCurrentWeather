//
//  WeatherService.swift
//  weather
//
//  Created by JiangXiaoMing on 2019/6/7.
//  Copyright © 2019 JiangXiaoMing. All rights reserved.
//
import Foundation
import Moya

let WeatherServiceKey = "da323e05948b4dd4b0c182322190606"

let weatherProvider = MoyaProvider<WeatherService>()

enum WeatherService {
    case get(city:String)
}
extension WeatherService: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.apixu.com/v1/current.json")!
    }
    
    var path: String {
        switch self {
        case .get(_):
            return ""
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .get(let city):
            return .requestParameters(parameters: ["q": city,"key":WeatherServiceKey], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    

    
}

