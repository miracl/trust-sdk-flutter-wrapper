import 'package:example/qr_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_miracl_sdk/flutter_miracl_sdk.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class MircleAuth extends StatefulWidget {
  const MircleAuth({super.key});

  @override
  State<MircleAuth> createState() => _MircleAuthState();
}

class _MircleAuthState extends State<MircleAuth> {
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData?.code == null) return;

      verificationCodeController.text = scanData!.code!;
      setState(() {});
    });
  }

  MIRACLTrust sdk = MIRACLTrust();
  final String userId = "gaurav.test@yopmail.com";
  TextEditingController verificationCodeController = TextEditingController();
  String get verificationURL => verificationCodeController.text;
  Future<void> configure() async {
    final configuration =
        Configuration(projectId: "91c49fa3-c584-44dc-921f-b8c04d8e5abb");
    try {
      await sdk.initSDK(configuration);
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendConfigrationCode() async {
    try {
      final emailVerificationResponse = await sdk.sendVerificationEmail(userId);
      print(emailVerificationResponse);
    } on EmailVerificationException catch (e) {
      print(e);
    }
  }

  String activationToken = "";

  Future<void> checkVerificationUrl() async {
    try {
      final activationTokenResponse =
          await sdk.getActivationTokenByURI(Uri.parse(verificationURL));
      print(activationTokenResponse.activationToken);
      setState(() {
        activationToken = activationTokenResponse.activationToken;
      });
    } on ActivationTokenException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mircle Auth'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () async {
                  await configure();
                  await sendConfigrationCode();
                },
                child: Text("Send Configration Code")),
            Container(
              // clipBehavior: Clip.antiAlias,
              // decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
              height: 300,
              width: 300,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
            Container(
              padding: EdgeInsets.all(12),
              child: Text(verificationURL),
            ),
            ElevatedButton(
                onPressed: () async {
                  await checkVerificationUrl();
                },
                child: Text("Check Verification")),
            Text(activationToken)
          ],
        ),
      ),
    );
  }
}
