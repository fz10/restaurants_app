import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurants_app/UI/register/register_form.dart';
import 'package:restaurants_app/repositories/user_repository.dart';
import 'package:restaurants_app/blocs/register/bloc/bloc.dart';

class RegisterScreen extends StatefulWidget {
  final UserRepository _userRepository;
  final String _role;

  RegisterScreen({Key key, @required UserRepository userRepository, String role})
      : assert(userRepository != null),
        _userRepository = userRepository,
        _role = role,
        super(key: key);

  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  RegisterBloc _registerBloc;

  @override
  void initState() {
    super.initState();
    _registerBloc = RegisterBloc(
      userRepository: widget._userRepository,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocProvider<RegisterBloc>(
          bloc: _registerBloc,
          child: RegisterForm(role: widget._role),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _registerBloc.dispose();
    super.dispose();
  }
}