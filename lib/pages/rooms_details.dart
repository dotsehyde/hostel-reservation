import 'package:flutter/material.dart';
import 'package:hostel/models/room.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RoomDetailsPage extends StatefulWidget {
  final RoomModel room;
  const RoomDetailsPage(this.room, {super.key});

  @override
  State<RoomDetailsPage> createState() => _RoomDetailsPageState();
}

class _RoomDetailsPageState extends State<RoomDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.room.name,
          style: TextStyle(fontSize: 23.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(widget.room.image),
            Text(widget.room.name),
            Text(widget.room.capacity.toString()),
            Text(widget.room.price.toString()),
            Text(widget.room.description),
          ],
        ),
      ),
    );
  }
}
