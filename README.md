# MIRACL TRUST
## **Steps to install plugin**

Add flutter_miracl_sdk to `pubspec.yaml`
```
dependencies:
  flutter_miracl_sdk: 
    git:
        url: https://github.com/miracl/trust-sdk-flutter-wrapper.git
```


Run this command:
```
flutter pub get
```

## **Android Setup**
* Add MIRACL Trust Android SDK `maven` repository to below code section
in project/android/build.gradle
```
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
## **iOS Setup**
* Not additional setup required
---

## SDK Methods implemented
* initSdk
* setProjectId
* sendVerificationEmail
* getActivationTokenByURI
* getActivationTokenByUserIdAndCode
* register
* generateQuickCode
* authenticate
* authenticateWithQrCode
* authenticateWithLink
* authenticateWithNotificationPayload
* sign
* getAuthenticationSessionDetailsFromQRCode
* getAuthenticationSessionDetailsFromLink
* getAuthenticationSessionDetailsFromPushNofitifactionPayload
* getSigningDetailsFromQRCode
* getSigningSessionDetailsFromLink
* getUsers
* getUser
* delete