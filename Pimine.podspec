Pod::Spec.new do |s|
  s.name            = 'Pimine'
  s.version         = '0.14.0'
  s.summary         = 'PimineSDK'

  s.description     = 'SDK to speed up common routines and remove code duplication.'

  s.homepage        = 'https://github.com/Pimine/PimineSDK'
  s.license         = { :type => 'MIT', :file => 'LICENSE' }
  s.authors         = { 'Den Andreychuk' => 'denis.andrei4uk@gmail.com' }

  s.source          = {
    :git => 'https://github.com/Pimine/PimineSDK.git',
    :tag => s.version.to_s
  }
  
  s.ios.deployment_target = '13.0'

  s.swift_version   = ['5.8', '5.9']
  s.default_subspec = 'Core'

  # Core
  s.subspec 'Core' do |ss|
    ss.dependency 'PimineHandyExtensions'
    ss.dependency 'PimineUtilities'
  end

  # Utilities
  s.subspec 'Utilities' do |ss|
    ss.dependency 'PimineUtilities'
  end

  # HandyExtensions
  s.subspec 'HandyExtensions' do |ss|
    ss.dependency 'PimineHandyExtensions'
  end

  # Firestore
  s.subspec 'Firestore' do |ss|
    ss.source_files = 'PimineFirebase/**/*.swift'
    ss.dependency 'FirebaseFirestore'
    ss.dependency 'PimineUtilities'
  end

  # LocalStore
  s.subspec 'LocalStore' do |ss|
    ss.source_files = 'PimineLocalStore/**/*.swift'
    ss.dependency 'Pimine/Utilities'
    ss.dependency 'SVProgressHUD'
    ss.dependency 'MerchantKit'
  end

  # RevenueCatStore
  s.subspec 'RevenueCatStore' do |ss|
    ss.source_files = 'PimineRevenueCatStore/**/*.swift'
    ss.dependency 'PimineUtilities'
    ss.dependency 'SVProgressHUD'
    ss.dependency 'RevenueCat'
  end

  # SwiftyStore
  s.subspec 'SwiftyStore' do |ss|
    ss.source_files = 'PimineSwiftyStore/**/*.swift'
    ss.dependency 'PimineUtilities'
    ss.dependency 'SwiftyStoreKit'
    ss.dependency 'SVProgressHUD'
  end

  # Math
  s.subspec 'Math' do |ss|
  	ss.source_files = 'PimineMath/*.swift'
  end

  # Database
  s.subspec 'Database' do |ss|
    ss.source_files = 'PimineDatabase/*.swift'
    ss.dependency 'Realm'
    ss.dependency 'RealmSwift'
  end

  # Concurrency
  s.subspec 'Concurrency' do |ss|
  	ss.source_files = 'PimineConcurrency/**/*.swift'
  end

end
