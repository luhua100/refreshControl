#
# Be sure to run `pod lib lint HZReFreshControl.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HZReFreshControl'
  s.version          = '0.1.0'
  s.summary          = '一款从原理上分析的刷新组件'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  一款从原理上分析的刷新组件,包括下拉刷新和上拉加载
                       DESC

  s.homepage         = 'https://github.com/luhua100/HZReFreshControl'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'luhua100' => 'luhua2245@163.com' }
  s.source           = { :git => 'https://github.com/luhua100/HZReFreshControl.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.swift_versions = '5.0'
  s.ios.deployment_target = '10.0'

  s.source_files = 'HZReFreshControl/Classes/**/*'
  
  # s.resource_bundles = {
  #   'HZReFreshControl' => ['HZReFreshControl/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
