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

  ClientSearchBloc({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository,
        super(ClientSearchInitial());

  @override
  Stream<ClientSearchState> mapEventToState(
    ClientSearchEvent event,
  ) async* {
    if (event is SearchSubmitted) {
      yield* _mapSubmittedToState(event.queryText);
    }
  }

  Stream<ClientSearchState> _mapSubmittedToState(String queryText) async* {
    yield LoadingData();
    try {
      final List<Restaurant> restaurantList =
          await _userRepository.searchRestaurants(queryText);
      if (restaurantList.isNotEmpty) {
        yield Success(restaurantList: restaurantList);
      } else {
        yield NoResults(message: 'No se encontraron resultados...');
      }
    } catch (e) {
      print('Failure is: $e');
      yield Failure(message: 'Error de búsqueda');
    }
  }
}
