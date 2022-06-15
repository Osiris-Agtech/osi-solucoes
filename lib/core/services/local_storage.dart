import 'dart:convert';

import 'package:osi_solucoes/features/presenter/models/usuario/usuario_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _token = '@osiris:token';
  static const String _user = '@osiris:user';

  Future<void> storageToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_token, value);
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(_token);
    return token;
  }

  Future<void> storageUser(Usuario user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userString = json.encode(user.toJson());
    prefs.setString(_user, userString);
  }

  Future<Usuario?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userString = prefs.getString(_user);
    if (userString == null) {
      return null;
    }
    Usuario? user = Usuario.fromJson(json.decode(userString));
    return user;
  }

  Future<void> deleteUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.clear();
  }
}
