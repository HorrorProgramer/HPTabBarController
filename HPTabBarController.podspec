#
# Be sure to run `pod lib lint HPTabBarController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HPTabBarController'
  s.version          = '0.1.0'
  s.summary          = 'Custom HPTabBarController.'

  s.description      = <<-DESC
  According Third Lib TabBarController To Creat HPTabBarController
                       DESC

  s.homepage         = 'git@github.com:syika/ABCTabBarController.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'PangJunJie' => 'xwhnnd@163.com' }
  s.source           = { :git => 'git@github.com:syika/ABCTabBarController.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.default_subspec = 'TabBarController'
  
  s.subspec 'TabBarController' do |tb|
      tb.source_files = 'HPTabBarController/Classes/TabBarController/**/*'
      tb.dependency 'HPTabBarController/TabBarViews'
  end
  
  s.subspec 'TabBarViews' do |vw|
      vw.source_files = 'HPTabBarController/Classes/TabBarViews/**/*'
  end
  
  # s.resource_bundles = {
  #   'HPTabBarController' => ['HPTabBarController/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
