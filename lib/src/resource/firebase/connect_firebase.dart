import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class CheckConnectFirebase {
  static void isConnected() {
    final connectedRef = FirebaseDatabase.instance.ref('.info/connected');
    print(connectedRef.key);
    connectedRef.onValue.listen((event) {
      final connected = event.snapshot.value as bool? ?? false;
      if (connected) {
        debugPrint('Connected Firebase.');
      } else {
        debugPrint('Not connected Firebase.');
      }
    });
  }
}
