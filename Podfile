# Uncomment the next line to define a global platform for your project
# platform :ios, '11.0'

target 'Nasa Image' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for NasaImage
  pod 'Alamofire', '4.8.2'
  pod 'SwiftyJSON', '~> 4.0'
	pod 'SwiftLint'
	pod 'Firebase/Core'
	pod 'Firebase/Database'
	pod 'Firebase/Analytics'
	pod 'Fabric', '~> 1.10.1'
	pod 'Crashlytics', '~> 3.13.1'
	pod 'Firebase/Auth'

  target 'NasaImageTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'NasaImageUITests' do
    inherit! :search_paths
    # Pods for testing
  end
	
	target 'NasaImage-Extension' do
		# Added here event though the target only imports MyAppKit but it worked
		pod 'Alamofire', '4.8.2'
		pod 'SwiftLint'
	end

end
