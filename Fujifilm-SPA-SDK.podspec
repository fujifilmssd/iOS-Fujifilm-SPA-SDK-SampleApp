Pod::Spec.new do |spec|
  spec.name                 = 'Fujifilm-SPA-SDK'
  spec.version              = '2.4.0'
  spec.summary              = "Enable photo product output with Fujifilm! Access over 100 photo products and control the availability and pricing through fujifilmapi.com"
  spec.description          = <<-DESC
                            Enable photo product output through Fujifilm! Gives you access to over 100 popular photo gift products and allows you to control the availability and pricing of each product through our web portal. Please visit http://www.fujifilmapi.com to sign-up and obtain an API key, set product pricing, and configure your application.
                            DESC
  spec.homepage             = 'https://github.com/fujifilmssd/iOS-Fujifilm-SPA-SDK-SampleApp'
  spec.license              = { :type => 'MIT', :file => 'LICENSE.md' }
  spec.author               = {'Sam Friedman' => 'sam.friedman@fujifilm.com'}
  spec.source               = {:http => "https://github.com/fujifilmssd/iOS-Fujifilm-SPA-SDK-SampleApp/releases/download/#{spec.version.to_s}/Fujifilm_SPA_SDK_iOS-Pods.zip"}

  spec.ios.deployment_target = '14.0'
  spec.requires_arc         = true
  spec.default_subspec = 'Braintree'
  spec.subspec 'Braintree' do |braintree|
    braintree.dependency 'Braintree', '~> 6.32'
    braintree.vendored_frameworks = 'Braintree/Fujifilm_SPA_SDK_iOS.xcframework', 'FFImagePicker2.xcframework'
  end
  spec.subspec 'Lite' do |lite|
    lite.vendored_frameworks = 'Lite/Fujifilm_SPA_SDK_iOS.xcframework', 'FFImagePicker2.xcframework'
  end
  spec.frameworks = 'AddressBook', 'AddressBookUI', 'MobileCoreServices', 'SystemConfiguration', 'AssetsLibrary', 'ImageIO', 'Photos'
end
