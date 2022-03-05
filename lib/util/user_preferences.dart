import 'package:shared_preferences/shared_preferences.dart';
import 'package:vigenesia/models/user/user.dart';

class UserPreferences {
  Future<void> saveUser(User user) async {
    final _pref = await SharedPreferences.getInstance();
    _pref.setString('user', user.toJson());
  }

  Future<User> loadUser() async {
    final _pref = await SharedPreferences.getInstance();
    return User.fromJson(_pref.getString('user') ?? User().toJson());
  }

  Future<void> logout() async {
    final _pref = await SharedPreferences.getInstance();
    _pref.clear();
  }
}
