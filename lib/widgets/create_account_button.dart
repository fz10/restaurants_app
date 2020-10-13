import 'package:flutter/material.dart';
import 'package:restaurants_app/UI/register/register_screen.dart';
import 'package:restaurants_app/repositories/user_repository.dart';
import 'package:restaurants_app/resources/style.dart';

class CreateAccountButton extends StatelessWidget {
  final String _role;
  final UserRepository _userRepository;

  CreateAccountButton({Key key, @required String role, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        _role = role,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        'Sign up',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return RegisterScreen(role: _role,userRepository: _userRepository);
          }),
        );
      },
    );
  }
}
