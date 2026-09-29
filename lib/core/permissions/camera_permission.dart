import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

enum CameraAccess { granted, denied, permanentlyDenied }

/// Asks the user for camera access before capturing a prescription.
Future<CameraAccess> requestCameraAccess() async {
  // Browsers and desktop show their own prompt when the camera is opened.
  if (kIsWeb ||
      !(defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS)) {
    return CameraAccess.granted;
  }
  final status = await Permission.camera.request();
  if (status.isGranted || status.isLimited) return CameraAccess.granted;
  if (status.isPermanentlyDenied || status.isRestricted) {
    return CameraAccess.permanentlyDenied;
  }
  return CameraAccess.denied;
}

Future<bool> openCameraSettings() => openAppSettings();
