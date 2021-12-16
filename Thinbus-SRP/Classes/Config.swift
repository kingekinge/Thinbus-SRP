//
//  Config.swift
//  SRP
//
//  Created by 张良凯 on 2021/12/11.
//

import Foundation
import BigInt
import IDZSwiftCommonCrypto

class Config{
    
    var _prime:BigInt
    var _generator:BigInt
    var _key:BigInt
    var _algorithm:Digest.Algorithm
    
    
//    constructor (prime, generator, key, algorithm) {
//      this._prime = new BigInteger(prime, 10)
//      this._generator = new BigInteger(generator, 10)
//      this._key = new BigInteger(key, 16)
//      this._algorithm = algorithm
//    }
    
    init(prime:String , generator:String, key:String, algorithm:Digest.Algorithm){
        self._prime = BigInt(prime,radix: 10)!
        self._generator = BigInt(generator,radix: 10)!
        self._key = BigInt(key,radix: 16)!
        self._algorithm = algorithm
    }
    
    
    /**
       * Get the large safe prime N for computing g^x mod N.
       *
       * @return BigInteger
       */
    func prime () -> BigInt{
      return self._prime
    }

    /**
       * Get the configured generator g of the multiplicative group.
       *
       * @return BigInteger
       */
    func generator () -> BigInt {
      return self._generator
    }
    
    func key() ->BigInt{
        return self._key
    }
    
}
