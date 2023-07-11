import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fractal_flutter/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:xc8/enums/time.dart';
import 'package:xc8/enums/view.dart';

import '../models/app.dart';

class Main8Drawer extends ConsumerWidget {
  const Main8Drawer({super.key});

  @override
  Widget build(context, ref) {
    final app = context.watch<Oo8Fractal>();

    return Drawer(
      child: SafeArea(
        child: VStack(
          spacing: 4,
          [
            HStack([
              Text('Time'),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  height: 20,
                  child: DropdownButton<TimeDisplay>(
                      value: app.timeDisplay,
                      underline: Container(
                        height: 0,
                      ),
                      onChanged: (value) {
                        if (value == null) return;
                        app.timeDisplay = value;
                        app.notifyListeners();
                      },
                      items: [
                        ...TimeDisplay.values.map(
                          (value) => DropdownMenuItem<TimeDisplay>(
                            value: value,
                            child: Text(value.name),
                          ),
                        )
                      ]),
                ),
              ),
            ]),
            HStack([
              Text('View'),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  height: 20,
                  child: DropdownButton<ViewDisplay>(
                      value: app.viewDisplay,
                      underline: Container(
                        height: 0,
                      ),
                      onChanged: (value) {
                        if (value == null) return;
                        app.viewDisplay = value;
                        app.notifyListeners();
                      },
                      items: [
                        ...ViewDisplay.values.map(
                          (value) => DropdownMenuItem<ViewDisplay>(
                            value: value,
                            child: Text(value.name),
                          ),
                        )
                      ]),
                ),
              ),
            ]),
          ],
        ).p8(),
      ),
    );
  }
}
