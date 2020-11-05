part of 'menu_register_bloc.dart';

abstract class MenuRegisterState extends Equatable {
  const MenuRegisterState();
  
  @override
  List<Object> get props => [];
}

class MenuRegisterInitial extends MenuRegisterState {}

class ItemSuccessfullyAdded extends MenuRegisterState{}

class LoadingData extends MenuRegisterState{}

class Failure extends MenuRegisterState{}

class Success extends MenuRegisterState{}



