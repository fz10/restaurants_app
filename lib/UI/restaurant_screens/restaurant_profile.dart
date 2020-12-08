import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:restaurants_app/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:restaurants_app/blocs/restaurant_profile/bloc/restaurant_profile_bloc.dart';
import 'package:restaurants_app/models/models.dart';
import 'package:restaurants_app/repositories/user_repository.dart';
import 'package:restaurants_app/resources/style.dart';
import 'package:string_validator/string_validator.dart';

class RestaurantProfile extends StatefulWidget {
  final UserRepository _userRepository;
  final Restaurant _restaurant;

  const RestaurantProfile(
      {Key key, @required userRepository, @required restaurant})
      : assert(userRepository != null),
        _restaurant = restaurant,
        _userRepository = userRepository,
        super(key: key);

  @override
  _RestaurantProfileState createState() => _RestaurantProfileState();
}

class _RestaurantProfileState extends State<RestaurantProfile> {
  UserRepository get _userRepository => widget._userRepository;
  Restaurant get _restaurant => widget._restaurant;

  RestaurantProfileBloc _profileBloc;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _cuisineController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _tablesController = TextEditingController();
  TextEditingController _openController = TextEditingController();
  TextEditingController _closeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _profileBloc = RestaurantProfileBloc(userRepository: _userRepository);
    _profileBloc.add(LoadScreenData(restId: _restaurant.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _profileBloc,
      child: BlocListener(
        cubit: _profileBloc,
        listener: (context, state) {},
        child: BlocBuilder(
          cubit: _profileBloc,
          builder: (context, state) {
            if (state is Success) {
              return _showProfile(state.restaurant, context);
            } else if (state is ShowEditScreen) {
              return _showEditScreen(state.restaurant, context);
            } else {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 100),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _showProfile(Restaurant restaurant, BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del restaurante'),
        centerTitle: true,
        backgroundColor: brandColor,
        actions: [
          IconButton(
              icon: Icon(
                Icons.exit_to_app,
                size: 30,
              ),
              tooltip: 'Salir',
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Editar',
        backgroundColor: brandColor,
        onPressed: () {
          _profileBloc.add(EditProfile());
        },
        child: Icon(Icons.edit, color: Colors.white, size: 30),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  Text(restaurant.name, style: restNameStyle),
                  Text(restaurant.cuisine, style: subTitle),
                  Divider(color: Colors.grey, thickness: 2)
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.phone,
                        size: 40,
                      ),
                      Text('Teléfono', style: subTitle),
                    ],
                  ),
                  Text(restaurant.phone, style: subTitle2),
                  Divider(color: Colors.grey, thickness: 2)
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home,
                        size: 40,
                      ),
                      Text('Dirección', style: subTitle),
                    ],
                  ),
                  Text(
                    restaurant.address,
                    style: TextStyle(fontSize: 20),
                  ),
                  Divider(color: Colors.grey, thickness: 2)
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.access_time, size: 30),
                          Text('Abre', style: subTitle2),
                        ],
                      ),
                      Text(restaurant.open, style: TextStyle(fontSize: 25)),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.access_time, size: 30),
                          Text('Cierra', style: subTitle2),
                        ],
                      ),
                      Text(restaurant.close, style: TextStyle(fontSize: 25)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            sliver: SliverToBoxAdapter(
              child: Divider(color: Colors.grey, thickness: 2),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 5),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Menú',
                    style: subTitle2,
                  ),
                  Text('Mesas: ${restaurant.tables['tables']}',
                      style: subTitle2),
                ],
              ),
            ),
          ),
          (restaurant.menu['Platos'] != null)
              ? SliverToBoxAdapter(
                  child: Column(
                    children: [
                      showMenuTitle('Platos'),
                      showMenuItems(restaurant.menu['Platos'], 'Platos', false),
                    ],
                  ),
                )
              : SliverToBoxAdapter(child: Container()),
          (restaurant.menu['Bebidas'] != null)
              ? SliverToBoxAdapter(
                  child: Column(
                    children: [
                      showMenuTitle('Bebidas'),
                      showMenuItems(
                          restaurant.menu['Bebidas'], 'Bebidas', false),
                    ],
                  ),
                )
              : SliverToBoxAdapter(child: Container()),
          (restaurant.menu['Otros'] != null)
              ? SliverToBoxAdapter(
                  child: Column(
                  children: [
                    showMenuTitle('Otros'),
                    showMenuItems(restaurant.menu['Otros'], 'Otros', false),
                  ],
                ))
              : SliverToBoxAdapter(child: Container()),
        ],
      ),
    );
  }

  Widget showMenuTitle(String title) {
    Icon iconType;
    if (title == 'Platos') {
      iconType = Icon(Icons.local_dining);
    } else if (title == 'Bebidas') {
      iconType = Icon(Icons.local_cafe);
    } else {
      iconType = Icon(Icons.fastfood);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              iconType,
            ],
          ),
        )
      ],
    );
  }

  Widget showMenuItems(Map<String, dynamic> items, String title, bool isEdit) {
    return Container(
      height: 150,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          String item = items.keys.elementAt(index);
          return Container(
            width: 200,
            child: Card(
              shape: cardShape,
              color: Colors.white,
              elevation: 10,
              child: ListTile(
                shape: cardShape,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                title: Text(
                  item,
                  style: cardTitleStyle,
                ),
                subtitle: Text(
                  'Precio: \$ ${items[item]}',
                  style: cardSubtytleStyle,
                ),
                onTap: () {
                  if (isEdit) {
                    return _showItemDialog(
                        {'item': item, 'price': items[item]}, title);
                  } else {
                    print('Tapped');
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Future<Widget> _showAddDialog(String type) {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Form(
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.local_dining),
                    labelText: 'Producto',
                  ),
                  textAlign: TextAlign.center,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Ingresar producto';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 5),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.attach_money),
                    labelText: 'Precio',
                  ),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Ingresar precio';
                    }
                    return null;
                  },
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    priceController.text.isNotEmpty) {
                  _profileBloc.add(AddItem(
                      type: type,
                      name: nameController.text,
                      price: toDouble(priceController.text)));
                  Navigator.pop(context);
                }
              },
              child: Text('Agregar'),
            ),
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancelar')),
          ],
        );
      },
    );
  }

  Future<Widget> _showItemDialog(Map<String, dynamic> item, String type) {
    TextEditingController priceController =
        TextEditingController(text: item['price'].toString());

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              Text(item['item']),
              Form(
                  child: TextFormField(
                controller: priceController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.attach_money),
                  labelText: 'Precio',
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Ingresar precio';
                  }
                  return null;
                },
              )),
            ],
          ),
          actions: <Widget>[
            RaisedButton(
              onPressed: () {
                _profileBloc.add(UpdateItem(
                    type: type,
                    name: item['item'],
                    price: toDouble(priceController.text)));
                Navigator.pop(context);
              },
              color: Colors.green,
              child: Text(
                'Actualizar',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            RaisedButton(
              color: Colors.red,
              onPressed: () {
                _profileBloc.add(DeleteItem(type: type, name: item['item']));
                Navigator.pop(context);
              },
              child: Text(
                'Eliminar',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancelar')),
          ],
        );
      },
    );
  }

  Widget _showEditScreen(Restaurant restaurant, BuildContext context) {
    _nameController.text = restaurant.name;
    _cuisineController.text = restaurant.cuisine;
    _phoneController.text = restaurant.phone;
    _addressController.text = restaurant.address;
    _tablesController.text = restaurant.tables['tables'].toString();
    _openController.text = restaurant.open;
    _closeController.text = restaurant.close;

    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.green,
            tooltip: 'Confirmar',
            onPressed: () {
              _profileBloc.add(ApplyChanges(restId: _restaurant.id));
            },
            child: Icon(Icons.check, size: 25, color: Colors.white),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            backgroundColor: Colors.red,
            tooltip: 'Cancelar',
            onPressed: () {
              _profileBloc.add(CancelChanges(restId: _restaurant.id));
            },
            child: Icon(Icons.close, size: 25, color: Colors.white),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
            sliver: SliverToBoxAdapter(
              child: Form(
                child: Column(
                  children: [
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
                      onFieldSubmitted: (value) => _updateFields(),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _cuisineController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.restaurant_menu),
                        labelText: 'Cocina',
                      ),
                      autocorrect: false,
                      autovalidate: true,
                      onFieldSubmitted: (value) => _updateFields(),
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
                      onFieldSubmitted: (value) => _updateFields(),
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
                      onFieldSubmitted: (value) => _updateFields(),
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
                      onFieldSubmitted: (value) => _updateFields(),
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
                            _openController.text = DateFormat.Hm().format(time);
                            _updateFields();
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
                            _closeController.text =
                                DateFormat.Hm().format(time);
                            _updateFields();
                          },
                        );
                      },
                      readOnly: true,
                      autocorrect: false,
                      autovalidate: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Row(
                  children: [
                    showMenuTitle('Platos'),
                    IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.blue,
                        size: 30,
                      ),
                      onPressed: () {
                        _showAddDialog('Platos');
                      },
                    ),
                  ],
                ),
                (restaurant.menu['Platos'] != null)
                    ? showMenuItems(restaurant.menu['Platos'], 'Platos', true)
                    : Container(),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Row(
                  children: [
                    showMenuTitle('Bebidas'),
                    IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.blue,
                        size: 30,
                      ),
                      onPressed: () {
                        _showAddDialog('Bebidas');
                      },
                    ),
                  ],
                ),
                (restaurant.menu['Bebidas'] != null)
                    ? showMenuItems(restaurant.menu['Bebidas'], 'Bebidas', true)
                    : Container,
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Row(
                  children: [
                    showMenuTitle('Otros'),
                    IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.blue,
                        size: 30,
                      ),
                      onPressed: () {
                        _showAddDialog('Otros');
                      },
                    ),
                  ],
                ),
                (restaurant.menu['Otros'] != null)
                    ? showMenuItems(restaurant.menu['Otros'], 'Otros', true)
                    : Container(),
              ],
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 70)),
        ],
      ),
    );
  }

  void _updateFields() {
    return _profileBloc.add(UpdateFields(
        name: _nameController.text,
        cuisine: _cuisineController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        tables: toInt(_tablesController.text),
        from: _openController.text,
        until: _closeController.text));
  }

  @override
  void dispose() {
    _profileBloc.close();
    super.dispose();
  }
}
