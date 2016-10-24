Pod::Spec.new do |spec|
  spec.name                 = 'Fujifilm-SPA-SDK'
  spec.version              = '1.0.5'
  spec.summary              = "Enable photo product output through Fujifilm! Access over 50 photo products and control the availability and pricing through fujifilmapi.com"
  spec.description          = <<-DESC
                            Enable photo product output through Fujifilm! Gives you access to over 50 popular photo gift products and allows you to control the availability and pricing of each product through our web portal. Please visit http://www.fujifilmapi.com to sign-up and obtain an API key, set product pricing, and configure your application.
                            DESC
  spec.homepage             = 'https://github.com/fujifilmssd/iOS-Fujifilm-SPA-SDK-SampleApp'
  spec.license              = { :type => 'MIT', :file => 'LICENSE.md' }
  spec.author               = {'Jonathan Nick' => 'jnick@fujifilm.com'}
  spec.source               = {:git => 'https://github.com/fujifilmssd/iOS-Fujifilm-SPA-SDK-SampleApp.git', :tag => spec.version.to_s }
  spec.platform             = :ios, '7.0'
  spec.requires_arc         = true
  spec.source_files         = ['Fujifilm_SPA_SDK_iOS_DemoApp/Fujifilm.SPA.SDK.h']
  spec.public_header_files  = 'Fujifilm_SPA_SDK_iOS_DemoApp/Fujifilm.SPA.SDK.h'
  spec.preserve_paths       = "Fujifilm_SPA_SDK_iOS_DemoApp/libFujifilm_SPA_SDK_iOS.a"
  spec.ios.vendored_library = "Fujifilm_SPA_SDK_iOS_DemoApp/libFujifilm_SPA_SDK_iOS.a"
  spec.frameworks = 'AddressBook', 'AddressBookUI', 'MobileCoreServices', 'SystemConfiguration', 'AssetsLibrary', 'ImageIO', 'Photos'
end
