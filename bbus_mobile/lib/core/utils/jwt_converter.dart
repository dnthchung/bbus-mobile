import 'dart:convert';

Map<String, dynamic> parseJwt(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('invalid token');
  }

  final payload = _decodeBase64(parts[1]);
  final payloadMap = json.decode(payload);
  if (payloadMap is! Map<String, dynamic>) {
    throw Exception('invalid payload');
  }

  return payloadMap;
}

String _decodeBase64(String str) {
  String output = str.replaceAll('-', '+').replaceAll('_', '/');

  switch (output.length % 4) {
    case 0:
      break;
    case 2:
      output += '==';
      break;
    case 3:
      output += '=';
      break;
    default:
      throw Exception('Illegal base64url string!"');
  }

  return utf8.decode(base64Url.decode(output));
}

DateTime? getExpirationDate(String token) {
  try {
    final payload = parseJwt(token);
    if (payload.containsKey('exp')) {
      int exp = payload['exp']; // exp is in seconds since epoch
      return DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true);
    }
  } catch (e) {
    print('Error decoding JWT: $e');
  }
  return null;
}

bool isTokenExpired(String token) {
  DateTime? expirationDate = getExpirationDate(token);
  if (expirationDate == null) {
    return true; // Treat as expired if no exp claim is found
  }
  return DateTime.now().isAfter(expirationDate);
}
