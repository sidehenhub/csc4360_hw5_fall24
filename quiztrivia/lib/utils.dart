import 'package:html_unescape/html_unescape.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Utils {
  // Decodes HTML entities into readable text
  static String decodeHtml(String input) {
    try {
      final unescape = HtmlUnescape();
      return unescape.convert(input);
    } catch (e) {
      // Fallback to the original input in case of decoding failure
      return input;
    }
  }

  // Checks if the device is connected to the internet
  static Future<bool> isConnected() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi;
    } catch (e) {
      // Assume no connectivity if the check fails
      return false;
    }
  }
}
