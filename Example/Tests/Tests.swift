//
//  SRPTests.swift
//  SRPTests
//
//  Created by 张良凯 on 2021/12/11.
//

import XCTest
import BigInt
@testable import Thinbus_SRP

class SRPTests: XCTestCase {
    
    let userB = "616d7c6fb1592d5e722aa75aa397fcc118a261ed76c1d3d4846cfc1acd5402056363719b031927db958fe5682a2a1f0e660d5992bedc8d3e965389ccfc195b24ad039a734169b86de4dc9fa9b3c3f35768b1ae48a9d68550cb24d8153856ecd4f94921ad6a966f5be047eaa31a382b8daf150729e7e5c42136bf71258d9ab38d9d35d0a94c8a458c1127e51a0e3e44bde1eb5e310e3840e36ae4535cf3b2c91a81175a3b60ca5465591076d7b1c0fb078bd21fa114f9029aafa8628c8b99df97d35b2c70ba15dd5910fed3d9e603478e4f13c9bf1d141b780d408432c7acc8b150453eded4052994f3504df49beefcd615d31198c97f44028b8f326dce57e988"
    
    //2048 bit
    let N = "21766174458617435773191008891802753781907668374255538511144643224689886235383840957210909013086056401571399717235807266581649606472148410291413364152197364477180887395655483738115072677402235101762521901569820740293149529620419333266262073471054548368736039519702486226506248861060256971802984953561121442680157668000761429988222457090413873973970171927093992114751765168063614761119615476233422096442783117971236371647333871414335895773474667308967050807005509320424799678417036867928316761272274230314067548291133582479583061439577559347101961771406173684378522703483495337037655006751328447510550299250924469288819"
    
    let g = "2"
    
    let key = "5b9e8ef059c6b32ea59fc1d322d37f04aa30bae5aa9003b8321e21ddb04e300"
    
    let salt = "WIbN-RsIY8_h22ChB_VaU8hdP6jdHMhZ"

     let _identity = "kingekinge@163.com"

     let _password = "St_V5tWn_DiMSvsCC8zjvgOZgaAwq-P2AMr_RY0wIYY"
    
    lazy var client = initClient()
    
    func initClient()->Client{
        return Client.init(config: Config(prime: N, generator: g, key: key, algorithm: .sha256))
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
  
    }
    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
        }
    }
    
    func testConfug() throws{
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let config = Config(prime: N, generator: g, key: key, algorithm: .sha256)
        
        XCTAssertNotNil(config.prime())
    }
    
    
    
    func testEnroll(){
       let verifier = client.enroll(identity: _identity, password: _password, salt: salt)
       print(verifier)
    }
    
    
    func testIdentity(){
        client.identify(identity: _identity, password: _password, salt: salt)
    }
    
    func testPrivateKeyLength() throws{
        let srp = initClient()
        let number = srp.number()
     
        XCTAssertEqual(String(number,radix: 10).count, "1664169409967277790817964784457071944932187127082539017176971978352728664097085".count)
    }
    
    
    func testDateLength() throws{
        
        let srp = initClient()
        let nonce = srp._nonce(identity: _identity, salt: salt)
                
        XCTAssertEqual(String(nonce,radix: 10).count, "37239986401166407624925728860453591412072855887824574180582456715876665776211".count)
    }
    
    
    
    func testSharedCalcEq(){
            let srp = initClient()
            
            srp._identity = _identity
            srp._password = _password
            srp._salt = salt
            
            
            srp._private = srp._fromHex(number: "fe6816fb413651a7556813b8cc092a270f6d65388dc0c226f4cbcda3ee9d0a89")
            srp._public = srp._fromHex(number: "a43d68fd9f36fde0ded2a9cf82f5a6f07a47fe6d8ec45e02ee9bf29ff057ef8710835b6f5d41c7190db79621d85ac3ecbab52b7988a3af748f132055daddc78e759cd31f66e4f20b07ab16dbbbdfa49a58c05a59a81c60e84fca714379185d4177d4593a1d0b4e88417c8b5dae0cbd867e8a36c45dc1fa4955d6dc8060a04980fb4aabb97654d6e094d0c9a6ef8847b15612d00dc3d53f0987576ee9bc1c5d7eecc0363866f8c1232dd57152061072833de31a49557a27a1bce0e250b245de14022cf403e3f423f480e43091ef96280e8539d46ca1eeba09a93bfcbb7d39870dc7530b62227172972fe37fec0f0b8b12c2d0631f4f7fa36582a5908bb4b4de32")
            

            
            let message = try! srp.challenge(B: userB, salt: salt)
        
        
   
           XCTAssertEqual(srp.session(),"44c72fa5f1c76178e3203236326b259a4127cc38ee1")
      
    }
    

    


}
