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

extension ParseToString on Gender {
  String toShortString() {
    return this.toString().split('.').last;
  }

  String toInitial() {
    return this.toString().split('.').last[0].toUpperCase();
  }
}

Gender getGender(String? gender) {
  switch (gender) {
    case "male":
      return Gender.male;
    case "female":
      return Gender.female;
    case "non_binary":
      return Gender.non_binary;
    case "transgender":
      return Gender.transgender;
    case "intersex":
      return Gender.intersex;
    case "other":
      return Gender.other;
    case "undefined":
      return Gender.undefined;
    default:
      return Gender.undefined;
  }
}

Color getColor(String colorFromDB) {
  RegExp getColorvalue =
      RegExp(r'(?<=MaterialColor\(primary value: Color\()[\w\d]*');
  String color = getColorvalue.stringMatch(colorFromDB).toString();
  //logger.i("parsing profile color from DB:$colorFromDB", color);

  return color != 'null' ? Color(int.parse(color)) : Colors.transparent;
}

class Profile {
  final int? id;
  final String? name;
  final String? emoji;
  final Gender? gender;
  final double? height;
  final DateTime? birthday;
  final Color? color;
  //final RecordsListModel records;

  //Profile constructor
  const Profile(
      {this.id,
      this.name,
      this.emoji,
      this.gender,
      this.height,
      this.birthday,
      this.color});

  Map<String, dynamic> toJson() => {
        ProfileFields.id: this.id,
        ProfileFields.name: this.name,
        ProfileFields.birthday: this.birthday != null
            ? this.birthday!.millisecondsSinceEpoch.toString()
            : '',
        ProfileFields.emoji: this.emoji,
        ProfileFields.gender: this.gender.toString().split('.').last,
        ProfileFields.height: this.height,
        ProfileFields.color: this.color.toString(),
      };
}

List<Profile> toProfileList(List<Map<String, dynamic>> profiles) {
  return profiles.map((profile) {
    return Profile(
        id: profile[ProfileFields.id],
        name: profile[ProfileFields.name],
        emoji: profile[ProfileFields.emoji],
        gender: getGender(profile[ProfileFields.gender]),
        height: profile[ProfileFields.height],
        birthday: profile[ProfileFields.birthday] != ''
            ? DateTime.fromMillisecondsSinceEpoch(
                int.parse(profile[ProfileFields.birthday]))
            : null,
        color: profile[ProfileFields.color] != 'null'
            ? getColor(profile['color'])
            : null);
  }).toList();
}
