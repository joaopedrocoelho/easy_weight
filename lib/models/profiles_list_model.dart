import 'package:easy_weight/models/profile_model.dart';
import 'package:easy_weight/models/user_settings.dart';
import 'package:easy_weight/utils/logger_instace.dart';
import 'package:flutter/material.dart';

class ProfilesListModel extends ChangeNotifier {
  Profile? selectedProfile;
  List<Profile> profiles = [];

  List<Profile> get getProfiles => profiles;
  int get profilesCount => profiles.length;
  get selectedProfileID => selectedProfile?.id ?? 0;

  ProfilesListModel({List<Profile>? profiles}) {
    profiles = profiles ?? [];
  }

  void addProfile(Profile profile) {
    profiles.add(profile);
    notifyListeners();
  }

  void removeProfile(Profile profile) {
    profiles.remove(profile);
    notifyListeners();
  }

  void updateList(List<Profile> newProfiles) {
    this.profiles = newProfiles;
    notifyListeners();
  }

  void updateProfile(int id, Profile editedProfile) {
    int profileIndex = profiles.indexWhere((profile) => profile.id == id);
    this.profiles[profileIndex] = editedProfile;
    notifyListeners();
  }

  void selectProfile(int id) {
    selectedProfile =
        profiles.firstWhere((profile) => profile.id == id, orElse: () {
      return profiles.first;
    });

    logger.i("selected profile: $selectedProfileID");
    UserSettings.setProfile(selectedProfile!.id!);
    notifyListeners();
  }
}
