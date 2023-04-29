import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xc8/models/app.dart';

class StatusArea extends ConsumerWidget {
  const StatusArea({Key? key}) : super(key: key);

  @override
  Widget build(ctx, ref) {
    final app = ref.watch(appProvider),
        connection = ref.watch(
          app.connection,
        );

    return Container(
      height: 5,
      color: connection ? Colors.green : Colors.red,
    );
  }
}
