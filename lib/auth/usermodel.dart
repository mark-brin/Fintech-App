import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class UserModel extends Equatable {
  int? balance;
  String? email;
  String? phone;
  String? userId;
  String? createdAt;
  String? profilePic;
  String? displayName;
  UserModel({
    this.email,
    this.phone,
    this.userId,
    this.balance,
    this.createdAt,
    this.profilePic,
    this.displayName,
  });
  UserModel.fromJson(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return;
    }
    email = map['email'];
    phone = map['phone'];
    userId = map['userId'];
    balance = map['balance'];
    createdAt = map['createdAt'];
    profilePic = map['profilePic'];
    displayName = map['displayName'];
  }
  toJson() {
    return {
      'email': email,
      'phone': phone,
      'userId': userId,
      'balance': balance,
      'createdAt': createdAt,
      'profilePic': profilePic,
      'displayName': displayName,
    };
  }

  UserModel copyWith({
    int? balance,
    String? email,
    String? phone,
    String? userId,
    String? createdAt,
    String? profilePic,
    String? displayName,
  }) {
    return UserModel(
      email: email ?? this.email,
      phone: phone ?? this.phone,
      userId: userId ?? this.userId,
      balance: balance ?? this.balance,
      createdAt: createdAt ?? this.createdAt,
      profilePic: profilePic ?? this.profilePic,
      displayName: displayName ?? this.displayName,
    );
  }

  @override
  List<Object?> get props => [
        email,
        phone,
        userId,
        balance,
        createdAt,
        profilePic,
        displayName,
      ];
}
