import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurants_app/models/models.dart';
import 'package:restaurants_app/repositories/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(Uninitialized());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    yield Loading();
    try {
      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        final user = await _userRepository.getUser();
        if (user.role == 'client') {
          yield AuthenticatedClient(user: user);
        } else {
          final restaurant =
              await _userRepository.getRestaurant(user.restaurantId);
          if (restaurant.menu == null) {
            yield NotMenu(restaurant);
          } else {
            yield AuthenticatedRestaurant(restaurant: restaurant);
          }
        }
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    yield Loading();
    try {
      final user = await _userRepository.getUser();
      if (user.role == 'client') {
        yield AuthenticatedClient(user: user);
      } else if (user.role == 'admin') {
        final restaurant =
            await _userRepository.getRestaurant(user.restaurantId);
        if (restaurant.menu == null) {
          yield NotMenu(restaurant);
        } else {
          yield AuthenticatedRestaurant(restaurant: restaurant);
        }
      }
    } catch (e) {
      yield Unauthenticated();
      await _userRepository.signOut();
      print('Authentication error: $e');
    }
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    _userRepository.signOut();
  }
}
