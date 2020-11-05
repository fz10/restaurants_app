part of 'client_search_bloc.dart';

abstract class ClientSearchEvent extends Equatable {
  const ClientSearchEvent();

  @override
  List<Object> get props => [];
}

class SearchSubmitted extends ClientSearchEvent {
  final String queryText;

  SearchSubmitted({@required this.queryText});

  @override
  String toString() => 'Submitted';
}

