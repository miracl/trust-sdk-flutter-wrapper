import 'package:flutter_miracl_sdk/src/pigeon.dart';
import 'dart:developer';

enum LoggingLevel {
  none,
  error,
  warning,
  info,
  debug;
}

abstract class Logger extends MLogger{
  @override void debug(String category, String message);
  @override void info(String category, String message);
  @override void warning(String category, String message);
  @override void error(String category, String message);
}


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