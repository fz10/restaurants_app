import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:restaurants_app/blocs/authentication/bloc/bloc.dart';
import 'package:restaurants_app/blocs/restaurant_register/bloc.dart';
import 'package:restaurants_app/models/models.dart';
import 'package:restaurants_app/resources/style.dart';
import 'package:restaurants_app/widgets/register_button.dart';

class RegisterForm extends StatefulWidget {
  RegisterForm({Key key, @required userRepository, @required String role})
      : super(key: key);

  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _tablesController = TextEditingController();
  final TextEditingController _openController = TextEditingController();
  final TextEditingController _closeController = TextEditingController();

  RestaurantRegisterBloc _registerBloc;

  var _cuisines = [
    'Comida rápida',
    'China',
    'Japonesa',
    'Italiana',
    'Francesa',
    'Mexicana',
    'Colombiana',
    'Otra'
  ];

  var _currentItemSelected = '';

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RestaurantRegisterBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    _currentItemSelected = _cuisines[0];
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
                          prefixIcon: Icon(Icons.restaurant),
                          labelText: 'Nombre',
                        ),
                        autocorrect: false,
                        autovalidate: true,
                      ),
                      SizedBox(height: 15),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: DropdownButton<String>(
                          dropdownColor: Colors.white,
                          isExpanded: true,
                          items: _cuisines.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          value: _currentItemSelected,
                          onChanged: (String newValueSelected) {
                            _onDropDownItemSelected(newValueSelected);
                          },
                        ),
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
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.home),
                          labelText: 'Dirección',
                        ),
                        autocorrect: false,
                        autovalidate: true,
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _tablesController,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Mesas totales',
                        ),
                        keyboardType: TextInputType.number,
                        autocorrect: false,
                        autovalidate: true,
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _openController,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          prefixIcon: Icon(Icons.access_time),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Hora apertura',
                        ),
                        onTap: () {
                          DatePicker.showTimePicker(
                            context,
                            showSecondsColumn: false,
                            onConfirm: (time) {
                              setState(() {
                                _openController.text =
                                    DateFormat.Hm().format(time);
                              });
                            },
                          );
                        },
                        readOnly: true,
                        autocorrect: false,
                        autovalidate: true,
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _closeController,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          prefixIcon: Icon(Icons.access_time),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Hora cierre',
                        ),
                        onTap: () {
                          DatePicker.showTimePicker(
                            context,
                            showSecondsColumn: false,
                            onConfirm: (time) {
                              setState(() {
                                _closeController.text =
                                    DateFormat.Hm().format(time);
                              });
                            },
                          );
                        },
                        readOnly: true,
                        autocorrect: false,
                        autovalidate: true,
                      ),
                      SizedBox(height: 15),
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
    super.dispose();
  }

  void _onDropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
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
            role: 'admin',
            email: _emailController.text,
            regDate: DateTime.now()),
        restaurant: Restaurant(
          name: _nameController.text,
          cuisine: _currentItemSelected,
          phone: _phoneController.text,
          address: _addressController.text,
          open: _openController.text,
          close: _closeController.text,
          tables: {
            'tables': int.parse(_tablesController.text),
            'available': int.parse(_tablesController.text),
          },
        ),
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}
