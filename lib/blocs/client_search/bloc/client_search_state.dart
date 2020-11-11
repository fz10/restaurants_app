part of 'client_search_bloc.dart';

abstract class ClientSearchState extends Equatable {
  const ClientSearchState();

  @override
  List<Object> get props => [];
}

class ClientSearchInitial extends ClientSearchState {}


class LoadingData extends ClientSearchState {}

class Failure extends ClientSearchState {
  final String message;

  Failure({@required this.message});

  @override
  String toString() => 'Failure';
}

class NoResults extends ClientSearchState {
  final String message;

  NoResults({@required this.message});
  
  @override
  String toString() => 'NoResults';
}

class Success extends ClientSearchState {
  final List<Restaurant> restaurantList;

  Success({@required this.restaurantList});

  @override
  String toString() => 'Success';
}
