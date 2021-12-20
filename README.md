# Thinbus-SRP

[![CI Status](https://img.shields.io/travis/zlk/Thinbus-SRP.svg?style=flat)](https://travis-ci.org/zlk/Thinbus-SRP)
[![Version](https://img.shields.io/cocoapods/v/Thinbus-SRP.svg?style=flat)](https://cocoapods.org/pods/Thinbus-SRP)
[![License](https://img.shields.io/cocoapods/l/Thinbus-SRP.svg?style=flat)](https://cocoapods.org/pods/Thinbus-SRP)
[![Platform](https://img.shields.io/cocoapods/p/Thinbus-SRP.svg?style=flat)](https://cocoapods.org/pods/Thinbus-SRP)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements



```ruby
ios >= 13.0
swift >= 5.1
```



## Installation

Thinbus-SRP is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Thinbus-SRP'
```



### Step 0: Generate a new verifier v for the user identity I and password P with salt s.

```swift
//register s and v send to server

let srp = Client.init(config: Config(prime: N, generator: g, key: key, algorithm: .sha256))

let verifier = client.enroll(identity: _identity, password: _password, salt: salt)

```





###  Step 1: Generates a one-time client key A encoded as a hexadecimal.

```swift
let userA = client.identify(identity: _identity, password: _password, salt: salt)

```





###  Step 2: Create challenge response to server's public key challenge B with a proof of password M1.



``` swift
let message = try! srp.challenge(B: userB, salt: salt)

//confirm server's proof of shared key message M2 against
srp.confirm(proof: serverPoof)

//calc 256 bit share key
srp.session()
```



## License

Thinbus-SRP is available under the MIT license. See the LICENSE file for more info.
