import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:restaurants_app/models/models.dart';
import 'package:restaurants_app/repositories/user_repository.dart';

part 'client_search_event.dart';
part 'client_search_state.dart';

class ClientSearchBloc extends Bloc<ClientSearchEvent, ClientSearchState> {
  UserRepository _userRepository;
  List<Restaurant> _restaurantList;

  ClientSearchBloc({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository,
        super(ClientSearchInitial());

  @override
  Stream<ClientSearchState> mapEventToState(
    ClientSearchEvent event,
  ) async* {
    if (event is InitSearch) {
      yield* _mapInitSearchToState();
    } else if (event is SearchSubmitted) {
      yield* _mapSubmittedToState(event.queryText);
    }
  }

  Stream<ClientSearchState> _mapSubmittedToState(String queryText) async* {
    yield LoadingData();
    try {
      if (queryText == '') {
        yield Success(restaurantList: this._restaurantList);
      } else if (this._restaurantList.length > 0) {
        final List<Restaurant> restList = this._restaurantList.map((element) {
          if (element.cuisine == queryText || element.name == queryText) {
            return element;
          }
        }).toList()
          ..removeWhere((element) => element == null);
        yield Success(restaurantList: restList);
      } else {
        yield NoResults(message: 'No se encontraron resultados...');
      }
    } catch (_) {
      yield Failure(message: 'Error de filtro...');
    }
  }

  Stream<ClientSearchState> _mapInitSearchToState() async* {
    yield LoadingData();
    try {
      final restaurantList = await _userRepository.getAllRestaurants();
      this._restaurantList = restaurantList;
      yield Success(restaurantList: restaurantList);
    } catch (e) {
      yield Failure(message: 'Error al cargar restaurantes');
    }
  }
}
