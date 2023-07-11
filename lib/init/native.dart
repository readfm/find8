import 'package:data8/data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xc8/app.dart';

Future<void> init() async {
  final dir = await getApplicationDocumentsDirectory();
  FData.path = dir.path;
  return;
}
