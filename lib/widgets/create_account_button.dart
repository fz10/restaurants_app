import 'package:flutter/material.dart';
import 'package:restaurants_app/UI/client_screens/client_register_screen.dart';
import 'package:restaurants_app/UI/restaurant_screens/restaurant_register_screen.dart';
import 'package:restaurants_app/repositories/user_repository.dart';

class CreateAccountButton extends StatelessWidget {
  final String _role;
  final UserRepository _userRepository;

  CreateAccountButton(
      {Key key, @required String role, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        _role = role,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        'Regístrate',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            if (_role == 'client') {
              return ClientRegisterScreen(userRepository: _userRepository);
            } else if (_role == 'admin') {
              return RestaurantRegisterScreen(userRepository: _userRepository);
            }
          }),
        );
      },
    );
  }
}
