import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:restaurants_app/models/models.dart';
import 'package:restaurants_app/repositories/user_repository.dart';

part 'restaurant_profile_event.dart';
part 'restaurant_profile_state.dart';

class RestaurantProfileBloc
    extends Bloc<RestaurantProfileEvent, RestaurantProfileState> {
  UserRepository _userRepository;
  String _name;
  String _cuisine;
  String _phone;
  String _address;
  Map<String, dynamic> _tables;
  String _from;
  String _until;

  Map<String, dynamic> _menu;

  RestaurantProfileBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(RestaurantProfileInitial());

  @override
  Stream<RestaurantProfileState> mapEventToState(
    RestaurantProfileEvent event,
  ) async* {
    if (event is LoadScreenData) {
      yield* _mapLoadScreenDataToState(event.restId);
    } else if (event is EditProfile) {
      yield* _mapEditProfileToState();
    } else if (event is ApplyChanges) {
      yield* _mapApplyChangesToState(event.restId);
    } else if (event is CancelChanges) {
      yield* _mapLoadScreenDataToState(event.restId);
    } else if (event is UpdateFields) {
      yield* _mapUpdateFieldsToState(event);
    } else if (event is UpdateItem) {
      yield* _mapUpdateItemToState(event.type, event.name, event.price);
    } else if (event is AddItem) {
      yield* _mapAddItemToState(event.type, event.name, event.price);
    } else if (event is DeleteItem) {
      yield* _mapDeleteItemTostate(event.type, event.name);
    }
  }

  Stream<RestaurantProfileState> _mapLoadScreenDataToState(
      String restId) async* {
    yield LoadingChanges();
    try {
      final restaurant = await _userRepository.getRestaurant(restId);
      _name = restaurant.name;
      _cuisine = restaurant.cuisine;
      _phone = restaurant.phone;
      _address = restaurant.address;
      _tables = {
        'tables': restaurant.tables['tables'],
        'available': restaurant.tables['available']
      };
      _from = restaurant.open;
      _until = restaurant.close;
      _menu = restaurant.menu;
      yield Success(restaurant: restaurant);
    } catch (e) {
      yield Failure(message: 'Error al cargar perfil');
      print('Error is $e');
    }
  }

  Stream<RestaurantProfileState> _mapEditProfileToState() async* {
    yield ShowEditScreen(
        restaurant: Restaurant(
      name: _name,
      cuisine: _cuisine,
      phone: _phone,
      address: _address,
      tables: _tables,
      open: _from,
      close: _until,
      menu: _menu,
    ));
  }

  Stream<RestaurantProfileState> _mapApplyChangesToState(String restId) async* {
    yield LoadingChanges();
    try {
      Restaurant restaurant = Restaurant(
        id: restId,
        name: _name,
        cuisine: _cuisine,
        phone: _phone,
        address: _address,
        tables: _tables,
        open: _from,
        close: _until,
        menu: _menu,
      );
      await _userRepository.updateRestaurant(restaurant);
      yield (Success(restaurant: restaurant));
    } catch (e) {
      yield Failure(message: 'Error al guardar los cambios');
      print('Error is $e');
    }
  }

  Stream<RestaurantProfileState> _mapUpdateFieldsToState(
      UpdateFields event) async* {
    yield (LoadingChanges());
    _name = event.name;
    _cuisine = event.cuisine;
    _phone = event.phone;
    _address = event.address;
    _tables['tables'] = event.tables;
    _tables['available'] = event.tables;
    _from = event.from;
    _until = event.until;
    yield (ShowEditScreen(
        restaurant: Restaurant(
      name: _name,
      cuisine: _cuisine,
      phone: _phone,
      address: _address,
      tables: _tables,
      open: _from,
      close: _until,
      menu: _menu,
    )));
  }

  Stream<RestaurantProfileState> _mapUpdateItemToState(
      String type, String name, double price) async* {
    yield (LoadingChanges());
    _menu[type][name] = price;
    yield (ShowEditScreen(
        restaurant: Restaurant(
      name: _name,
      cuisine: _cuisine,
      phone: _phone,
      address: _address,
      tables: _tables,
      open: _from,
      close: _until,
      menu: _menu,
    )));
  }

  Stream<RestaurantProfileState> _mapAddItemToState(
      String type, String name, double price) async* {
    yield (LoadingChanges());
    if (_menu[type] != null) {
      _menu[type][name] = price;
    } else {
      _menu[type] = Map<String, dynamic>();
      _menu[type][name] = price;
    }
    _menu[type][name] = price;
    yield (ShowEditScreen(
        restaurant: Restaurant(
      name: _name,
      cuisine: _cuisine,
      phone: _phone,
      address: _address,
      tables: _tables,
      open: _from,
      close: _until,
      menu: _menu,
    )));
  }

  Stream<RestaurantProfileState> _mapDeleteItemTostate(
      String type, String name) async* {
    yield (LoadingChanges());
    _menu[type].remove(name);
    yield (ShowEditScreen(
        restaurant: Restaurant(
      name: _name,
      cuisine: _cuisine,
      phone: _phone,
      address: _address,
      tables: _tables,
      open: _from,
      close: _until,
      menu: _menu,
    )));
  }
}
