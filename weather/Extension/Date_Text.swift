//
//  Date_Text.swift
//  weather
//
//  Created by JiangXiaoMing on 2019/6/8.
//  Copyright © 2019 JiangXiaoMing. All rights reserved.
//

import Foundation


extension Date {
    func standardText() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE(MM-dd) h:mm a"
        return formatter.string(from: self)
    }
}
