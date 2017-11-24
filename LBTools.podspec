#
# Be sure to run `pod lib lint LBTools.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LBTools'
  s.version          = '0.1.0'
  s.summary          = '自己封装的控件'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
LBTools.自己封装的控件和一些工具类
                       DESC

  s.homepage         = 'https://github.com/zblbolin/LBSegmentBar'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '812920365@qq.com' => '卟师' }
  s.source           = { :git => 'https://github.com/zblbolin/LBSegmentBar.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

#s.source_files = 'LBTools/Classes/**/*'
    s.subspec 'Base' do |b|
        b.source_files = 'LBTools/Classes/Base/*'
    end
  # s.resource_bundles = {
  #   'LBTools' => ['LBTools/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
