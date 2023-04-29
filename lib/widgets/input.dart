import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:data8/data.dart';
import 'package:data8/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:url_launcher/url_launcher.dart';
import '../input.dart';
import '../line.dart';
import 'clock.dart';

class Input8Area extends StatefulWidget {
  Function(Map<String, dynamic>)? onSubmit;
  Function(String)? onEdit;

  Event? event;
  bool editable;
  double fontSize;

  Input8Area({
    super.key,
    this.event,
    this.editable = false,
    this.onSubmit,
    this.onEdit,
    this.fontSize = 16,
  });

  @override
  State<Input8Area> createState() => _Input8AreaState();
}

class _Input8AreaState extends State<Input8Area> {
  final ctrl = TextEditingController();
  final focus = FocusNode();

  @override
  void initState() {
    if (widget.event != null) ctrl.text = widget.event!.content;
    ctrl.addListener(() {
      widget.onEdit?.call(ctrl.text);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.editable
          ? Colors.grey.withAlpha(20)
          : (widget.event == null || widget.event!.file.isEmpty)
              ? null
              : Colors.orange.withAlpha(20),
      child: InkWell(
        onTap: () {
          widget.event!.file;
          if (widget.editable) focus.requestFocus();
        },
        onLongPress: () {
          if (widget.event == null || widget.event!.file.isEmpty) return;
          final uri = getUri(widget.event!.file);
          _launchUrl(uri);
        },
        child: Row(children: [
          ClockField(
            time: widget.event?.createdAt ?? 0,
          ),
          Expanded(
            child: RawKeyboardListener(
              onKey: keyboard,
              focusNode: focus,
              child: (widget.event != null &&
                      widget.event!.file.isNotEmpty &&
                      !widget.editable)
                  ? withTip()
                  : row(),
            ),
          ),
          if (widget.event != null && widget.event!.syncAt == 0)
            CircleAvatar(
              radius: 4,
              backgroundColor: Colors.transparent,
              child: CircularProgressIndicator(),
            ),
        ]),
      ),
    );
    /*
          if (widget.editable)
            SizedBox(
              height: 18,
              child: IconButton(
                icon: const Icon(Icons.paste, size: 14),
                iconSize: 12,
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.all(0),
                  ),
                ),
                onPressed: () async {
                  final img = await Pasteboard.image;

                  if (img == null || img.isEmpty) return;
                  upload(img);

                  await FilePickerCross.importFromStorage(
                    type: FileTypeCross.image,
                  ).then((f) async {
                    final _image = f.toUint8List();
                    setState(() {});
                    final hash = sha256.convert(_image);
                    FData.cache[hash.toString()] = _image;

                    ctrl.text = ctrl.text + ' ${hash.toString()} ';
                  });
                },
              ),
            ),
            */
  }

  withTip() => JustTheTooltip(
        key: ValueKey(widget.event!.content),
        tailLength: 10.0,
        triggerMode: TooltipTriggerMode.tap,
        preferredDirection: AxisDirection.down,
        isModal: false,
        hoverShowDuration: Duration(seconds: 1),
        backgroundColor: Colors.grey,
        margin: const EdgeInsets.all(20.0),
        content: tipImage(widget.event!.file.trim()),
        child: row(),
      );

  Widget row() => (widget.editable)
      ? Input8(
          ctrl,
          fontSize: widget.fontSize,
          onSubmit: (value) {
            value = value.trim();
            //if (value.isEmpty) return;
            if (!value.startsWith('.')) {
              final m = {
                'content': value,
                if (file_hash != null) 'file': file_hash.toString(),
              };
              ctrl.clear();
              file_hash = null;
              widget.onSubmit?.call(m);
            }
          },
        )
      : FLine(
          fontSize: widget.fontSize,
          widget.event?.content ?? ctrl.text,
          onSelect: (opt) {
            //app.post(opt);
          },
        );

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Coul not open URL'),
        ),
      );
    }
  }

  tipImage(String? val) {
    if (val == null || val.isEmpty) return Container();
    final bytes = FData.cache[val];
    return bytes != null
        ? Image.memory(bytes)
        : Image.network(
            getUri(val).toString(),
          );
  }

  Uri getUri(String val) {
    final uri = Uri.parse(val);
    if (uri.scheme.isEmpty) {
      return Uri.parse("${FData.getHttp}/uploads/$val");
    }
    return uri;
  }

  keyboard(RawKeyEvent k) async {
    // if paste

    if (k.isControlPressed || k.isMetaPressed) {
      // if u press up or down
      if (k.isKeyPressed(LogicalKeyboardKey.keyV)) {
        final img = await Pasteboard.image;

        if (img == null || img.isEmpty) return;

        //show notification
        upload(img);
      }
    }
  }

  Digest? file_hash;
  upload(Uint8List f) async {
    file_hash = sha256.convert(f);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Uploading ${file_hash.toString()}'),
        backgroundColor: Colors.orange,
      ),
    );

    //ctrl.text = ctrl.text + ' ${file_hash.toString()} ';

    FData.cache[file_hash.toString()] = f;

    var url = Uri.parse(
      "http${FData.isSecure ? 's' : ''}://${FData.host}/upload",
      //"/upload",
    );
    // Create a MultipartRequest object to hold the file data
    var request = MultipartRequest('POST', url);

    request.files.add(MultipartFile.fromBytes(
      'file',
      f,
    ));

    var response = await request.send();

    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Uploaded image: $responseBody'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload image: $responseBody'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
