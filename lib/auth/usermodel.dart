import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class UserModel extends Equatable {
  String? key;
  String? bio;
  String? dob;
  String? email;
  String? phone;
  String? userId;
  String? userName;
  String? createdAt;
  String? profilePic;
  String? displayName;
  String? bannerImage;
  UserModel({
    this.key,
    this.bio,
    this.dob,
    this.email,
    this.phone,
    this.userId,
    this.userName,
    this.createdAt,
    this.profilePic,
    this.bannerImage,
    this.displayName,
  });
  UserModel.fromJson(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return;
    }
    key = map['key'];
    dob = map['dob'];
    bio = map['bio'];
    email = map['email'];
    phone = map['phone'];
    userId = map['userId'];
    userName = map['userName'];
    createdAt = map['createdAt'];
    profilePic = map['profilePic'];
    displayName = map['displayName'];
    bannerImage = map['bannerImage'];
  }
  toJson() {
    return {
      'key': key,
      'dob': dob,
      'bio': bio,
      "email": email,
      "phone": phone,
      "userId": userId,
      'userName': userName,
      'createdAt': createdAt,
      'profilePic': profilePic,
      'bannerImage': bannerImage,
      'displayName': displayName,
    };
  }

  UserModel copyWith({
    String? key,
    String? bio,
    String? dob,
    String? email,
    String? phone,
    String? userId,
    String? userName,
    String? createdAt,
    String? profilePic,
    String? displayName,
    String? bannerImage,
  }) {
    return UserModel(
      bio: bio ?? this.bio,
      dob: dob ?? this.dob,
      key: key ?? this.key,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      createdAt: createdAt ?? this.createdAt,
      profilePic: profilePic ?? this.profilePic,
      displayName: displayName ?? this.displayName,
      bannerImage: bannerImage ?? this.bannerImage,
    );
  }

  @override
  List<Object?> get props => [
        key,
        bio,
        dob,
        phone,
        email,
        userId,
        userName,
        createdAt,
        profilePic,
        displayName,
        bannerImage,
      ];
}
