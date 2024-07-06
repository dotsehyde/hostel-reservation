// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hostel/models/room.dart';
import 'package:hostel/models/user.dart';

class ReserveModel {
  final String id;
  final RoomModel room;
  final UserModel booker;
  final DateTime createdAt;
  final String roomId;
  final String bookerId;
  final String status;
  ReserveModel({
    required this.id,
    required this.room,
    required this.booker,
    required this.createdAt,
    required this.roomId,
    required this.bookerId,
    required this.status,
  });

  ReserveModel copyWith({
    String? id,
    RoomModel? room,
    UserModel? booker,
    DateTime? createdAt,
    String? roomId,
    String? bookerId,
    String? status,
  }) {
    return ReserveModel(
      id: id ?? this.id,
      room: room ?? this.room,
      booker: booker ?? this.booker,
      createdAt: createdAt ?? this.createdAt,
      roomId: roomId ?? this.roomId,
      bookerId: bookerId ?? this.bookerId,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'room': room.toMap(),
      'booker': booker.toMap(),
      'createdAt': createdAt.toIso8601String(),
      'roomId': roomId,
      'bookerId': bookerId,
      'status': status,
    };
  }

  factory ReserveModel.fromMap(Map<String, dynamic> map) {
    return ReserveModel(
      id: map['id'] as String,
      room: RoomModel.fromMap(map['room'] as Map<String, dynamic>),
      booker: UserModel.fromMap(map['booker'] as Map<String, dynamic>),
      createdAt: DateTime.parse(map['createdAt'] as String),
      roomId: map['roomId'] as String,
      bookerId: map['bookerId'] as String,
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReserveModel.fromJson(String source) =>
      ReserveModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReserveModel(id: $id, room: $room, booker: $booker, createdAt: $createdAt, roomId: $roomId, bookerId: $bookerId, status: $status)';
  }

  @override
  bool operator ==(covariant ReserveModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.room == room &&
        other.booker == booker &&
        other.createdAt == createdAt &&
        other.roomId == roomId &&
        other.bookerId == bookerId &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        room.hashCode ^
        booker.hashCode ^
        createdAt.hashCode ^
        roomId.hashCode ^
        bookerId.hashCode ^
        status.hashCode;
  }
}
