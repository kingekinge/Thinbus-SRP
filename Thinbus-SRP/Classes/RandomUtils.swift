//
//  RandomUtils.swift
//  SRP
//
//  Created by 张良凯 on 2021/12/11.
//

import Foundation

class RandomUtils{
    
    
    static func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    static func randomHex(length:Int)->String{
        let hex = "0123456789ABCDEF"
        return String((0..<length).map{ _ in hex.randomElement()! })
    }
    
    
}
