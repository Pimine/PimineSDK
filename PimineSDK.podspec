Pod::Spec.new do |s|
  s.name             = 'PimineSDK'
  s.version          = '0.1.0'
  s.summary          = 'PimineSDK'

  s.description      = 'Internal SDK'

  s.homepage         = 'https://github.com/Pimine/PimineSDK'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.authors          = 'Pimine'

  s.source           = {
    :git => 'https://github.com/Pimine/PimineSDK.git',
    :tag => s.version.to_s
  }
  
  s.ios.deployment_target = '13.0'

  s.swift_version = '5.0'
  s.default_subspec = 'Core'

  # Core
  s.subspec 'Core' do |ss|
    ss.dependency 'PimineSDK/Utilities'
    ss.dependency 'PimineSDK/HandyExtensions'
  end

  # Utilities
  s.subspec 'Utilities' do |ss|
    ss.source_files = 'PimineSDK/Utilities/*.swift'
  end

  # Handy Extensions
  s.subspec 'HandyExtensions' do |ss|
    ss.dependency 'SwifterSwift/SwiftStdlib'
    ss.dependency 'SwifterSwift/Foundation'
    ss.dependency 'SwifterSwift/UIKit'
    ss.dependency 'SwifterSwift/CoreGraphics'
    ss.dependency 'SwifterSwift/CoreAnimation'
  end

end
