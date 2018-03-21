#
# Be sure to run `pod lib lint ${POD_NAME}.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Loki'
  s.version          = '1.1.0'
  s.summary          = 'Loki is an iOS/macOS/tvOS/watchOS framework for manipulating UIImage/NSImage.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Loki is an iOS/macOS/tvOS/watchOS framework for manipulating `UIImage`/`NSImage`. Methods are provided to resize, blur, adjust contrast, brightness, or saturation. A limited subset of methods are provided on watchOS.
                       DESC

  s.homepage         = 'https://github.com/Kosoku/Loki'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'BSD', :file => 'license.txt' }
  s.author           = { 'William Towe' => 'willbur1984@gmail.com' }
  s.source           = { :git => 'https://github.com/Kosoku/Loki.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.12'
  s.tvos.deployment_target = '10.0'
  s.watchos.deployment_target = '3.0'
  
  s.requires_arc = true

  s.source_files = 'Loki/**/*.{h,m}'
  s.exclude_files = 'Loki/Loki-Info.h'
  s.private_header_files = 'Loki/Private/*.h'
  s.ios.exclude_files = 'Loki/macOS'
  s.osx.exclude_files = 'Loki/iOS'
  s.tvos.exclude_files = 'Loki/macOS'
  s.watchos.exclude_files = 'Loki/macOS'
  
  # s.resource_bundles = {
  #   '${POD_NAME}' => ['${POD_NAME}/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.ios.frameworks = 'Foundation', 'UIKit', 'Accelerate'
  s.osx.frameworks = 'Foundation', 'AppKit', 'Accelerate'
  s.tvos.frameworks = 'Foundation', 'UIKit', 'Accelerate'
  s.watchos.frameworks = 'Foundation', 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
