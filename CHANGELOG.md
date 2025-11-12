## 0.1.0

* Add concrete exceptions for every operation.

## 0.1.1

* Fix: Convert Android signing timestamp from milliseconds to seconds.

## 0.2.0

* New response objects for SDK operations.

## 0.2.0+1

* Configure the Flutter SDK version as applicationInfo.

## 0.2.0+2

* Remove `collection` package dependency since it is not needed.

## 0.2.0+3

* **Improved Error Handling:** Resolved issues with error name parsing when code is obfuscated or minified by implementing a type-safe exception translation layer between native code and Flutter.

## 0.3.0

This release prepares the API for a future stable version by simplifying and cleaning up several parts of the code.

### Added
- `pinLength` property to the `User` class.

### Changed
- `authenticateWith` methods now return `void` instead of `bool`. They now just throw an exception if something goes wrong.
- Renamed the `invalidUniversalLink` error code to `invalidLink` for a more general name that is correct for both iOS and Android.
- Made all `User` class properties `final` to make them read-only after creation.

### Removed
- The base `MIRACLException` class to simplify exception handling.
- All string messages from exceptions. They were not consistent across platforms, and error codes should be used instead.

## 0.3.1

* Add logging functionality.

## 0.3.2

* Support for Swift Package Manager.

## 0.3.3

* Add option to configure the MIRACL Trust Platform URL.

## 0.4.0

* Make initialization static and keep one instance of MIRACLTrust.

## 0.5.0

* Make Configuration properties private.

## 0.5.1

* Add API documentation.

## 0.5.1+1

* Add sample application.

## 0.5.2

* Update to the new registration API.

## 0.6.0

* Change platformURL to projectUrl.

## 0.7.0

* Remove QuickCode limiting functionality.
