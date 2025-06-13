import Flutter
import UIKit
import MIRACLTrust

public class FlutterMiraclSdkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let messenger: FlutterBinaryMessenger = registrar.messenger()
    let mLogger = MLogger(binaryMessenger: messenger)
    let api: MiraclSdk & NSObjectProtocol = SdkHandler(mLogger: mLogger)
    MiraclSdkSetup.setUp(binaryMessenger: messenger, api: api)
  }

}
