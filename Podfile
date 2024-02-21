# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'Promise' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Promise
  pod 'FloatingPanel'
  pod 'SwiftGen', '~> 6.0'
  pod 'NMapsMap'

  target 'PromiseTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'PromiseUITests' do
    # Pods for testing
  end
  
  post_install do |installer|
    installer.generated_projects.each do |project|
      project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
        end
      end
    end
  end

end
