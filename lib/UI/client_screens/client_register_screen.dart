import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurants_app/UI/client_screens/client_register_form.dart';
import 'package:restaurants_app/repositories/user_repository.dart';
import 'package:restaurants_app/blocs/client_register/bloc/bloc.dart';

class ClientRegisterScreen extends StatefulWidget {
  final UserRepository _userRepository;
  final String _role;

  ClientRegisterScreen({Key key, @required UserRepository userRepository, String role})
      : assert(userRepository != null),
        _userRepository = userRepository,
        _role = role,
        super(key: key);

  State<ClientRegisterScreen> createState() => _ClientRegisterScreen();
}

class _ClientRegisterScreen extends State<ClientRegisterScreen> {
  ClientRegisterBloc _registerBloc;

  @override
  void initState() {
    super.initState();
    _registerBloc = ClientRegisterBloc(
      userRepository: widget._userRepository,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocProvider<ClientRegisterBloc>(
          create: (context) => _registerBloc,
          child: ClientRegisterForm(role: widget._role),
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