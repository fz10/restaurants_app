part of 'restaurant_profile_bloc.dart';

abstract class RestaurantProfileEvent extends Equatable {
  const RestaurantProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadScreenData extends RestaurantProfileEvent {
  final String restId;

  LoadScreenData({@required this.restId});
}

class EditProfile extends RestaurantProfileEvent {}

class ApplyChanges extends RestaurantProfileEvent {
  final String restId;

  ApplyChanges({@required this.restId});
}

class CancelChanges extends RestaurantProfileEvent {
  final String restId;

  CancelChanges({@required this.restId});
}

class UpdateFields extends RestaurantProfileEvent {
  final String name;
  final String cuisine;
  final String phone;
  final String address;
  final int tables;
  final String from;
  final String until;

  UpdateFields(
      {@required this.name,
      @required this.cuisine,
      @required this.phone,
      @required this.address,
      @required this.tables,
      @required this.from,
      @required this.until});
}

class UpdateItem extends RestaurantProfileEvent {
  final String type;
  final String name;
  final double price;

  UpdateItem({
    @required this.type,
    @required this.name,
    @required this.price,
  });
}

class AddItem extends RestaurantProfileEvent {
  final String type;
  final String name;
  final double price;

  AddItem({
    @required this.type,
    @required this.name,
    @required this.price,
  });
}

class DeleteItem extends RestaurantProfileEvent {
  final String type;
  final String name;

  DeleteItem({@required this.type, @required this.name});
}
