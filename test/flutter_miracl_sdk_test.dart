import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_miracl_sdk/flutter_miracl_sdk.dart';
import 'package:flutter_miracl_sdk/flutter_miracl_sdk_platform_interface.dart';
import 'package:flutter_miracl_sdk/flutter_miracl_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterMiraclSdkPlatform
    with MockPlatformInterfaceMixin
    implements FlutterMiraclSdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterMiraclSdkPlatform initialPlatform = FlutterMiraclSdkPlatform.instance;

  test('$MethodChannelFlutterMiraclSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterMiraclSdk>());
  });

  test('getPlatformVersion', () async {
    FlutterMiraclSdk flutterMiraclSdkPlugin = FlutterMiraclSdk();
    MockFlutterMiraclSdkPlatform fakePlatform = MockFlutterMiraclSdkPlatform();
    FlutterMiraclSdkPlatform.instance = fakePlatform;

    expect(await flutterMiraclSdkPlugin.getPlatformVersion(), '42');
  });
}
