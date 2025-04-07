import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class UserModel extends Equatable {
  String? email;
  String? phone;
  String? userId;
  bool? isVerified;
  String? createdAt;
  String? profilePic;
  String? displayName;
  UserModel({
    this.email,
    this.phone,
    this.userId,
    this.createdAt,
    this.profilePic,
    this.isVerified,
    this.displayName,
  });
  UserModel.fromJson(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return;
    }
    email = map['email'];
    phone = map['phone'];
    userId = map['userId'];
    createdAt = map['createdAt'];
    isVerified = map['isVerified'];
    profilePic = map['profilePic'];
    displayName = map['displayName'];
  }
  toJson() {
    return {
      "phone": phone,
      "email": email,
      "userId": userId,
      'createdAt': createdAt,
      'isVerified': isVerified,
      'profilePic': profilePic,
      'displayName': displayName,
    };
  }

  UserModel copyWith({
    String? email,
    String? phone,
    String? userId,
    bool? isVerified,
    String? createdAt,
    String? profilePic,
    String? displayName,
  }) {
    return UserModel(
      email: email ?? this.email,
      phone: phone ?? this.phone,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      isVerified: isVerified ?? this.isVerified,
      profilePic: profilePic ?? this.profilePic,
      displayName: displayName ?? this.displayName,
    );
  }

  @override
  List<Object?> get props => [
        email,
        phone,
        userId,
        createdAt,
        profilePic,
        displayName,
      ];
}
