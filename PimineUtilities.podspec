Pod::Spec.new do |s|
  s.name            = 'PimineUtilities'
  s.version         = '0.7.1'
  s.summary         = 'PimineSDK'

  s.homepage        = 'https://github.com/Pimine/PimineSDK'
  s.license         = { :type => 'MIT', :file => 'LICENSE' }
  s.authors         = { 'Den Andreychuk' => 'denis.andrei4uk@yandex.ua' }

  s.source          = {
    :git => 'https://github.com/Pimine/PimineSDK.git',
    :tag => s.version.to_s
  }
  
  s.ios.deployment_target = '12.1'

  s.swift_version   = ['5.2', '5.3']
  s.default_subspec = 'Core'

  # Core
  s.subspec 'Core' do |ss|
    ss.source_files = 'PimineUtilities/**/*.swift'
  end

end
