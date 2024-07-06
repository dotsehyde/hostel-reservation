// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class RoomModel {
  final String id;
  final String name;
  final int capacity;
  final String price;
  final String image;
  final String description;
  RoomModel({
    required this.id,
    required this.name,
    required this.capacity,
    required this.price,
    required this.image,
    required this.description,
  });

  final db = FirebaseFirestore.instance;

  Future<void> save() async {
    try {
      await db.collection('rooms').doc(id).set(toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> update() async {
    try {
      await db.collection('rooms').doc(id).update(toMap());
    } catch (e) {
      rethrow;
    }
  }

  RoomModel copyWith({
    String? id,
    String? name,
    int? capacity,
    String? price,
    String? image,
    String? description,
  }) {
    return RoomModel(
      id: id ?? this.id,
      name: name ?? this.name,
      capacity: capacity ?? this.capacity,
      price: price ?? this.price,
      image: image ?? this.image,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'capacity': capacity,
      'price': price,
      'image': image,
      'description': description,
    };
  }

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      id: map['id'] as String,
      name: map['name'] as String,
      capacity: map['capacity'] as int,
      price: map['price'] as String,
      image: map['image'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RoomModel.fromJson(String source) =>
      RoomModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RoomModel(id: $id, name: $name, capacity: $capacity, price: $price, image: $image, description: $description)';
  }

  @override
  bool operator ==(covariant RoomModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.capacity == capacity &&
        other.price == price &&
        other.image == image &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        capacity.hashCode ^
        price.hashCode ^
        image.hashCode ^
        description.hashCode;
  }
}
