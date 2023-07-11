import 'package:data8/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fractal_flutter/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../models/app.dart';
import '../providers/filter.dart';
import '../widgets/input.dart';
import '../widgets/status.dart';

class List8View extends ConsumerWidget {
  const List8View({super.key});

  @override
  Widget build(context, ref) {
    final app = context.watch<Oo8Fractal>();
    final events = ref.watch(filteredEventsProvider);
    final now = DateTime.now(), nowSeconds = now.millisecondsSinceEpoch ~/ 1000;

    final grouped = <List<Event>>[];
    for (final event in events.filter((ev) => (ev.expiresAt < nowSeconds))) {
      if (grouped.isEmpty) grouped.add([]);
      if (event.content == '')
        grouped.add([]);
      else
        grouped.last.add(event);
    }

    final first = grouped.removeAt(0);

    return SingleChildScrollView(
        padding: EdgeInsets.only(top: 80),
        child: Column(
          children: [
            const StatusArea(),
            ...events
                .filter((ev) => ev.expiresAt > nowSeconds)
                .map(
                  (event) => Input8Area(
                    //wrap: wrap,
                    key: ValueKey(event.id),
                    event: event,
                    //editable: selected == ++i,
                  ),
                )
                .toList()
                .reversed,
            /*
              QrImage(
                data: app.user.keyPair.publicKey,
                version: QrVersions.auto,
                size: 320,
                gapless: false,
              ),
              */
            Input8Area(
              editable: true, //selected == 0,
              onEdit: (value) {
                final search = ref.read(searchProvider.notifier);
                if (value.startsWith('.') && search.state != value) {
                  search.update(
                    (state) => value.substring(1),
                  );
                } else if (search.state.isNotEmpty) {
                  search.update(
                    (state) => '',
                  );
                }
              },
              onSubmit: (m) {
                app.post(m);
                /*
                      if (value.startsWith('.') && search != value) {
                        filter(
                          value.substring(1),
                        );
                      } else if (search.isNotEmpty) {
                        filter();
                      }
                      */
              },
            ),
            /*
            ElevatedButton(
              onLongPress: () {
                setState(() {
                  cube = !cube;
                });
              },
              onPressed: () {
                app.thingsLayout = ThingsLayout.values[
                    (app.thingsLayout.index + 1) % ThingsLayout.values.length];
                app.notifyListeners();
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.all(0),
                ),
              ),
              child: Text(app.thingsLayout.name),
            ),
            */

            ...first.map(
              (event) => Input8Area(
                //wrap: wrap,
                key: ValueKey(event.id),
                event: event,
                //editable: selected == ++i,
              ),
            ),
            ...events.filter((ev) => ev.expiresAt <= nowSeconds).map(
                  (event) => Input8Area(
                    //wrap: wrap,
                    key: ValueKey(event.id),
                    event: event,
                    //editable: selected == ++i,
                  ),
                ),
            /*
        if (app.thingsLayout == ThingsLayout.json ||
            app.thingsLayout == ThingsLayout.yaml)
          VStack(
            [
              ...events.map(
                (event) => Text(
                  (app.thingsLayout == ThingsLayout.yaml)
                      ? yamlWriter.write(event.toJson())
                      : jsonEncode(
                          event.toJson(),
                        ),
                  softWrap: true,
                ),
              ),
            ],
          )
        else
          Accordion(
            paddingListTop: 0,
            paddingListBottom: 0,
            contentHorizontalPadding: 0,
            contentVerticalPadding: 0,
            headerBackgroundColor: Colors.transparent,
            contentBackgroundColor: Colors.grey.shade800,
            contentBorderWidth: 0,
            paddingBetweenClosedSections: 0,
            paddingBetweenOpenSections: 0,
            paddingListHorizontal: 0,
            scaleWhenAnimating: false,
            children: [
              ...grouped.map(
                (list) => AccordionSection(
                  paddingBetweenOpenSections: 0,
                  content: RawKeyboardListener(
                    onKey: keyboard,
                    focusNode: focus,
                    child: Column(
                      children: [
                        ...list.map(
                          (event) => Input8Area(
                            wrap: wrap,
                            key: ValueKey(event.id),
                            event: event,
                            //editable: selected == ++i,
                          ),
                        ),
                        /*
              QrImage(
                data: app.user.keyPair.publicKey,
                version: QrVersions.auto,
                size: 320,
                gapless: false,
              ),
              */
                      ],
                    ),
                  ),
                  header: Text(
                    list.length.toString(),
                  ),
                ),
              ),
            ],
          ),
          */
          ],
        ));
  }
}
