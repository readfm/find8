import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:data8/data.dart';
import 'package:data8/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fractal_flutter/provider.dart';
import 'package:http/http.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:timeago_flutter/timeago_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../input.dart';
import '../line.dart';
import '../models/app.dart';
import '../screens/cube.dart';
import '../types/wrap.dart';
import 'clock.dart';

class Input8Area extends StatefulWidget {
  Function(Map<String, dynamic>)? onSubmit;
  Function(String)? onEdit;

  Event? event;
  bool editable;
  double fontSize;
  Gen? wrap;

  Input8Area({
    super.key,
    this.event,
    this.wrap,
    this.editable = false,
    this.onSubmit,
    this.onEdit,
    this.fontSize = 14,
  });

  @override
  State<Input8Area> createState() => Input8State();
}

class Input8State extends State<Input8Area> {
  final ctrl = TextEditingController();
  final focus = FocusNode();

  Gen get wrap => widget.wrap ?? ((w) => w());

  @override
  void initState() {
    if (widget.event != null) ctrl.text = widget.event!.content;
    ctrl.addListener(() {
      widget.onEdit?.call(ctrl.text);
    });
    super.initState();
  }

  String add = '';

  double hPad = 0;
  bool hide = false;

  checkState() {
    if (hPad > 90) {
      setState(() {
        hide = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<Oo8Fractal>();
    final now = DateTime.now(), nowSeconds = now.millisecondsSinceEpoch ~/ 1000;

    return Visibility(
      visible: !hide,
      child: wrap(() => Container(
            padding: EdgeInsets.only(
              left: hPad > 0 ? hPad : 0,
              right: hPad < 0 ? -hPad : 0,
            ),
            color: widget.editable
                ? Colors.grey.withAlpha(20)
                : (widget.event == null || widget.event!.file.isEmpty)
                    ? null
                    : Colors.orange.withAlpha(20),
            child: GestureDetector(
              onHorizontalDragUpdate: (d) {
                if (!widget.editable) {
                  setState(() {
                    hPad += d.delta.dx;
                    checkState();
                  });
                }
              },
              onHorizontalDragEnd: (d) {
                setState(() {
                  hPad = 0;
                });
              },
              child: InkWell(
                onTap: () {
                  if (widget.editable) focus.requestFocus();

                  app.selected = widget.event!;
                  app.notifyListeners();
                  /*
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return CubeScreen(widget.event!);
            }));
            */
                },
                onSecondaryTap: openFile,
                onLongPress: openFile,
                child: Row(children: [
                  //(widget.event != null)
                  InkWell(
                    onTap: () {
                      if (widget.editable)
                        setState(() {
                          if (add == '')
                            add = '8s';
                          else if (add == '8s')
                            add = '8m';
                          else if (add == '8m')
                            add = '8h';
                          else if (add == '8h') add = '';
                        });
                    },
                    child: ClockField(
                      time: /*(widget.event?.expiresAt ?? 0) > 0
                  ? widget.event!.expiresAt
                  : */
                          widget.event?.createdAt ?? 0,
                    ),
                  ),
                  if (add != '')
                    Text(
                      '+ $add',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  /*
                : Timeago(
                    builder: (_, value) => Text(
                      value,
                      style: TextStyle(
                        color: Colors.orange,
                      ),
                    ),
                    locale: 'en_short',
                    date: DateTime.fromMillisecondsSinceEpoch(
                      ((widget.event?.expiresAt ?? 0) > 0
                              ? widget.event!.expiresAt
                              : widget.event!.createdAt) *
                          1000,
                    ),
                    allowFromNow: true,
                  ),*/
                  Expanded(
                    child: RawKeyboardListener(
                      onKey: keyboard,
                      focusNode: focus,
                      child: (widget.event != null &&
                              widget.event!.file.isNotEmpty)
                          ? withImg()
                          : row(),
                    ),
                  ),
                  if (!widget.editable &&
                          widget.event != null &&
                          widget.event!.expiresAt >
                              0 /* &&
                widget.event!.expiresAt < nowSeconds*/
                      )
                    Timeago(
                      locale: 'en_short',
                      builder: (_, value) => Text(
                        value,
                        style: TextStyle(
                          color: widget.event!.expiresAt > nowSeconds
                              ? Colors.orange
                              : Colors.red,
                        ),
                      ),
                      date: DateTime.fromMillisecondsSinceEpoch(
                        widget.event!.expiresAt * 1000,
                      ),
                      allowFromNow: true,
                    ),
                  /*
            if (widget.event != null &&
                widget.event!.file.isNotEmpty &&
                !widget.editable)
              img(),*/
                  if (widget.event != null && widget.event!.syncAt == 0)
                    const CircleAvatar(
                      radius: 4,
                      backgroundColor: Colors.transparent,
                      child: CircularProgressIndicator(),
                    ),
                ]),
              ),
            ),
          )),
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

  openFile() {
    if (widget.event == null || widget.event!.file.isEmpty) return;
    final uri = getUri(widget.event!.file);
    _launchUrl(uri);
  }

  Widget withImg() {
    final image = widget.event!.file.trim();
    return JustTheTooltip(
      key: ValueKey(widget.event!.content),
      tailLength: 10.0,
      triggerMode: TooltipTriggerMode.tap,
      preferredDirection: AxisDirection.down,
      isModal: false,
      hoverShowDuration: Duration(seconds: 1),
      backgroundColor: Colors.grey,
      margin: const EdgeInsets.all(20.0),
      content: tipImage(image),
      child: row(),
    );
  }

  Widget row() => (widget.editable)
      ? Input8(
          ctrl,
          fontSize: widget.fontSize,
          onSubmit: (value) {
            value = value.trim();
            //if (value.isEmpty) return;
            //int.parse(str.replaceAll(new RegExp(r'[^0-9]'), ''));

            final expires = switch (add) {
              '8s' => 8 * 60,
              '8m' => 8 * 60 * 60,
              '8h' => 8 * 60 * 60 * 60,
              '' => 0,
              String() => '',
            };
            if (!value.startsWith('.')) {
              final m = {
                'content': value,
                '_expiresAfter': expires,
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

  static tipImage(String? val, {double? height}) {
    if (val == null || val.isEmpty) return Container();
    final bytes = FData.cache[val];
    return bytes != null
        ? Image.memory(bytes, height: height)
        : Image.network(
            getUri(val).toString(),
            height: height,
          );
  }

  static Uri getUri(String val) {
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
