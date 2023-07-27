// ignore_for_file: unnecessary_getters_setters

import 'dart:convert';

import 'package:chat/global/environment.dart';
import 'package:chat/models/login_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/usuario.dart';

class AuthService with ChangeNotifier {

  late Usuario usuario;
  bool _autenticando = false;

  final _storage = const FlutterSecureStorage();

  bool get autenticando => _autenticando;
  set autenticando(bool valor) {
    _autenticando = valor;
    notifyListeners();
  }

  // Getters del token de forma estática
  static Future<String> getToken() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    return token!;
  }

  static Future<void> deleteToken() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    autenticando = true;

    final data = { 'email': email, 'password': password};

    final resp = await http.post(
      Uri.http(Environment.apiUrl, 'api/login/'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    autenticando = false;
    if( resp.statusCode == 200 ) {
      final loginResponse = loginResponseFromMap(resp.body);
      usuario = loginResponse.usuario;

      await _guardarToken(loginResponse.token);

      return true;
    } else {
      return false;
    }

  }

  Future register(String nombre, String email, String password) async {
    autenticando = true;

    final data = { 'nombre': nombre, 'email': email, 'password': password};

    final resp = await http.post(
      Uri.http(Environment.apiUrl, 'api/login/new'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    autenticando = false;
    if( resp.statusCode == 200 ) {
      final loginResponse = loginResponseFromMap(resp.body);
      usuario = loginResponse.usuario;

      await _guardarToken(loginResponse.token);

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }

  }

  Future<bool> isLogeedIn() async {
    final token = await _storage.read(key: 'token');
    
    final resp = await http.get(
      Uri.http(Environment.apiUrl, 'api/login/renew'),
      headers: {
        'Content-Type': 'application/json',
        'x-token': token.toString()
      },
    );
    
    if( resp.statusCode == 200 ) {
      final loginResponse = loginResponseFromMap(resp.body);
      usuario = loginResponse.usuario;

      await _guardarToken(loginResponse.token);

      return true;
    } else {
      logout();
      return false;
    }
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    return await _storage.delete(key: 'token');
  }

}