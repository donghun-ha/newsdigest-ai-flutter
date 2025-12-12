import 'dart:io';

const int backendPort = 8000;

String get baseUrl {
  if (!Platform.isAndroid && !Platform.isIOS) {
    return 'http://127.0.0.1:$backendPort';
  } else {
    return 'http://10.0.2.2:$backendPort';
  }
}
