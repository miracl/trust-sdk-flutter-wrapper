import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_miracl_sdk_method_channel.dart';

abstract class FlutterMiraclSdkPlatform extends PlatformInterface {
  /// Constructs a FlutterMiraclSdkPlatform.
  FlutterMiraclSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterMiraclSdkPlatform _instance = MethodChannelFlutterMiraclSdk();

  /// The default instance of [FlutterMiraclSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterMiraclSdk].
  static FlutterMiraclSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterMiraclSdkPlatform] when
  /// they register themselves.
  static set instance(FlutterMiraclSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
