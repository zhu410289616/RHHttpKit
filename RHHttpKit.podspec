Pod::Spec.new do |s|

  s.name         = "RHHttpKit"
  s.version      = "1.0.5"
  s.summary      = "A Http Kit based on AFNetworking."
  s.homepage     = "https://github.com/zhu410289616/RHHttpKit"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "zhu410289616" => "zhu410289616@163.com" }
  s.source       = { :git => "https://github.com/zhu410289616/RHHttpKit.git", :tag => s.version.to_s }

  s.platform     = :ios, "6.0"
  s.source_files  = "RHHttpKit/*.{h,m}"

  s.requires_arc = true
  s.frameworks = "Foundation", "UIKit"

  s.dependency 'libextobjc/EXTScope', '~> 0.4.1'
  s.dependency 'RHCategoryKit', '~> 1.0.2'
  s.dependency 'AFNetworking', '~> 2.5.4'
  s.dependency 'EGOCache', '~> 2.1.3'

end
