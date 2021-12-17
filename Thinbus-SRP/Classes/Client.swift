//
//  Client.swift
//  SRP
//
//  Created by 张良凯 on 2021/12/11.
//

import Foundation
import BigInt
import IDZSwiftCommonCrypto


class Client{
    
    private var ONE:BigInt
    private var ZERO:BigInt
    var _password:String
    var _salt:String
    var _identity:String
    var _private:BigInt
    var _public:BigInt
    private var _session:String
    private var _proof:String
    
    
    let config:Config
    
    init(config:Config){
        self.config = config
        self.ONE = BigInt("1")
        self.ZERO = BigInt("0")
        self._password = ""
        self._salt = ""
        self._identity = ""
        self._private = ZERO
        self._public = ZERO
        self._session = ""
        self._proof = ""
        
    }
    
    /**
       * Configure the SRP shared settings.
       *
       * @param string prime     configured value N as a decimal
       * @param string generator configured value g as a decimal
       * @param string key       configured value k as a hexidecimal
       * @param string algorithm name (e.g.: sha256)
       *
       * @return Client
       */
    static func configure(prime:String, generator:String, key:String, algorithm:Digest.Algorithm = Digest.Algorithm.sha256)->Client {
        return Client(config: Config(prime: prime, generator: generator, key: key, algorithm: algorithm))
    }
    
    
    
    
    
    /**
       * Step 0: Generate a new verifier v for the user identity I and password P with salt s.
       *
       * @param string identity I of user
       * @param string password P for user
       * @param string salt     value s chosen at random
       *
       * @return string
       */
    func enroll(identity:String, password:String, salt:String) -> String {
      self._identity = identity
      self._salt = salt

        let signature = self.signature(identity: identity, password: password, salt: self._salt)

        return _toHex(number: self.config.generator().power(signature, modulus: self.config.prime()))
    }
    
    
    
    
    /**
       * Step 1: Generates a one-time client key A encoded as a hexadecimal.
       *
       * @param string identity I of user
       * @param string password P for user
       * @param string salt     hexadecimal value s for user's password P
       *
       * @return string
       */
    func identify(identity:String, password:String, salt:String) -> String {
      self._identity = identity
      self._password = password
      self._salt = salt

        while ( self._public == self.ZERO || ((self._public % self.config.prime())  == self.ZERO)) {
          self._private = number()
          self._public = self.config.generator().power(self._private, modulus: self.config.prime())
      }


      return _unpad(hexadecimal: _toHex(number: self._public))
    }
    
    
    
    /**
        * Step 2: Create challenge response to server's public key challenge B with a proof of password M1.
        *
        * @param string server hexadecimal key B from server
        * @param string salt   value s for user's public value A
        *
        * @throws Error for invalid public key B
        *
        * @return string
        */
    func challenge(B:String, salt:String) throws ->String{
        
        let prime = self.config.prime()
        let g = self.config.generator()
        let k = self.config.key()
        
        // Verify valid public key
        let server:BigInt = _fromHex(number: _unpad(hexadecimal: B))
        
        if(server % prime == self.ZERO){
           //'Server public key failed B mod N == 0 check.'
            throw SRPClientError.invalidServerCode
        }
        // Create proof M1 of password using A and previously stored verifier v
        let union = _fromHex(number:
             hash(value: ( _toHex(number: self._public) + _toHex(number: server))
        ))
        
        // x
        let signature = signature(identity: self._identity, password: self._password, salt: salt)
        
        //ux + a
       let exponent = union * signature + self._private
        
        //kg^x
        let kgx:BigInt =  g.power(signature, modulus: prime) * k
        
        
       // S = (B - kg^x) ^ (a + ux)
       let S = (server - kgx).power(exponent, modulus:prime)
        
       let shared = _unpad(hexadecimal: _toHex(number: S ))
        
       self._session = hash(value: shared)
        
        // Compute verification M = H(A | B | S)
        let message = _unpad(hexadecimal: hash(value: _toHex(number: self._public) + _toHex(number: server) + shared))
        
        // Generate proof of password M1 = H(A | M | S) using client public key A and shared key S
        self._proof = _unpad(hexadecimal: hash(value: _toHex(number: _public) + message + shared))
        
        // Clear stored state for P, s, a, and A
        self._password = ""
        self._salt = ""
        self._private = ZERO
        self._public = ZERO
        
        return  message
    }
    
    
    /**
       * Step 3: Confirm server's proof of shared key message M2 against
       * client's proof of password M1.
       *
       * @param string proof of shared key M2 from server
       *
       * @return bool
       */
    func confirm (proof:String) -> Bool {
      // console.log(this._proof)
      // console.log(proof)

        return !self._proof.isEmpty && self._proof == proof
    }
    
    
    
    /**
       * Compute the RFC 2945 signature X from x = H(s | H(I | ":" | P)).
       *
       * @param string identity I of user
       * @param string password P for user
       * @param string salt     value s chosen at random
       *
       * @return  BigInteger
       */
    func signature(identity:String, password:String, salt:String)->BigInt {
        let x_hash = _unpad(hexadecimal: hash(value: ( identity + ":" + password )))
        return _fromHex(number: _unpad(hexadecimal: hash(value:  ( salt + x_hash ).uppercased()   ))) % self.config.prime()
    }
    
    
    
    /**
       去掉前导0
     */
    func _unpad (hexadecimal:String) -> String {
        return  hexadecimal.trimmedZero()
     }
    
    
    
    func _fromHex (number:String) -> BigInt {
      return BigInt(number, radix: 16)!
    }
    
    
    func _toHex (number:BigInt) ->String {
        return String(number,radix: 16)
    }
    
    /**
         * Generate random bytes as hexadecimal string.
         *
         * @param int bytes
         *
         * @return \ BigInteger
         */
    func _bytes(bytes:Int = 32) -> BigInt {
        return _fromHex(number:RandomUtils.randomHex(length: bytes))
    }
    
    
    /**
       * Hash key derivative function x using H algorithm.
       *
       * @param string value
       *
       * @return string
       */
    func  hash(value:String)->String {
        return Digest(algorithm:config._algorithm).update(value)!.final().hexdigest()
   }
    
    
    
    
    /**
       * Generate a new nonce H(I|:|s|:|t) string based on the user's identity I, salt s, and t time.
       *
       * @param string identity
       * @param string salt
       *
       * @return \jsbn.BigInteger
       */
    func _nonce(identity:String, salt:String)->BigInt {
        return _fromHex(number: hash(value: identity + ":" + salt + ":" + String(Date().millisecondsSince1970)))
    }
    
    
    /**
       * Generate an RFC 5054 compliant private key value (a or b) which is in the
       * range [1, N-1] of at least 256 bits.
       *
       * A nonce based on H(I|:|s|:|t) is added to ensure random number generation.
       *
       * @return BigInt
       */
   func number()->BigInt{
       let  bits  = max(256, _toHex(number: self.config.prime()).count)
       
       var number = BigInt("0")
       
       while (number == self.ZERO) {
          number = ( _bytes(bytes: 1 + bits / 8) + _nonce(identity: self._identity, salt: self._salt) )
              .power(self.ONE, modulus: self.config.prime())
      }

      return number
    }
    
    
    func _toStirng(bigint:BigInt) -> String{
        return String(bigint,radix: 10)
    }
    
    

    
    func session() ->String{
        return self._session.prefix(43).trimmingCharacters(in: .whitespacesAndNewlines)
    }

    
}
