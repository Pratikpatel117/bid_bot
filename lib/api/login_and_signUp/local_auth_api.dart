import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthApi {
  static final _auth = LocalAuthentication();

  List<BiometricType> listOfBioMetricType = <BiometricType>[];

  Future<List<BiometricType>> getListOfBiomaterial() async {
    List<BiometricType> availableBiometrics =
        await _auth.getAvailableBiometrics();

    if (Platform.isAndroid) {
      if (availableBiometrics.contains(BiometricType.face)) {
        // Face ID.
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        // Touch ID.
      }
    }
    if (Platform.isIOS) {
      if (availableBiometrics.contains(BiometricType.face)) {
        // Face ID.
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        // Touch ID.
      }
    }
    // List<BiometricType> bioMetricList ;
    try {
      final bioMetricList = await _auth.getAvailableBiometrics();
      return bioMetricList;
    } on PlatformException catch (e) {
      debugPrint("biometric list == $e");
      return [];
    }
  }

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      return false;
    }
  }

  static Future<bool> authenticate() async {
    final isAvailable = await hasBiometrics();
    if (!isAvailable) return false;
    debugPrint("isAvailable == $isAvailable");

    try {
      return await _auth.authenticate(
        androidAuthStrings: AndroidAuthMessages(
          signInTitle: 'Face ID Required',
          biometricHint: "Bio-Metric",
          biometricSuccess: "successfully login",
          goToSettingsButton: "set button",
          goToSettingsDescription: "Setting description",
        ),
        localizedReason: 'Scan Face to Authenticate',
        useErrorDialogs: true,
        stickyAuth: true,
        biometricOnly: true,
      );
    } on PlatformException catch (e) {
      debugPrint(" login auth exception error == $e");
      return false;
    }
  }
}
