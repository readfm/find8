import 'dart:convert';

import 'package:data8/index.dart';
import 'package:drift/drift.dart';
import 'package:frac/frac.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Connection with FSocketMix {
  final String url;

  Connection(this.url) {
    connect();
  }

  final isConnected = Frac<bool>(false);

  connect() {
    final uri = Uri.parse(url);
    print('Connect: ' + this.url);

    try {
      _channel = WebSocketChannel.connect(uri)
        ..ready.then((_) {
          // set connected
          print('Connected to: $url');
          isConnected.value = true;
          synch();
        });

      _channel?.stream.listen(receive);
    } catch (e) {
      isConnected.value = false;
    }
  }

  Future<int> _checkSync() async {
    final r = await db.customSelect(
      'SELECT MAX(sync_at) AS sync FROM events',
      readsFrom: {db.events},
    ).getSingle();

    return r.data['sync'] ?? 0;
  }

  synch() async {
    final last = await _checkSync();
    post({
      'cmd': 'load',
      'since': last,
    });

    final select = db.select(db.events)
      ..where(
        (tbl) => tbl.syncAt.equals(0),
      );

    select.get().then((events) {
      for (var event in events) {
        final m = event.toJson();
        post([m]);
      }
    });
  }

  WebSocketChannel? _channel;

  @override
  handle(m) async {
    if (m['cmd'] == 're') {
      final now = DateTime.now(),
          nowSeconds = now.millisecondsSinceEpoch ~/ 1000;
      await (db.update(db.events)..where((tbl) => tbl.id.equals(m['id'])))
          .write(EventsCompanion(syncAt: Value(nowSeconds)));
    } else if (m['cmd'] == 'sync') {
      final now = DateTime.now(),
          nowSeconds = now.millisecondsSinceEpoch ~/ 1000;
      final r = await (db.update(db.events)
            ..where((tbl) => tbl.id.equals(m['id'])))
          .write(EventsCompanion(syncAt: Value(nowSeconds)));
    } else {
      return super.handle(m);
    }
  }

  post(m) {
    final request = jsonEncode(m);
    _channel?.sink.add(request);
  }
}
