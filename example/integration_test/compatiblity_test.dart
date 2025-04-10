import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_miracl_sdk/pigeon.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('test compatiblity of all methods', (WidgetTester tester) async {
      MiraclSdk sdk = MiraclSdk();
      final configuration = MConfiguration(
        projectId: "fd2185bd-d94c-4cd1-bd5e-a5bf558bfd11",
        clientId: "1h5kf3i5l7wff",
        redirectUri: "https://demo.miracl.cloud/casino/activity/",
      );

       await sdk.initSdk(configuration); 
  });
}