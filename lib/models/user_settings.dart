import 'package:shared_preferences/shared_preferences.dart';

enum Unit {
  metric,
  imperial,
}

class UserSettings {
  static late SharedPreferences _preferences;

  static const _unit = 'unit';
  static const _selectedProfile = 'selectedProfile';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUnit(Unit unit) async =>
      await _preferences.setString(_unit, unit.toString().split('.').last);    

  static Future setProfile(int profile) async =>
      await _preferences.setInt(_selectedProfile, profile);
  
  static int? getProfile() => _preferences.getInt(_selectedProfile);
  static Unit getUnit() => _preferences.getString(_unit) == 'metric' ? Unit.metric : Unit.imperial;
  
}