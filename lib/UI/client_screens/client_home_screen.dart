import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurants_app/blocs/authentication/bloc/bloc.dart';
import 'package:restaurants_app/models/client.dart';
import 'package:restaurants_app/repositories/user_repository.dart';
import 'package:restaurants_app/resources/style.dart';

class ClientHomeScreen extends StatefulWidget {
  final UserRepository _userRepository;
  final Client _user;

  const ClientHomeScreen({Key key, @required userRepository, Client user})
      : assert(userRepository != null),
        _userRepository = userRepository,
        _user = user,
        super(key: key);

  @override
  _ClientHomeScreenState createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  Client get _user => widget._user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio Cliente'),
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
          Center(child: Text('Welcome ${_user.name} ${_user.last}!')),
        ],
      ),
    );
  }
}
