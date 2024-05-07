import 'package:flutter/foundation.dart';

const String ipAddress = '192.168.1.4:8000';
const String devIpAddress = '127.0.0.1:8000';

getApiBaseUrl() {
  // If debug mode is active, use the dev path.
  if (kDebugMode && kIsWeb) {
    return "http://$devIpAddress/api";
  } else {
    return "http://$ipAddress/api";
  }
}

getBaseUrl() {
  // If debug mode is active, use the dev path.
  if (kDebugMode && kIsWeb) {
    return "http://$devIpAddress";
  } else {
    return "http://$ipAddress";
  }
}

getApiBase() {
  return "/api";
}
