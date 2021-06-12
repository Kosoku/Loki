Pod::Spec.new do |s|
  s.name             = 'Loki'
  s.version          = '2.0.1'
  s.summary          = 'Loki is an iOS/macOS/tvOS/watchOS framework for manipulating UIImage/NSImage.'
  s.description      = <<-DESC
Loki is an iOS/macOS/tvOS/watchOS framework for manipulating `UIImage`/`NSImage`. Methods are provided to resize, blur, adjust contrast, brightness, or saturation. A limited subset of methods are provided on watchOS.
                       DESC

  s.homepage         = 'https://github.com/Kosoku/Loki'
  s.license          = { :type => 'Apache 2.0', :file => 'LICENSE.txt' }
  s.author           = { 'William Towe' => 'willbur1984@gmail.com' }
  s.source           = { :git => 'https://github.com/Kosoku/Loki.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '10.15'
  s.tvos.deployment_target = '13.0'
  s.watchos.deployment_target = '5.0'
  
  s.requires_arc = true

  s.source_files = 'Loki/**/*.{h,m}'
  s.exclude_files = 'Loki/Loki-Info.h'
  s.private_header_files = 'Loki/Private/*.h'
  s.ios.exclude_files = 'Loki/macOS'
  s.osx.exclude_files = 'Loki/iOS'
  s.tvos.exclude_files = 'Loki/macOS'
  s.watchos.exclude_files = 'Loki/macOS'
  
  s.ios.frameworks = 'Foundation', 'UIKit', 'Accelerate'
  s.osx.frameworks = 'Foundation', 'AppKit', 'Accelerate'
  s.tvos.frameworks = 'Foundation', 'UIKit', 'Accelerate'
  s.watchos.frameworks = 'Foundation', 'UIKit'
end
