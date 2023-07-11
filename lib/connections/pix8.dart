import 'dart:async';

import '../models/connection.dart';

class Pix8Connection extends Connection {
  Pix8Connection() : super('wss://io.cx') {
    connect();
  }

  @override
  synch() {
    post({
      'cmd': 'load',
      "collection": "pix8",
      "filter": {
        "text": {"\$regex": "^[\\s\\S]{4,}\$"}
      },
      "sort": {"time": -1, "created": -1},
      "limit": 1000,
      "cb": "phxw0qdlxmmlpbj"
    });
  }

  @override
  handle(m) async {
    if (m['items'] != null) {
      final list = [
        ...m['items'].map((item) {
          return {
            'id': item['id'],
            'pubkey': '',
            'file': '',
            'sig': '',
            'content': item['text'],
            //from miliseconds to seconds
            'createdAt': (item['time'] ~/ 1000),
            'kind': 1,
          };
        })
      ];

      fromList(
        list,
        respond: false,
      );
    }
    //return super.handle(m);
  }
}
