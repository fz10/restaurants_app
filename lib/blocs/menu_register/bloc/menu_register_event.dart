part of 'menu_register_bloc.dart';

abstract class MenuRegisterEvent extends Equatable {
  const MenuRegisterEvent();

  @override
  List<Object> get props => [];
}

class ItemAdded extends MenuRegisterEvent {
  final String type;
  final String name;
  final String price;

  ItemAdded({@required this.type, @required this.name, @required this.price});

  @override
  String toString() => 'Item Added';
}

class Submitted extends MenuRegisterEvent {}
