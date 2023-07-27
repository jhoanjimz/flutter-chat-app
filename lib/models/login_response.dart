import 'dart:convert';

import 'package:chat/models/usuario.dart';

LoginResponse loginResponseFromMap(String str) => LoginResponse.fromMap(json.decode(str));

String loginResponseToMap(LoginResponse data) => json.encode(data.toMap());

class LoginResponse {
    bool ok;
    Usuario usuario;
    String token;

    LoginResponse({
        required this.ok,
        required this.usuario,
        required this.token,
    });

    factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
        ok: json["ok"],
        usuario: Usuario.fromMap(json["usuario"]),
        token: json["token"],
    );

    Map<String, dynamic> toMap() => {
        "ok": ok,
        "usuario": usuario.toMap(),
        "token": token,
    };
}