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
  
  s.ios.deployment_target = '13.0'

  s.swift_version   = '5.0'
  s.default_subspec = 'Core'

  # Core
  s.subspec 'Core' do |ss|
    ss.source_files = 'Sources/Utilities/**/*.swift', 'Sources/HandyExtensions/**/*.swift'
    ss.dependency 'EasySwiftLayout'
    ss.dependency 'SwifterSwift/SwiftStdlib'
    ss.dependency 'SwifterSwift/Foundation'
    ss.dependency 'SwifterSwift/UIKit'
    ss.dependency 'SwifterSwift/CoreGraphics'
    ss.dependency 'SwifterSwift/CoreAnimation'
  end

  # Math
  s.subspec 'Math' do |ss|
  	ss.source_files = 'Sources/Math/*.swift'
  end

end
