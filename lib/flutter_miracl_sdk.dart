// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'package:flutter_miracl_sdk/pigeon.dart';

import 'flutter_miracl_sdk_platform_interface.dart';

class FlutterMiraclSdk {
  final MiraclSdk _sdk = MiraclSdk();
  void initSdk(MConfiguration configuration) {
    _sdk.initSdk(configuration);
  }

  Future<bool> sendRegistrationMail(String userId) {
    return _sdk.sendVerificationEmail(userId);
  }

  Future<String?> getPlatformVersion() {
    return FlutterMiraclSdkPlatform.instance.getPlatformVersion();
  }

  
}
