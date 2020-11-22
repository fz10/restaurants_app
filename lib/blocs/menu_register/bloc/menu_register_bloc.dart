import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:restaurants_app/models/models.dart';
import 'package:restaurants_app/repositories/user_repository.dart';
import 'package:string_validator/string_validator.dart';

part 'menu_register_event.dart';
part 'menu_register_state.dart';

class MenuRegisterBloc extends Bloc<MenuRegisterEvent, MenuRegisterState> {
  final UserRepository _userRepository;
  final Restaurant _restaurant;
  Map<String, Map<String, double>> _menu;

  MenuRegisterBloc(
      {@required UserRepository userRepository,
      @required Restaurant restaurant})
      : assert(userRepository != null),
        _userRepository = userRepository,
        _restaurant = restaurant,
        _menu = {'Platos': {}, 'Bebidas': {}, 'Otros': {}},
        super(MenuRegisterInitial());

  @override
  Stream<MenuRegisterState> mapEventToState(
    MenuRegisterEvent event,
  ) async* {
    if (event is ItemAdded) {
      yield* _mapItemAddedToState(event.type, event.name, event.price);
    } else if (event is Submitted) {
      yield* _mapSubmittedToState();
    }
  }

  Stream<MenuRegisterState> _mapItemAddedToState(
      String type, String name, String price) async* {
    yield LoadingData();
    try {
      if (name != '' && price != '') {
        _menu[type].addAll({name: toDouble(price)});
        yield ItemSuccessfullyAdded();
      } else {
        yield Failure();
      }
    } catch (e) {
      print('failure is: $e');
      yield Failure();
    }
  }

  Stream<MenuRegisterState> _mapSubmittedToState() async* {
    yield LoadingData();
    try {
      if (_menu.length > 0) {
        await _userRepository.registerMenu(this._restaurant, this._menu);
        yield Success();
      } else {
        yield Failure();
      }
    } catch (e) {
      print('failure is: $e');
      yield Failure();
    }
  }
}
