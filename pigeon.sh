dart run pigeon \
  --input pigeon/sdk_types.dart \
  --dart_out lib/src/pigeon.dart \
  --swift_out ios/flutter_miracl_sdk/Sources/flutter_miracl_sdk/Pigeon.swift \
  --kotlin_out android/src/main/kotlin/com/miracl/trust/flutter_miracl_sdk/Pigeon.kt \
  --kotlin_package "com.miracl.trust.flutter_miracl_sdk"