import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurants_app/UI/login/login_form.dart';
import 'package:restaurants_app/blocs/login/bloc/bloc.dart';
import 'package:restaurants_app/repositories/user_repository.dart';

class LoginScreen extends StatefulWidget {
  final String _role;
  final UserRepository _userRepository;

  LoginScreen(
      {Key key, @required String role, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        _role = role,
        super(key: key);

  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(
      userRepository: _userRepository,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => _loginBloc,
        child: LoginForm(role: widget._role, userRepository: _userRepository),
      ),
    );
  }

  @override
  void dispose() {
    _loginBloc.close();
    super.dispose();
  }
}
