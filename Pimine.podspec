Pod::Spec.new do |s|
  s.name            = 'Pimine'
  s.version         = '0.3.0'
  s.summary         = 'PimineSDK'

  s.description     = 'Internal SDK'

  s.homepage        = 'https://github.com/Pimine/PimineSDK'
  s.license         = { :type => 'MIT', :file => 'LICENSE' }
  s.authors         = { 'Den Andreychuk' => 'denis.andrei4uk@yandex.ua' }

  s.source          = {
    :git => 'https://github.com/Pimine/PimineSDK.git',
    :tag => s.version.to_s
  }
  
  s.ios.deployment_target = '12.0'

  s.swift_version   = ['5.1', '5.2']
  s.default_subspec = 'Core'

  # Core
  s.subspec 'Core' do |ss|
    ss.dependency 'Pimine/HandyExtensions'
    ss.dependency 'Pimine/Utilities'
    ss.dependency 'ScuffedUI'
  end

  #Utilities
  s.subspec 'Utilities' do |ss|
    ss.source_files = 'Sources/Submodules/Utilities/**/*.swift', 'Sources/Submodules/HandyExtensions/UIKit/UIApplicationExtensions.swift'
  end

  #HandyExtensions
  s.subspec 'HandyExtensions' do |ss|
    ss.source_files = 'Sources/Submodules/HandyExtensions/**/*.swift'
    ss.dependency 'SwifterSwift/SwiftStdlib'
    ss.dependency 'SwifterSwift/Foundation'
    ss.dependency 'SwifterSwift/UIKit'
    ss.dependency 'SwifterSwift/CoreGraphics'
    ss.dependency 'SwifterSwift/CoreAnimation'
  end

  # LocalStore
  s.subspec 'LocalStore' do |ss|
    ss.source_files = 'Sources/Submodules/LocalStore/**/*.swift'
    ss.dependency 'Pimine/Utilities'
    ss.dependency 'SVProgressHUD'
    ss.dependency 'MerchantKit'
  end

  # RevenueCatStore
  s.subspec 'RevenueCatStore' do |ss|
    ss.source_files = 'Sources/Submodules/RevenueCatStore/**/*.swift'
    ss.dependency 'Pimine/Utilities'
    ss.dependency 'SVProgressHUD'
    ss.dependency 'Purchases'
  end

  # Math
  s.subspec 'Math' do |ss|
  	ss.source_files = 'Sources/Submodules/Math/*.swift'
  end

end
