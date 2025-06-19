import 'package:flutter_miracl_sdk/src/pigeon.dart';
import 'dart:developer';

/// Defines the different levels of verbosity for the MIRACL Trust Flutter
/// plugin's default logger.
/// 
/// **Note:** It has no effect if a custom [Logger] implementation is provided.
enum LoggingLevel {
  /// No logs will be outputted.
  none,

  /// Only error-level logs will be outputted.
  error,

  /// Error and warning logs will be outputted.
  warning,

  /// Error, warning, and informational logs will be outputted.
  info,

  /// All logs, including debug-level information, will be outputted.
  debug;
}

/// A type representing a message logger.
///
/// Some important and useful information from the native Android and iOS SDKs
/// will be outputted through this interface, particularly during development
/// and debugging.
///
/// By default, the MIRACL Trust Flutter plugin uses a concrete
/// implementation of this interface using dart:developer library
/// [log function](https://api.flutter.dev/flutter/dart-developer/log.html).
///
/// See also:
///
///  * [LoggingLevel]
abstract class Logger extends MLogger {
  /// Writes a `debug` level log.
  /// 
  /// Parameters:
  /// - [category]: The component from which the log originates
  /// (e.g., 'Crypto', 'Network').
  /// - [message]: The detailed description of the event being logged.
  @override void debug(String category, String message);
  
  /// Writes an `info` level log.
  /// 
  /// Parameters:
  /// - [category]: The component from which the log originates
  /// (e.g., 'Crypto', 'Network').
  /// - [message]: The detailed description of the event being logged.
  @override void info(String category, String message);
  
  /// Writes a `warning` level log.
  /// 
  /// Parameters:
  /// - [category]: The component from which the log originates
  /// (e.g., 'Crypto', 'Network').
  /// - [message]: The detailed description of the event being logged.
  @override void warning(String category, String message);

  /// Writes an `error` level log.
  /// 
  /// Parameters:
  /// - [category]: The component from which the log originates
  /// (e.g., 'Crypto', 'Network').
  /// - [message]: The detailed description of the event being logged.
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