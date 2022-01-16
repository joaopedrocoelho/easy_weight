import 'package:easy_weight/models/profile_model.dart';
import 'package:flutter/material.dart';

class ProfilesListModel extends ChangeNotifier {
  ProfileModel? selectedProfile;
  List<ProfileModel> profiles = [];

  List<ProfileModel> get getProfiles => profiles;
  int get profilesCount => profiles.length;
   get selectedProfileID => selectedProfile?.id ?? -1;

  ProfilesListModel({List<ProfileModel>? profiles}) {
    profiles = profiles ?? [];
  }

  void addProfile(ProfileModel profile) {
    profiles.add(profile);
    notifyListeners();
  }

  void removeProfile(ProfileModel profile) {
    profiles.remove(profile);
    notifyListeners();
  }

  void updateList(List<ProfileModel> newProfiles) {
    this.profiles = newProfiles;
    notifyListeners();
  }

   void selectProfile(int id) {
    selectedProfile = profiles.firstWhere((profile) => profile.id == id);
    notifyListeners();
  } 
}