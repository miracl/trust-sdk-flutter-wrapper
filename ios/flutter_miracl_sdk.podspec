#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_miracl_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_miracl_sdk'
  s.version          = '0.3.1'
  s.summary          = 'MIRCAL Trust Flutter plugin'
  s.description      = <<-DESC
MIRCAL Trust Flutter plugin.
                       DESC
  s.homepage         = 'https://github.com/miracl/trust-sdk-flutter-wrapper'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'MIRACL' => 'support@miracl.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
  s.public_header_files = 'Classes/**/*.h'

  s.preserve_paths = 'MIRACLTrust.xcframework'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-framework MIRACLTrust' }
  s.vendored_frameworks = 'MIRACLTrust.xcframework'
  s.framework = 'MIRACLTrust'

end
