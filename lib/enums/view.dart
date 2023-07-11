import 'package:flutter/material.dart';
import 'package:xc8/views/cube.dart';

import '../views/list.dart';

enum ViewDisplay {
  list,
  cube;

  String get name => toString().split('.').last;

  Widget build(BuildContext context) => switch (this) {
        ViewDisplay.list => List8View(),
        ViewDisplay.cube => Cube8View(),
      };
}
