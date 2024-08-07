Pod::Spec.new do |s|
  s.name            = 'PimineHandyExtensions'
  s.version         = '0.14.0'
  s.summary         = 'PimineSDK'

  s.homepage        = 'https://github.com/Pimine/PimineSDK'
  s.license         = { :type => 'MIT', :file => 'LICENSE' }
  s.authors         = { 'Den Andreychuk' => 'denis.andrei4uk@gmail.com' }

  s.source          = {
    :git => 'https://github.com/Pimine/PimineSDK.git',
    :tag => s.version.to_s
  }
  
  s.ios.deployment_target = '13.0'
  s.watchos.deployment_target = '9.0'

  s.swift_version   = ['5.8', '5.9']
  s.default_subspec = 'Core'

  # Core
  s.subspec 'Core' do |ss|
    ss.source_files = 'PimineHandyExtensions/**/*.swift'
    ss.dependency 'PimineUtilities'
  end

end
