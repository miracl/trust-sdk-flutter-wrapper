# MIRACL Trust Flutter Plugin

The MIRACL Trust Flutter Plugin provides the following functionalities:

- [User ID Verification](#user-id-verification)
- [Registration](#registration)
- [Authentication](#authentication)
- [Signing](#signing)
- [QuickCode](#quickcode)

This plugin implements method-channel communication with
MIRACL’s iOS and Android SDKs. It leverages the
[Pigeon](https://pub.dev/packages/pigeon) framework to
generate type-safe method-channel communication.

## System Requirements

- iOS 13+
- Android API 21+

## Installation

Add flutter_miracl_sdk to `pubspec.yaml`:

```yaml
dependencies:
  flutter_miracl_sdk: 
    git:
      url: https://github.com/miracl/trust-sdk-flutter-wrapper
```

## **Android Setup**

Add the MIRACL Trust Android SDK Мaven repository to the code
section in `project/android/build.gradle` shown below:

```gradle
allprojects {
    repositories {
        google()
        mavenCentral()
        maven {
            url = uri("https://maven.pkg.github.com/miracl/trust-sdk-android")
        }
    }
}
```

## Usage

### Import

Add this import to your `dart` file:

```dart
import 'package:flutter_miracl_sdk/pigeon.dart';
```

### SDK Configuration

Configure the plugin as shown below:

```dart
final configuration = MConfiguration(
    projectId: "YOUR_PROJECT_ID"
);
await sdk.initSdk(configuration);
```

Call the `initSdk` method as early as possible in the application
lifecycle, and avoid using the other methods before that; otherwise,
an assertion will be triggered.

### User ID Verification

To register a new User ID, you need to verify it. MIRACL
offers two options for that:

- [Custom User Verification](https://miracl.com/resources/docs/guides/custom-user-verification/)
- [Built-in User Verification](https://miracl.com/resources/docs/guides/built-in-user-verification/)

  With this type of verification, the end user's email address
  serves as the User ID. Currently, MIRACL Trust provides two kinds of built-in
  email verification methods:

  - [Email Link](https://miracl.com/resources/docs/guides/built-in-user-verification/email-link/)
    (default)
  - [Email Code](https://miracl.com/resources/docs/guides/built-in-user-verification/email-code/)

  Start the verification by calling the `sendVerificationEmail`
  method:

  ```dart
  final emailVerificationResponse = await sdk.sendVerificationEmail(userId);
  ```

  Then, a verification email is sent, and a
  `MEmailVerificationResponse`
  with backoff and email verification method is returned.

  If the verification method you have chosen for your project is:

  - **Email Code:**

    You must check the email verification method in the response.

    - If the end user is registering for the first time or resetting their PIN,
      an email with a verification code will be sent, and the email
      verification method in the response will be
      `MEmailVerificationMethod.code`.
      Then, ask the user to enter the code in the application.

    - If the end user has already registered another device with the same
      User ID, a Verification URL will be sent, and the verification method in
      the response will be
      `MEmailVerificationMethod.link`.
      In this case, proceed as described for the **Email Link** verification
      method below.

  - **Email Link:** Your application must open when the end user follows
    the Verification URL in the email. To ensure proper deep linking behaviour
    on mobile applications, check this [guide](https://docs.flutter.dev/ui/navigation/deep-linking)
    package.

### Registration

1. To register the mobile device, get an activation token. This happens in two
different ways, depending on the type of verification.

   - [Custom User Verification](https://miracl.com/resources/docs/guides/custom-user-verification/)
     or [Email Link](https://miracl.com/resources/docs/guides/built-in-user-verification/email-link/):

      After the application recieves the Verification URL, it must confirm the
      verification by passing it to the `getActivationTokenByURI` method:

      ```dart
      final activationTokenResponse = await sdk.getActivationTokenByURI(verificationURL);
      ```

      Call this method after the deep link is handled in the application.
      You can find a guide for handling deep links
      [here](https://docs.flutter.dev/ui/navigation/deep-linking).

   - [Email Code](https://miracl.com/resources/docs/guides/built-in-user-verification/email-code/):

      When the end user enters the verification code, the application must
      confirm the verification by passing it to the
      `getActivationTokenByUserIdAndCode`
      method:

      ```dart
      final activationTokenResponse = 
           await sdk.getActivationTokenByUserIdAndCode(userId, code);
      ```

2. Pass the User ID (email or any string you use for identification), activation
   token (received from verification) and the user-entered PIN code to the `register`
   method:

   ```dart
   final user = await sdk.register(
      userId, 
      activationTokenResponse.activationToken, 
      pin, 
      null
   );
   ```

   If you call the `register` method with the same User ID more
   than once, the User ID will be overridden. Therefore, you can
   use it to reset your authentication PIN code.

### Authentication

The MIRACL Trust SDK offers two options:

- [Authenticate users on the mobile application](#authenticate-users-on-the-mobile-application)
- [Authenticate users on another application](#authenticate-users-on-another-application)

#### Authenticate users on the mobile application

The `authenticate` method generates a [JWT](https://jwt.io) authentication
token for а registered user.

```dart
final token = await sdk.authenticate(user, pin);
```

After the JWT authentication token is generated, it must be sent to the
application server for verification. Then, the application server verifies the
token signature using the MIRACL Trust
[JWKS](https://api.mpin.io/.well-known/jwks) endpoint and the `audience` claim,
which in this case is the application Project ID.

#### Authenticate users on another application

There are three options for authenticating a user on another application:

- Authenticate with deep link:

  Use the `authenticateWithLink` method:

  ```dart

  final isAuthenticated = sdk.authenticateWithLink(user, link, pin)
  ```

  For information about handling deep links, see this [guide](https://docs.flutter.dev/ui/navigation/deep-linking).

- Authenticate with a QR code

  Use the `authenticateWithQrCode` method:

  ```dart
  final isAuthenticated = await sdk.authenticateWithQrCode(user, qrURL, pin)
  ```

- Authenticate with push notifications payload:

  Use the `authenticateWithNotificationPayload`:

  ```dart
  final isAuthenticated = sdk.authenticateWithNotificationPayload(payload, pin)
  ```

For more information about authenticating users on custom applications, see
[Cross-Device Authentication](https://miracl.com/resources/docs/guides/how-to/custom-mobile-authentication/).

### Signing

DVS stands for Designated Verifier Signature, which is a protocol for
cryptographic signing of documents. For more information, see
[Designated Verifier Signature](https://miracl.com/resources/docs/concepts/dvs/).
In the context of this plugin, we refer to it as 'Signing'.

To sign a document, use the `sign` method as follows:

```dart
final signingResult = await sdk.sign(user, message, pin);
```

The signature must be verified by sending it to the application server, which then
makes a call to the
[POST /dvs/verify](https://miracl.com/resources/docs/guides/dvs/dvs-web-plugin/#api-reference)
endpoint. If the MIRACL Trust platform returns a status code 200, the certificate
entry in the response body indicates that the signing is successful.

### QuickCode

[QuickCode](https://miracl.com/resources/docs/guides/built-in-user-verification/quickcode/)
is a way to register another device without going through the verification process.

To generate a QuickCode, call the `generateQuickCode` method with
an already registered `MUser` object:

```dart
final quickCode = await sdk.generateQuickCode(mUser, pin); 
```

## FAQ

1. What is Activation Token?

   Activation Token is the value that links the verification flow with the
   registration flow. The value is returned by the verification flow and needs
   to be passed to the
   [register](https://miracl.com/resources/docs/apis-and-libraries/ios/classes/MIRACLTrust/#registerforactivationtokenpushnotificationstokendidrequestpinhandlercompletionhandler)
   method so the platform can verify it. Here are the options for that:

   - [Custom User Verification](https://miracl.com/resources/docs/guides/custom-user-verification/)
   - [Built-in User Verification](https://miracl.com/resources/docs/guides/built-in-user-verification/)

2. What is Project ID?

   Project ID is a common identifier of applications in the MIRACL Trust
   platform that share a single owner.

   You can find the Project ID value in the MIRACL Trust Portal:

   1. Go to [trust.miracl.cloud](https://trust.miracl.cloud).
   1. Log in or create a new User ID.
   1. Select your project.
   1. In the CONFIGURATION section, go to **General**.
   1. Copy the **Project ID** value.
  