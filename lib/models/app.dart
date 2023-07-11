import 'dart:convert';
import 'package:data8/index.dart';
import 'package:frac/frac.dart';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xc8/enums/time.dart';
import '../connections/pix8.dart';
import '../enums/things.dart';
import 'package:convert/convert.dart';
import '../enums/view.dart';
import '../services/signer.dart';
import 'connection.dart';
import 'user.dart';
import '../init/unsupported.dart'
    if (dart.library.ffi) '../init/native.dart'
    if (dart.library.html) '../init/web.dart';

class Oo8Fractal extends FChangeNotifier {
  static String get _url => 'ws${FData.isSecure ? 's' : ''}://${FData.host}';
  final connection = Connection(_url);
  final pix8connection = Pix8Connection();

  late final UserNostr user;

  Event? selected;

  final listeners = <Function>[];
  final events = <Event>[];
  //late Relay relay;

  var thingsLayout = ThingsLayout.base;

  var timeDisplay = TimeDisplay.stamp;
  var viewDisplay = ViewDisplay.list;

  static Future<void> initiate() async {
    init();
  }

  Oo8Fractal() {
    print('Init app');
    //String host = 'localhost:8080';
//        Uri.base.authority.isEmpty ? 'localhost:8080' : Uri.base.authority;
    /*
    relay = Relay(_url, onReady: () {
      //synch();
    });
    */
    user = UserNostr();
    init();
    //_listen();
  }

  listen(Function() fb) {
    listeners.add(fb);
  }

  trigger() {
    for (var fb in listeners) {
      fb();
    }
  }

  /*
  _listen() async {
    //final lastSyncAt = await Events.lastSync();
    relay.stream.listen((Message m) {
      if (m.isEvent) {
        //m[2]['createdAt'] = m[2]['created_at'];
        final event = Event.fromJson(m[2]);
        //containts
        if (events.any((e) => e.id == event.id)) return;
        events.insert(0, event);
      }
    });
    relay.req(
      Filter(
        limit: 100,
        /*
        since: lastSyncAt > 0
            ? DateTime.fromMillisecondsSinceEpoch(lastSyncAt * 1000)
            : null,
          */
      ),
    );
  }
  */

  Map<String, dynamic> make(Map<String, dynamic> m) {
    final now = DateTime.now(), nowSeconds = now.millisecondsSinceEpoch ~/ 1000;
    final kind = 1;
    final tags = <List<String>>[];
    final key = user.keyPair.publicKey.toLowerCase();

    List data = [0, key, nowSeconds, kind, tags, m['content']];
    String serializedEvent = json.encode(data);
    List<int> hash = sha256.convert(utf8.encode(serializedEvent)).bytes;
    final id = hex.encode(hash);

    final sig = const Signer().sign(
      privateKey: user.keyPair.privateKey,
      message: id,
    );

    final expires = m.remove('_expiresAfter');
    final map = {
      //'i': 0,
      'id': id,
      'pubkey': key,
      'createdAt': nowSeconds,
      'kind': kind,
      'tags': tags,
      'sig': sig,
      'file': '',
      'content': '',
      'expiresAt': (expires > 0) ? (nowSeconds + expires) : 0,
      ...m,
    };

    return map;
  }

  void post(Map<String, dynamic> m) async {
    final ev = make(m);
    ev['syncAt'] = 0;
    //relay.isConnected ? DateTime.now().millisecondsSinceEpoch ~/ 1000 : 0;

    final event = Event.fromJson(ev);

    events.insert(0, event);

    await db.into(db.events).insert(event);

    distribute(ev);
  }

  distribute(Map<String, dynamic> m) {
    if (true) {
      //final ev = transform(m);
      connection.post([m]);
    }
  }

  void search(String term) {
    //repo.relay.req(Filter());
  }

  /*
  synch() {
    if (relay.isConnected) {
      (db.select(db.events)..where((tbl) => tbl.syncAt.equals(0)))
          .get()
          .then((rows) {
        rows.forEach((row) {
          final m = row.toJson();
          m.remove('syncAt');
          //m.remove('i');
          m['created_at'] = m['createdAt'];
          m['tags'] = [];
          m.remove('createdAt');
          relay.send(m);
        });

        if (rows.isNotEmpty) Events.synched();
      });
    }
  }
  */

  Map<String, dynamic> transform(Map<String, dynamic> m) {
    m.remove('syncAt');
    m.remove('i');
    m['created_at'] = m['createdAt'];
    m['tags'] = [];
    m.remove('createdAt');
    return m;
  }

  close() {}
}

/*
// we should only use one db connection for the app
final appProvider = Provider<Oo8Fractal>((ref) {
  final app = Oo8Fractal(ref);

  ref.onDispose(() {
    app.close();
  });

  return app;
});
*/