#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint system_idle.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'system_idle_macos'
  s.version          = '1.0.0'
  s.summary          = 'A plugin to determine when and for how long the user idles.'
  s.description      = <<-DESC
This plugin is a method-channel-based plugin and requires Flutter.
                       DESC
  s.homepage         = 'https://pub.dev/packages/system_idle'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'DevTalents' => 'hello@devtalents.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
