import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_miracl_sdk_platform_interface.dart';

/// An implementation of [FlutterMiraclSdkPlatform] that uses method channels.
class MethodChannelFlutterMiraclSdk extends FlutterMiraclSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_miracl_sdk');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
