import 'package:flutter/foundation.dart';

const String ipAddress = '10.0.2.2:8000';
const String devIpAddress = '10.0.2.2:8000';

getApiBaseUrl() {
  // If debug mode is active, use the dev path.
  if (kDebugMode) {
    return "http://$devIpAddress/api";
  } else {
    return "http://$ipAddress/api";
  }
}

getBaseUrl() {
  // If debug mode is active, use the dev path.
  if (kDebugMode) {
    return "http://$devIpAddress";
  } else {
    return "http://$ipAddress";
  }
}

getApiBase() {
  return "/api";
}
