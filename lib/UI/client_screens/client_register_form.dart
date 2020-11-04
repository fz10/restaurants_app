import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurants_app/blocs/authentication/bloc/bloc.dart';
import 'package:restaurants_app/blocs/client_register/bloc/bloc.dart';
import 'package:restaurants_app/models/models.dart';
import 'package:restaurants_app/resources/style.dart';
import 'package:restaurants_app/widgets/register_button.dart';

class ClientRegisterForm extends StatefulWidget {
  ClientRegisterForm({Key key, @required String role}) : super(key: key);

  State<ClientRegisterForm> createState() => _ClientRegisterForm();
}

class _ClientRegisterForm extends State<ClientRegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  ClientRegisterBloc _registerBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<ClientRegisterBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: _registerBloc,
      listener: (BuildContext context, RegisterState state) {
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Registrando...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Registro inválido'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: BlocBuilder(
        cubit: _registerBloc,
        builder: (BuildContext context, RegisterState state) {
          return Stack(children: [
            getBackgroundImageBlur(),
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: new AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                  onPressed: () => moveToLastScreen(),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
              body: Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  child: ListView(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'Regístrate',
                            style: title2,
                          )),
                      SizedBox(height: 40),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.email),
                          labelText: 'Correo',
                        ),
                        autocorrect: false,
                        autovalidate: true,
                        validator: (_) {
                          return !state.isEmailValid ? 'Invalid Email' : null;
                        },
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.lock),
                          labelText: 'Contraseña',
                        ),
                        obscureText: true,
                        autocorrect: false,
                        autovalidate: true,
                        validator: (_) {
                          return !state.isPasswordValid
                              ? 'Invalid Password'
                              : null;
                        },
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.face),
                          labelText: 'Nombre',
                        ),
                        autocorrect: false,
                        autovalidate: true,
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _lastController,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.face),
                          labelText: 'Apellido',
                        ),
                        autocorrect: false,
                        autovalidate: true,
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.phone),
                          labelText: 'Teléfono',
                        ),
                        keyboardType: TextInputType.number,
                        autocorrect: false,
                        autovalidate: true,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: RegisterButton(
                            onPressed: isRegisterButtonEnabled(state)
                                ? _onFormSubmitted
                                : null),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]);
        },
      ),
    );
  }

  Widget getBackgroundImageBlur() {
    double _sigmaX = 20.0;
    double _sigmaY = 20.0;
    double _opacity = 0.2;

    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/InitBackgroundImage.jpg'),
            fit: BoxFit.cover),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
        child: Container(
          color: Colors.black.withOpacity(_opacity),
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _lastController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _registerBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _registerBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _registerBloc.add(
      Submitted(
        client: Client(
          role: 'client',
          name: _nameController.text,
          last: _lastController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          regDate: DateTime.now(),
        ),
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}
