import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fractal_flutter/provider.dart';
import 'package:timeago_flutter/timeago_flutter.dart';
import 'package:xc8/enums/time.dart';
import 'package:xc8/models/app.dart';

import 'time.dart';

class ClockField extends ConsumerStatefulWidget {
  int time;
  ClockField({super.key, this.time = 0});

  @override
  createState() => _ClockFieldState();
}

class _ClockFieldState extends ConsumerState<ClockField> {
  Timer? timer;
  @override
  void initState() {
    super.initState();

    if (widget.time == 0) {
      timer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) {
          setState(() {});
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.read<Oo8Fractal>();
    final now = DateTime.now(), nowSeconds = now.millisecondsSinceEpoch ~/ 1000;
    //seconds
    return switch (app.timeDisplay) {
      TimeDisplay.stamp => Time8Field(
          widget.time == 0
              ? (DateTime.now().millisecondsSinceEpoch ~/ 1000)
              : widget.time,
        ),
      TimeDisplay.none => SizedBox(width: 1),
      TimeDisplay.human => Container(
          width: 80,
          child: Text(
            widget.time == 0
                ? DateTime.now().toString().split(' ')[1].split('.')[0]
                : DateTime.fromMillisecondsSinceEpoch(widget.time * 1000)
                    .toString()
                    .split('.')[0],
            style: const TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 175, 175, 175),
            ),
          ),
        ),
      TimeDisplay.ago => Container(
          width: 30,
          child: widget.time == 0
              ? Text('now')
              : Timeago(
                  locale: 'en_short',
                  builder: (_, value) => Text(
                    value,
                  ),
                  date: DateTime.fromMillisecondsSinceEpoch(
                    widget.time * 1000,
                  ),
                  allowFromNow: true,
                ),
        ),
    };
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
