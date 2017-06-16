
Pod::Spec.new do |s|

  s.version      = "6.1.1"

  s.summary      = "XLsn0wKit -> Objective-C Version"

  s.requires_arc = true
  s.license      = 'MIT'
  s.platform     = :ios, "8.0"
  s.author       = { "XLsn0w" => "xlsn0w@outlook.com" }

  s.name         = "XLsn0wKit_objc"
  s.homepage     = "https://github.com/XLsn0w/XLsn0wKit_objc"
  s.source       = { :git => "https://github.com/XLsn0w/XLsn0wKit_objc.git", :tag => s.version.to_s }

  s.source_files = "XLsn0wKit/**/*.{h,m}"

  s.resources    = "XLsn0wKit/Resources/XLsn0wKit_objc.bundle"

  s.frameworks   = "UIKit", "Foundation"

  s.weak_frameworks = "CoreLocation"

  s.dependency "AFNetworking"
  s.dependency "SDWebImage"
  s.dependency "Masonry"
  s.dependency "FMDB"
  s.dependency "Aspects"
  s.dependency "MBProgressHUD"

end
