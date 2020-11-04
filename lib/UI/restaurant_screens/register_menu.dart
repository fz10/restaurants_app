import 'package:flutter/material.dart';
import 'package:restaurants_app/models/models.dart';
import 'package:restaurants_app/repositories/user_repository.dart';

class RegisterMenu extends StatefulWidget {
  final UserRepository _userRepository;
  final Restaurant _restaurant;

  const RegisterMenu({Key key, @required userRepository, @required restaurant})
      : assert(userRepository != null),
        _userRepository = userRepository,
        _restaurant = restaurant,
        super(key: key);

  @override
  RegisterMenuState createState() => RegisterMenuState();
}

class RegisterMenuState extends State<RegisterMenu> {
  Restaurant get _restaurant => widget._restaurant;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Registrar menú de ${_restaurant.name}!'),
      ),
    );
  }
}
