import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurants_app/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:restaurants_app/models/models.dart';
import 'package:restaurants_app/repositories/user_repository.dart';
import 'package:restaurants_app/resources/style.dart';

class RestaurantHomeScreen extends StatefulWidget {
  final UserRepository _userRepository;
  final Restaurant _restaurant;

  const RestaurantHomeScreen(
      {Key key, @required userRepository, Restaurant restaurant})
      : assert(userRepository != null),
        _userRepository = userRepository,
        _restaurant = restaurant,
        super(key: key);
  @override
  _RestaurantHomeScreenState createState() => _RestaurantHomeScreenState();
}

class _RestaurantHomeScreenState extends State<RestaurantHomeScreen> {
  Restaurant get _restaurant => widget._restaurant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio Restaurante'),
        backgroundColor: brandColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(
                LoggedOut(),
              );
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(child: Text('Bienvenido administrador de ${_restaurant.name}!')),
        ],
      ),
    );
  }
}
