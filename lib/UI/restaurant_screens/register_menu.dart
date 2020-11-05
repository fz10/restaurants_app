import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurants_app/blocs/authentication/bloc/bloc.dart';
import 'package:restaurants_app/blocs/menu_register/bloc/bloc.dart';
import 'package:restaurants_app/models/models.dart';
import 'package:restaurants_app/repositories/user_repository.dart';
import 'package:restaurants_app/resources/style.dart';

class RegisterMenu extends StatefulWidget {
  final UserRepository _userRepository;
  final Restaurant _restaurant;

  const RegisterMenu({Key key, @required userRepository, @required restaurant})
      : assert(userRepository != null),
        _userRepository = userRepository,
        _restaurant = restaurant,
        super(key: key);

  @override
  RegisterMenuState createState() => RegisterMenuState();
}

class RegisterMenuState extends State<RegisterMenu> {
  Restaurant get _restaurant => widget._restaurant;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  MenuRegisterBloc _menuRegisterBloc;

  var _type = ['Plato', 'Bebida', 'Otro'];

  var _currentItemSelected;

  @override
  void initState() {
    super.initState();
    _menuRegisterBloc = MenuRegisterBloc(
      userRepository: widget._userRepository,
      restaurant: _restaurant,
    );
    _currentItemSelected = _type[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocProvider(
          create: (context) => _menuRegisterBloc,
          child: BlocListener(
            cubit: _menuRegisterBloc,
            listener: (BuildContext context, MenuRegisterState state) {
              if (state is LoadingData) {
                Scaffold.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Agregando productos...'),
                          CircularProgressIndicator(),
                        ],
                      ),
                    ),
                  );
              } else if (state is ItemSuccessfullyAdded) {
                Scaffold.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Producto añadido...'),
                          Icon(Icons.check_circle),
                        ],
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                _resetFields();
              } else if (state is Success) {
                BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
              } else if (state is Failure) {
                Scaffold.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Ocurrió un error'),
                          Icon(Icons.error),
                        ],
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
              }
            },
            child: BlocBuilder(
              cubit: _menuRegisterBloc,
              builder: (BuildContext context, MenuRegisterState state) {
                return Stack(
                  children: [
                    getBackgroundImageBlur(),
                    Scaffold(
                      backgroundColor: Colors.transparent,
                      appBar: AppBar(
                        actions: <Widget>[
                          Row(
                            children: [
                              Text(
                                'Salir',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.exit_to_app,
                                  size: 30,
                                ),
                                onPressed: () {
                                  BlocProvider.of<AuthenticationBloc>(context)
                                      .add(
                                    LoggedOut(),
                                  );
                                },
                              ),
                            ],
                          )
                        ],
                        backgroundColor: Colors.transparent,
                        elevation: 0.0,
                      ),
                      body: Padding(
                        padding: EdgeInsets.all(20),
                        child: Form(
                          child: ListView(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 0),
                                child: Text(
                                  'Registra el menú para: ${_restaurant.name}',
                                  style: menuRegStyle,
                                ),
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
                                  items: _type.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Row(
                                        children: [
                                          Icon(Icons.fastfood),
                                          SizedBox(width: 10),
                                          Text(value),
                                        ],
                                      ),
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
                                controller: _nameController,
                                decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  filled: true,
                                  fillColor: Colors.white,
                                  prefixIcon: Icon(Icons.local_dining),
                                  labelText: 'Nombre',
                                ),
                                autocorrect: false,
                                autovalidate: true,
                              ),
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _priceController,
                                      decoration: InputDecoration(
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        filled: true,
                                        fillColor: Colors.white,
                                        prefixIcon: Icon(Icons.attach_money),
                                        labelText: 'Precio',
                                      ),
                                      keyboardType: TextInputType.number,
                                      autocorrect: false,
                                      autovalidate: true,
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  SizedBox(
                                    height: 55,
                                    child: RaisedButton(
                                      color: brandColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      onPressed: _onAddSubmitted,
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: SizedBox(
                                  height: 45,
                                  child: RaisedButton(
                                    color: brandColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    onPressed: () {
                                      _menuRegisterBloc.add(Submitted());
                                    },
                                    child: Text(
                                      'Finalizar',
                                      style: normalButton,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _onDropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }

  void _resetFields() {
    setState(() {
      _nameController.text = '';
      _priceController.text = '';
      _currentItemSelected = _type[0];
    });
  }

  void _onAddSubmitted() {
    _menuRegisterBloc.add(ItemAdded(
        type: _currentItemSelected + 's',
        name: _nameController.text,
        price: _priceController.text));
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

  @override
  void dispose() {
    _menuRegisterBloc.close();
    super.dispose();
  }
}
