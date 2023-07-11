import 'dart:convert';
import 'package:data8/index.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:two8/areas/cube.dart';
import 'package:two8/areas/face.dart';
import 'package:yaml_writer/yaml_writer.dart';

class CubeScreen extends StatefulWidget {
  Event event;
  CubeScreen(this.event, {super.key});

  @override
  State<CubeScreen> createState() => _CubeScreenState();
}

class _CubeScreenState extends State<CubeScreen> {
  static final yamlWriter = YAMLWriter();
  MemoryImage? image;

  putImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    final bytes = result?.files.first.bytes;

    if (bytes == null) return;

    final img = Image.memory(bytes);

    final size = Size(
      img.width?.toDouble() ?? 100,
      img.height?.toDouble() ?? 100,
    );

    setState(() {
      image = MemoryImage(bytes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: image != null
            ? DecorationImage(
                image: image!,
                fit: BoxFit.cover,
              )
            : null,
        border: Border.all(color: Color.fromRGBO(77, 77, 77, 1.0)),
        gradient: const LinearGradient(
          colors: [
            Color.fromRGBO(25, 25, 25, 1.0),
            Color.fromRGBO(56, 56, 56, 1.0),
            Color.fromRGBO(25, 25, 25, 1.0)
          ],
          stops: [0.1, 0.5, 0.9],
          begin: FractionalOffset.topRight,
          end: FractionalOffset.bottomLeft,
          tileMode: TileMode.repeated,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          //tramsparent
          backgroundColor: Colors.transparent,
          title: Text(widget.event.id),
          actions: [
            //change image
            IconButton(
              icon: Icon(Icons.image),
              onPressed: () async {
                await putImage();
              },
            ),
          ],
        ),
        //transparent
        backgroundColor: Colors.transparent,
        body: Cube(
          front: BlockFace(
            key: ValueKey('${widget.event.id}_front'),
            text: widget.event.content,
          ),
          left: BlockFace(
            key: ValueKey('${widget.event.id}_left'),
            text: jsonEncode(
              base64Encode(
                utf8.encode(
                  widget.event.toJson().toString(),
                ),
              ),
              //base64
              //widget.event.toJson().toString().,
            ),
          ),
          bottom: BlockFace(
            key: ValueKey('${widget.event.id}_bottom'),
            text: jsonEncode(
              widget.event.toJson(),
            ),
          ),
          top: BlockFace(
            key: ValueKey('${widget.event.id}_top'),
            text: yamlWriter.write(widget.event.toJson()),
          ),
          back: BlockFace(
            key: ValueKey('${widget.event.id}_back'),
            text: widget.event.createdAt.toString(),
          ),
        ),
      ),
    );
  }
}
