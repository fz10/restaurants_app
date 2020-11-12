import 'package:flutter/material.dart';
import 'package:restaurants_app/resources/style.dart';

class RestaurantDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        backgroundColor: brandColor,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white, size: 30),
          tooltip: 'Reservar',
          onPressed: () {
            _makeReservation();
          },
        ),
      ),
    );
  }

  void _makeReservation() {
    return null;
  }
}
