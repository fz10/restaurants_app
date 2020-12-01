import 'package:flutter/material.dart';
import 'package:restaurants_app/models/models.dart';
import 'package:restaurants_app/repositories/user_repository.dart';
import 'package:restaurants_app/resources/style.dart';

import 'restaurant_profile.dart';
import 'restaurant_reservations.dart';

class RestaurantHomeScreen extends StatefulWidget {
  final UserRepository _userRepository;
  final Restaurant _restaurant;
  final Client _userRestaurant;

  const RestaurantHomeScreen(
      {Key key,
      @required userRepository,
      Restaurant restaurant,
      Client userRestaurant})
      : assert(userRepository != null),
        _userRepository = userRepository,
        _restaurant = restaurant,
        _userRestaurant = userRestaurant,
        super(key: key);

  @override
  _RestaurantHomeScreenState createState() => _RestaurantHomeScreenState();
}

class _RestaurantHomeScreenState extends State<RestaurantHomeScreen> {
  UserRepository get _userRepository => widget._userRepository;
  Restaurant get _restaurant => widget._restaurant;
  Client get _userRestaurant => widget._userRestaurant;

  List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      RestaurantReservations(
          userRepository: _userRepository,
          restaurant: _restaurant,
          userRestaurant: _userRestaurant),
      RestaurantProfile(),
    ];
  }

  final Map<String, IconData> _icons = const {
    'Reservas': Icons.collections_bookmark,
    'Perfil': Icons.person,
  };

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: _icons
            .map(
              (title, icon) => MapEntry(
                title,
                BottomNavigationBarItem(
                  icon: Icon(icon, size: 30.0),
                  title: Text(title),
                ),
              ),
            )
            .values
            .toList(),
        currentIndex: _currentIndex,
        selectedItemColor: brandColor,
        selectedFontSize: 15.0,
        unselectedItemColor: Colors.grey,
        unselectedFontSize: 13.0,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
