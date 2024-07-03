// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String studentId;
  final String photo;
  final String phone;
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.studentId,
    required this.photo,
    this.phone = "",
  });

  ///Function
  final db = FirebaseFirestore.instance;

  Future<void> save() {
    return db.collection('users').doc(id).set(toMap()).catchError((e) {
      throw e;
    });
  }

  static Future<UserModel> getUser(String id) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .get()
        .catchError((e) {
      throw e;
    });
    return UserModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  Future<void> update(UserModel user) {
    return db
        .collection('users')
        .doc(user.id)
        .update(user.toMap())
        .catchError((e) {
      throw e;
    });
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? studentId,
    String? photo,
    String? phone,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      studentId: studentId ?? this.studentId,
      photo: photo ?? this.photo,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'studentId': studentId,
      'photo': photo,
      'phone': phone,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      studentId: map['studentId'] as String,
      photo: map['photo'] as String,
      phone: map['phone'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, studentId: $studentId, photo: $photo, phone: $phone)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.studentId == studentId &&
        other.photo == photo &&
        other.phone == phone;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        studentId.hashCode ^
        photo.hashCode ^
        phone.hashCode;
  }
}
