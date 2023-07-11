import 'package:flutter/material.dart';
import 'package:fractal_flutter/fractal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:xc8/models/app.dart';

class StatusArea extends StatelessWidget {
  const StatusArea({Key? key});

  @override
  Widget build(context) {
    final app = context.watch<Oo8Fractal>();

    return Listen(
      app.connection.isConnected,
      (ctx, child) => Container(
        height: 5,
        color: app.connection.isConnected.value ? Colors.green : Colors.red,
      ),
    );
  }
}
