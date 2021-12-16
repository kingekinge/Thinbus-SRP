//
//  String+Ext.swift
//  SRP
//
//  Created by 张良凯 on 2021/12/11.
//

import Foundation


extension String {
    
    
    func trimmedZero() -> Self{
        return self.replacingOccurrences(of: "^0+", with: "", options: .regularExpression).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func trim()->Self{
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
   
}
