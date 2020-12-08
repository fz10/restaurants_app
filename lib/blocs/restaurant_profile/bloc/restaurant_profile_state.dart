part of 'restaurant_profile_bloc.dart';

abstract class RestaurantProfileState extends Equatable {
  const RestaurantProfileState();

  @override
  List<Object> get props => [];
}

class RestaurantProfileInitial extends RestaurantProfileState {}

class ShowEditScreen extends RestaurantProfileState {
  final Restaurant restaurant;

  ShowEditScreen({@required this.restaurant});

  @override
  String toString() => 'ShowEditScreen';
}

class Success extends RestaurantProfileState {
  final Restaurant restaurant;

  Success({@required this.restaurant});

  @override
  String toString() => 'Success';
}

class Failure extends RestaurantProfileState {
  final String message;

  Failure({@required this.message});

  @override
  String toString() => 'Failure';
}

class LoadingChanges extends RestaurantProfileState {}
