// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


class HostelModel {
  final String name;
  final String location;
  final String description;
  final String image;
  final String phone;
  final String email;
  final String id;
  HostelModel({
    required this.name,
    required this.location,
    required this.description,
    required this.image,
    required this.phone,
    required this.email,
    required this.id,
  });

  HostelModel copyWith({
    String? name,
    String? location,
    String? description,
    String? image,
    String? phone,
    String? email,
    String? id,
  }) {
    return HostelModel(
      name: name ?? this.name,
      location: location ?? this.location,
      description: description ?? this.description,
      image: image ?? this.image,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'location': location,
      'description': description,
      'image': image,
      'phone': phone,
      'email': email,
      'id': id,
    };
  }

  factory HostelModel.fromMap(Map<String, dynamic> map) {
    return HostelModel(
      name: map['name'] as String,
      location: map['location'] as String,
      description: map['description'] as String,
      image: map['image'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      id: map['id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory HostelModel.fromJson(String source) => HostelModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'HostelModel(name: $name, location: $location, description: $description, image: $image, phone: $phone, email: $email, id: $id)';
  }

  @override
  bool operator ==(covariant HostelModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.location == location &&
      other.description == description &&
      other.image == image &&
      other.phone == phone &&
      other.email == email &&
      other.id == id;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      location.hashCode ^
      description.hashCode ^
      image.hashCode ^
      phone.hashCode ^
      email.hashCode ^
      id.hashCode;
  }
}
