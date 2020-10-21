import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurants_app/UI/restaurant_screens/restaurant_register_form.dart';
import 'package:restaurants_app/repositories/user_repository.dart';
import 'package:restaurants_app/blocs/restaurant_register/bloc.dart';

class RestaurantRegisterScreen extends StatefulWidget {
  final UserRepository _userRepository;
  final String _role;

  RestaurantRegisterScreen({Key key, @required UserRepository userRepository, String role})
      : assert(userRepository != null),
        _userRepository = userRepository,
        _role = role,
        super(key: key);

  State<RestaurantRegisterScreen> createState() => _RestaurantRegisterScreen();
}

class _RestaurantRegisterScreen extends State<RestaurantRegisterScreen> {
  RestaurantRegisterBloc _registerBloc;

  @override
  void initState() {
    super.initState();
    _registerBloc = RestaurantRegisterBloc(
      userRepository: widget._userRepository,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocProvider<RestaurantRegisterBloc>(
          create: (context) => _registerBloc,
          child: RegisterForm(userRepository: widget._userRepository, role: widget._role),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _registerBloc.close();
    super.dispose();
  }
}