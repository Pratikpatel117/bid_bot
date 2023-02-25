import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthApi {
  final _auth = LocalAuthentication();

  Future<bool> hasBiometrics() async {
    try {
      var authenticate = await _auth.canCheckBiometrics;
      var authDevice = await _auth.isDeviceSupported();
      debugPrint("authentication in local auth == $authenticate");
      return authenticate && authDevice == true ? true : false;
    } on PlatformException catch (e) {
      debugPrint("authentication exception error == $e");
      return false;
    }
  }

  static Future<bool> authenticate() async {
    final LocalAuthentication localAuthentication = LocalAuthentication();
    bool isBiometricSupported = await localAuthentication.isDeviceSupported();
    bool canCheckBiometrics = await localAuthentication.canCheckBiometrics;

    bool isAuthenticated = false;

    if (isBiometricSupported && canCheckBiometrics) {
      isAuthenticated = await localAuthentication.authenticate(
        localizedReason: 'Please complete the biometrics to proceed.',
        biometricOnly: true,
      );
    }
    return isAuthenticated;
  }
}
