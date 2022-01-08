import 'package:easy_weight/models/profile_model.dart';
import 'package:flutter/material.dart';

class ProfilesListModel extends ChangeNotifier {
  ProfileModel? _selectedProfile;
  List<ProfileModel> _profiles = [];

  List<ProfileModel> get profiles => _profiles;
  int get selectedProfileID => _selectedProfile?.id ?? -1;

  ProfilesListModel({List<ProfileModel>? profiles}) {
    _profiles = profiles ?? [];
  }

  void addProfile(ProfileModel profile) {
    _profiles.add(profile);
    notifyListeners();
  }

  void removeProfile(ProfileModel profile) {
    _profiles.remove(profile);
    notifyListeners();
  }

  void selectProfile(int id) {
    _selectedProfile = _profiles.firstWhere((profile) => profile.id == id);
    notifyListeners();
  }
}