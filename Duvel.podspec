#
# Be sure to run `pod lib lint Duvel.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Duvel'
  s.version          = '0.3.0'
  s.summary          = 'Use Core Data in a more friendly way with Swift.'
  s.description      = <<-DESC
Duvel contains a set of functions and utlities that make it easier for you to use Core Data in Swift.

This pod will make it easier to:
- Create a context
- Insert, update and delete objects.
- Perform fetch requests.
                       DESC

  s.homepage         = 'https://github.com/icapps/ios-duvel'
  s.license          = { type: 'MIT', file: 'LICENSE' }
  s.author           = { 'Jelle Vandebeeck' => 'jelle@fousa.be' }
  s.source           = { git: 'https://github.com/icapps/ios-duvel.git', tag: s.version.to_s }
  s.social_media_url = 'https://twitter.com/icapps'

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'

  s.source_files = 'Sources/**/*'
end
