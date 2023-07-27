// To parse this JSON data, do
//
//     final usuariosResponse = usuariosResponseFromMap(jsonString);

import 'dart:convert';

import 'package:chat/models/usuario.dart';

UsuariosResponse usuariosResponseFromMap(String str) => UsuariosResponse.fromMap(json.decode(str));

String usuariosResponseToMap(UsuariosResponse data) => json.encode(data.toMap());

class UsuariosResponse {
    bool ok;
    List<Usuario> usuarios;
    int desde;

    UsuariosResponse({
        required this.ok,
        required this.usuarios,
        required this.desde,
    });

    factory UsuariosResponse.fromMap(Map<String, dynamic> json) => UsuariosResponse(
        ok: json["ok"],
        usuarios: List<Usuario>.from(json["usuarios"].map((x) => Usuario.fromMap(x))),
        desde: json["desde"],
    );

    Map<String, dynamic> toMap() => {
        "ok": ok,
        "usuarios": List<dynamic>.from(usuarios.map((x) => x.toMap())),
        "desde": desde,
    };
}
