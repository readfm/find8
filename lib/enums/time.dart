enum TimeDisplay {
  none,
  stamp,
  human,
  ago;

  String get name => toString().split('.').last;
}
