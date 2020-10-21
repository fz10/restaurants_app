import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:restaurants_app/models/models.dart';

import 'package:restaurants_app/repositories/user_repository.dart';
import 'package:restaurants_app/blocs/validators.dart';

part 'restaurant_register_event.dart';
part 'restaurant_register_state.dart';

class RestaurantRegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;

  RestaurantRegisterBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(RegisterState.empty());

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is Submitted) {
      yield* _mapFormSubmittedToState(
          event.client, event.restaurant, event.email, event.password);
    }
  }

  Stream<RegisterState> _mapEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<RegisterState> _mapPasswordChangedToState(String password) async* {
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<RegisterState> _mapFormSubmittedToState(
    Client client,
    Restaurant restaurant,
    String email,
    String password,
  ) async* {
    yield RegisterState.loading();
    try {
      await _userRepository
          .signUp(
            email: email,
            password: password,
          )
          .then((value) => _userRepository.addUser(client))
          .then((value) => _userRepository.addRestaurant(restaurant));
      yield RegisterState.success();
    } catch (_) {
      yield RegisterState.failure();
    }
  }
}
