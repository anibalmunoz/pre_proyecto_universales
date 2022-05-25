import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pre_proyecto_universales/localization/localizations.dart';
import 'package:pre_proyecto_universales/util/app_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Fingerprint {
  static LocalAuthentication? localAuth;
  static bool isBiometricAvailable = false;
  static bool hayHuellaDisponible = false;

  static String? correoPrefs;
  static String? contrasenaPrefs;

  static Future<void> verificarDisponibilidadHuellas() async {
    localAuth = LocalAuthentication();
    await localAuth!.canCheckBiometrics.then((value) {
      isBiometricAvailable = value;
    });
    await localAuth!.getAvailableBiometrics().then((value) => {
          if (value.toString() != "[]")
            {hayHuellaDisponible = true}
          else
            {hayHuellaDisponible = false}
        });
  }

  static Future<void> guardarEnSharedPreferences(correo, contrasena) async {
    String correoEncriptado = await encriptar(correo);
    String contrasenaEncriptada = await encriptar(contrasena);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("correo", correoEncriptado.toString());
    await prefs.setString("contrasena", contrasenaEncriptada.toString());
  }

  static Future<void> suprimirSharedPreferences(correo, contrasena) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("correo", correo);
    await prefs.setString("contrasena", contrasena);
  }

  static Future<void> asignarCredencialesDesdeSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    correoPrefs = prefs.getString("correo");
    contrasenaPrefs = prefs.getString("contrasena");

    if (correoPrefs != null &&
        correoPrefs != "null" &&
        contrasenaPrefs != null &&
        contrasenaPrefs != "null") {
      String correoDesencriptado = await desencriptar(correoPrefs);
      String contrasenaDesencriptada = await desencriptar(contrasenaPrefs);

      correoPrefs = correoDesencriptado;
      contrasenaPrefs = contrasenaDesencriptada;

      print(
          "EL NOMBRE Y LA CONTRASEÑA ALMACENADAS EN SHARED PREFERENES Y DESENCRIPTADAS SON");
      print(correoDesencriptado);
      print(contrasenaDesencriptada);
    }
  }

  static Future<String> encriptar(cadenas) async {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(cadenas);

    return encoded;
  }

  static Future<String> desencriptar(cadenas) async {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    final String plainText = stringToBase64.decode(cadenas);

    return plainText;
  }

  static Future<bool> consultarGuardarCredenciales(context) async {
    AppLocalizations localizations =
        Localizations.of<AppLocalizations>(context, AppLocalizations)!;
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: Text(localizations.dictionary(Strings.textIngresar)),
              content: Text(
                  localizations.dictionary(Strings.dialogSugerenciaIngresar)),
              actions: [
                TextButton(
                  child: Text(localizations.dictionary(Strings.botonCancelar),
                      style: const TextStyle(
                        color: Colors.grey,
                      )),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                TextButton(
                  child: Text(
                    localizations.dictionary(Strings.save),
                    style: const TextStyle(color: Colors.blue),
                  ),
                  onPressed: () async {
                    Navigator.pop(context, true);
                  },
                ),
              ],
            ));
  }
}
