# Uncomment the next line to define a global platform for your project
platform :ios, '16.0'

target 'FavBook' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FavBook
  pod 'Alamofire', '~> 5.8.1'
  pod 'SDWebImage', '~> 5.18.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
      config.build_settings['ENABLE_USER_SCRIPT_SANDBOXING'] = 'NO'
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = ''
      config.build_settings['ARCHS'] = '$(ARCHS_STANDARD)'
    end
  end
end
