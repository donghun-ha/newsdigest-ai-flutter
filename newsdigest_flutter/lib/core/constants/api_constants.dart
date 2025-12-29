import 'dart:io';

const int backendPort = 8000;

String get baseUrl {
  // iOS 시뮬레이터, macOS, 웹 등: localhost 사용
  if (Platform.isIOS || !Platform.isMacOS) {
    return 'http://127.0.0.1:$backendPort';
  }

  // Android 시뮬레이터: 10.0.2.2 사용
  if (Platform.isAndroid) {
    return 'http://10.0.2.2:$backendPort';
  }

  // 그 외 플랫폼: localhost 사용
  return 'http://127.0.0.1:$backendPort';
}
