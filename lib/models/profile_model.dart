import 'package:easy_weight/models/db/profiles_table.dart';
import 'package:flutter/material.dart';

enum Gender {
  male,
  female,
  non_binary,
  transgender,
  intersex,
  other,
  undefined,
}

class ProfileModel {
  final int id;
  final String? name;
  final String? emoji;
  final Gender? gender;
  final int? height;
  final DateTime? birthday;
  final Color? color;

  //ProfileModel constructor 
   const ProfileModel({
    required this.id,
    this.name,
    this.emoji,
    this.gender,
    this.height,
    this.birthday,
    this.color
   });

  Map<String, dynamic> toJson() => {
    ProfileFields.id: this.id,
    ProfileFields.name: this.name,
    ProfileFields.birthday: this.birthday,
    ProfileFields.emoji: this.emoji,
    ProfileFields.gender: this.gender,
    ProfileFields.height: this.height,
    ProfileFields.color: this.color,
  };

}

List<ProfileModel> toProfileList(List<Map<String, dynamic>> profiles) {
  return profiles.map((profile) {
    print("profile before converting: $profile");
    return ProfileModel
      (
      id: profile[ProfileFields.id],
      name: profile[ProfileFields.name],
      emoji: profile[ProfileFields.emoji],
      gender: profile[ProfileFields.gender],
      height: profile[ProfileFields.height],
      birthday: profile[ProfileFields.birthday] != null ? DateTime.parse(profile[ProfileFields.birthday]) : null,
      color: profile[ProfileFields.color] != null ? profile['color'] : null
      );
          
  }).toList();
}

