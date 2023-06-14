# MIRACL TRUST
## **Steps to install plugin**

Add flutter_miracl_sdk to `pubspec.yaml`
```
dependencies:
  flutter_miracl_sdk: 
    git:
        url: https://example.com/project.git
```


Run this command:
```
flutter pub get
```

## **Android Setup**
* Create libs folder inside your project/android folder
* Copy `miracl-sdk.aar` to project/android/libs folder
* Add `flatDir` to below code section in project/android/build.gradle
```
allprojects {
    repositories {
        google()
        mavenCentral()
        flatDir {
            dir 'libs'
        }
    }
}
```
## **iOS Setup**
* Not additional setup required
---

## SDK Methods implemented
* initSdk
* sendVerificationEmail
* getActivationToken
* getUsers
* register
* authenticate
* getAuthenticationSessionDetailsFromQRCode
* delete
* generateQuickCode
* signingRegister
* sign
* authenticateWithQrCode
* getAuthenticationIdentity
* authenticateWithNotificationPayload