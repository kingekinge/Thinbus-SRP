#
# Be sure to run `pod lib lint Thinbus-SRP.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Thinbus-SRP'
  s.version          = '0.1.0'
  s.summary          = 'A short description of Thinbus-SRP.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/kingekinge/Thinbus-SRP'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'kingekinge' => 'kingekinge@163.com' }
  s.source           = { :git => 'https://github.com/kingekinge/Thinbus-SRP.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'
  s.swift_version = "5.1"
  s.source_files = 'Thinbus-SRP/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Thinbus-SRP' => ['Thinbus-SRP/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'

  s.dependency 'IDZSwiftCommonCrypto', '~> 0.13.0'
  s.dependency 'BigInt', '~> 5.2'

end
