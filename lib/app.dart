import 'dart:convert';
import 'dart:ui';

import 'package:accordion/accordion.dart';
import 'package:data8/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fractal_flutter/fractal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_provider/flutter_provider.dart';
import 'package:two8/areas/cube.dart';
import 'package:two8/areas/face.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:xc8/drawers/main.dart';
import 'package:yaml_writer/yaml_writer.dart';
import 'enums/things.dart';
import 'models/app.dart';
import 'providers/filter.dart';
import 'types/wrap.dart';
import 'widgets/input.dart';
import 'widgets/status.dart';

class Oo8App extends ConsumerStatefulWidget {
  createState() => Oo8AppState();
}

class Oo8AppState extends ConsumerState<Oo8App> {
  final list = <TextEditingController>[];
  final ctrlExpires = TextEditingController();

  Gen? wrap;

  @override
  void initState() {
    ctrlExpires.text = '0';
    /*
    controller
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            urlCtrl.text = url;
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (false && request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      );
      */
  }

  final focus = FocusNode();

  /*
  late final _ctrlPrvKey =
      TextEditingController(text: app.user.keyPair.privateKey);

  late final _ctrlPubKey =
      TextEditingController(text: app.user.keyPair.publicKey);
  */
  /*
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..loadRequest(Uri.parse('https://nostrica.com'));
  */

  // gravity is our present moment, everything else is electromagnetic potential synchronizing into

  bool cube = false;

  final pad = 56.0;

  @override
  Widget build(context) {
    int i = 0;
    print('reApp');

    final app = context.watch<Oo8Fractal>();
    final event = app.selected;

    return Scaffold(
      appBar: PreferredSize(
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.black.withOpacity(0.2),
            ),
          ),
        ),
        preferredSize: Size(
          double.infinity,
          pad,
        ),
      ),
      drawer: Main8Drawer(),
      extendBodyBehindAppBar: true,
      body: app.viewDisplay.build(context),
      //),
    );
  }

  double slider = 8;

  keyboard(RawKeyEvent k) {
    // if u hold option key
    /*
    if (k.isAltPressed) {
      // if u press up or down
      if (k.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
        if (selected == 0) return;
        setState(() {
          final index = selected - 1;
          final active = events[index];
          events[index] = events[index - 1];
          events[index - 1] = active;
          selected = index;
        });
      } else if (k.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
        setState(() {
          final index = selected - 1;
          final active = events[index];
          events[index] = events[index + 1];
          events[index + 1] = active;
          selected = index + 2;
        });
      }
    } else if (k.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
      if (selected > 0) {
        setState(() {
          selected--;
        });
      }
    } else if (k.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
      if (selected < events.length) {
        setState(() {
          selected++;
        });
      }
    }
    */
  }

/*
  ListView.builder(
  itemBuilder: (context, index) => buildRow(index),
  itemCount: trackList.length,
),
*/

/*
  Widget buildRow(int index) {
    final track = trackList[index];
    ListTile tile = ListTile(
      title: Text('${track.getName()}'),
    );
    Draggable draggable = LongPressDraggable<Track>(
      data: track,
      axis: Axis.vertical,
      maxSimultaneousDrags: 1,
      child: tile,
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: tile,
      ),
      feedback: Material(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
          child: tile,
        ),
        elevation: 4.0,
      ),
    );

    return DragTarget<Track>(
      onWillAccept: (track) {
        return trackList.indexOf(track) != index;
      },
      onAccept: (track) {
        setState(() {
          int currentIndex = trackList.indexOf(track);
          trackList.remove(track);
          trackList.insert(currentIndex > index ? index : index - 1, track);
        });
      },
      builder: (BuildContext context, List<Track> candidateData,
          List<dynamic> rejectedData) {
        return Column(
          children: <Widget>[
            AnimatedSize(
              duration: Duration(milliseconds: 100),
              vsync: this,
              child: candidateData.isEmpty
                  ? Container()
                  : Opacity(
                      opacity: 0.0,
                      child: tile,
                    ),
            ),
            Card(
              child: candidateData.isEmpty ? draggable : tile,
            )
          ],
        );
      },
    );
  }
  */
}
