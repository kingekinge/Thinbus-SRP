//
//  Date.swift
//  SRP
//
//  Created by 张良凯 on 2021/12/11.
//

import Foundation
import BigInt


extension Date {
    var millisecondsSince1970:BigInt {
        BigInt((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:BigInt) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
