
import 'dart:io';

class Utils{
  static Future<int> getConnectionState() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return 1;
      }
    } on SocketException catch (_) {
      print('not connected');
      return 0;
    }
  }
}