Pod::Spec.new do |s|
  s.name             = "OHQBImagePicker"
  s.version          = "1.0.12"
  s.summary          = "A clone of QBImagePicker (v3.4.0) with multiple selection support."
  s.homepage         = "https://github.com/owjhart/QBImagePicker"
  s.license          = "MIT"
  s.author           = { "owjhart" => "owenjhart@gmail.com" }
  s.source           = { :git => "https://github.com/owjhart/QBImagePicker.git", :tag => s.version.to_s }
  s.source_files     = "OHQBImagePicker/*.{h,m}"
  s.resource_bundles = { "OHQBImagePicker" => "OHQBImagePicker/*.{lproj,storyboard,xib}" }
  s.platform         = :ios, "8.0"
  s.requires_arc     = true
  s.frameworks       = "Photos"
end
