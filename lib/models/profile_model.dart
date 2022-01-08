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

  //ProfileModel constructor 
   const ProfileModel({
    required this.id,
    this.name,
    this.emoji,
    this.gender,
    this.height,
    this.birthday,
  });

}

