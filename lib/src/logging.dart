import 'package:flutter_miracl_sdk/src/miracl_trust.dart';
import 'dart:developer';

class DefaultLogger implements Logger {
  final LoggingLevel loggingLevel;

  DefaultLogger(this.loggingLevel);

  @override
  void debug(String category, String message) {
    if (loggingLevel.index >= LoggingLevel.debug.index) {
      log("[debug] [$category] $message");
    }
  }

  @override
  void info(String category, String message) {
    if (loggingLevel.index >= LoggingLevel.info.index) { 
      log("[info] [$category] $message");
    }
  }
  
  @override
  void warning(String category, String message) {
    if (loggingLevel.index >= LoggingLevel.warning.index) { 
      log("[warning] [$category] $message");
    }
  }

  @override
  void error(String category, String message) {
    if (loggingLevel.index >= LoggingLevel.error.index) { 
      log("[error] [$category] $message"); 
    }
  }
}