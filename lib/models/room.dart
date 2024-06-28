// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


class RoomModel {
  final String id;
  final String hostelId;
  final String name;
  final int capacity;
  final double price;
  final String image;
  final String description;
  RoomModel({
    required this.id,
    required this.hostelId,
    required this.name,
    required this.capacity,
    required this.price,
    required this.image,
    required this.description,
  });
 

  RoomModel copyWith({
    String? id,
    String? hostelId,
    String? name,
    int? capacity,
    double? price,
    String? image,
    String? description,
  }) {
    return RoomModel(
      id: id ?? this.id,
      hostelId: hostelId ?? this.hostelId,
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
      'hostelId': hostelId,
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
      hostelId: map['hostelId'] as String,
      name: map['name'] as String,
      capacity: map['capacity'] as int,
      price: map['price'] as double,
      image: map['image'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RoomModel.fromJson(String source) => RoomModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RoomModel(id: $id, hostelId: $hostelId, name: $name, capacity: $capacity, price: $price, image: $image, description: $description)';
  }

  @override
  bool operator ==(covariant RoomModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.hostelId == hostelId &&
      other.name == name &&
      other.capacity == capacity &&
      other.price == price &&
      other.image == image &&
      other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      hostelId.hashCode ^
      name.hashCode ^
      capacity.hashCode ^
      price.hashCode ^
      image.hashCode ^
      description.hashCode;
  }
}
