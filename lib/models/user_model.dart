import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final DateTime createdAt;
  final double portfolioValue;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    required this.createdAt,
    this.portfolioValue = 0.0,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      portfolioValue: (data['portfolioValue'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'createdAt': Timestamp.fromDate(createdAt),
      'portfolioValue': portfolioValue,
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    DateTime? createdAt,
    double? portfolioValue,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      portfolioValue: portfolioValue ?? this.portfolioValue,
    );
  }
} 