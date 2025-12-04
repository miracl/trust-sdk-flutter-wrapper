extension DateTimeUnixTimeExtention on DateTime {
  int get unixtime {
    return (millisecondsSinceEpoch / Duration.millisecondsPerSecond).round();
  }
}