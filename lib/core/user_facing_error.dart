import 'dart:io';

/// Turns low-level network/DNS errors into short copy for the UI.
String userFacingErrorMessage(Object error) {
  if (error is SocketException) {
    return _networkDnsMessage;
  }

  final lower = error.toString().toLowerCase();

  if (lower.contains('failed host lookup') ||
      lower.contains('socketexception') ||
      (lower.contains('clientexception') &&
          (lower.contains('socket') || lower.contains('host lookup')))) {
    return _networkDnsMessage;
  }

  if (lower.contains('connection refused') ||
      lower.contains('connection reset')) {
    return 'تعذّر الاتصال بالخادم. تحقق من الشبكة أو جدار الحماية.';
  }

  if (lower.contains('timed out') || lower.contains('timeout')) {
    return 'انتهت مهلة الطلب. حاول مرة أخرى مع اتصال أفضل.';
  }

  return error.toString();
}

const _networkDnsMessage = 'لا يوجد اتصال بالشبكة';
