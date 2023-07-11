import 'dart:convert';

import 'package:data8/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:two8/areas/cube.dart';
import 'package:two8/areas/face.dart';
import 'package:xc8/views/list.dart';
import 'package:yaml_writer/yaml_writer.dart';

import '../widgets/input.dart';

class Cube8View extends ConsumerWidget {
  Event? event;
  Cube8View({super.key});

  static final yamlWriter = YAMLWriter();

  @override
  Widget build(context, ref) {
    return Cube(
      front: Container(
        color: Colors.black.withOpacity(0.9),
        child: List8View(),
      ),
      bottom: event != null
          ? BlockFace(
              key: ValueKey('${event!.id}_left'),
              text: jsonEncode(
                base64Encode(
                  utf8.encode(
                    event!.toJson().toString(),
                  ),
                ),
                //base64
                //widget.event.toJson().toString().,
              ),
            )
          : null,
      left: event != null
          ? BlockFace(
              key: ValueKey('${event!.id}_left'),
              text: yamlWriter.write(event!.toJson()),
            )
          : null,
      right: event != null
          ? BlockFace(
              key: ValueKey('${event!.id}_right'),
              text: jsonEncode(
                event!.toJson(),
              ))
          : null,

      // selected
      back: (event?.file == null)
          ? const BlockFace()
          : Input8State.tipImage(event!.file.trim()),
    );
  }
}
