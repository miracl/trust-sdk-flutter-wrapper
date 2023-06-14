flutter pub run pigeon \
  --input pigeon/sdk_types.dart \
  --dart_out lib/pigeon.dart \
  --swift_out ios/Classes/Pigeon.swift \
  --kotlin_out android/src/main/kotlin/com/miracl/trust/flutter_miracl_sdk/Pigeon.kt \
  --kotlin_package "com.miracl.trust.flutter_miracl_sdk"