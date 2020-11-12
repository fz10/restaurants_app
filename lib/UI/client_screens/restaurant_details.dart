import 'package:flutter/material.dart';
import 'package:restaurants_app/resources/style.dart';

class RestaurantDetails extends StatefulWidget {
  @override
  _RestaurantDetailsState createState() => _RestaurantDetailsState();
}

class _RestaurantDetailsState extends State<RestaurantDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => moveToLastScreen(),
        ),
        centerTitle: true,
        backgroundColor: brandColor,
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context);
  }
}
