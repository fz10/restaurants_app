import 'dart:convert';

import 'package:flutter/foundation.dart';

class Restaurant {
  final String name;
  final String adminId;
  final String cuisine;
  final String phone;
  final String address;
  final DateTime open;
  final DateTime close;
  final Map<String, dynamic> tables;
  final Map<String, dynamic> menu;

  
  Restaurant({
    this.name,
    this.adminId,
    this.cuisine,
    this.phone,
    this.address,
    this.open,
    this.close,
    this.tables,
    this.menu,
  });


  Restaurant copyWith({
    String name,
    String adminId,
    String cuisine,
    String phone,
    String address,
    DateTime open,
    DateTime close,
    Map<String, dynamic> tables,
    Map<String, dynamic> menu,
  }) {
    return Restaurant(
      name: name ?? this.name,
      adminId: adminId ?? this.adminId,
      cuisine: cuisine ?? this.cuisine,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      open: open ?? this.open,
      close: close ?? this.close,
      tables: tables ?? this.tables,
      menu: menu ?? this.menu,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'adminId': adminId,
      'cuisine': cuisine,
      'phone': phone,
      'address': address,
      'open': open?.millisecondsSinceEpoch,
      'close': close?.millisecondsSinceEpoch,
      'tables': tables,
      'menu': menu,
    };
  }

  factory Restaurant.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Restaurant(
      name: map['name'],
      adminId: map['adminId'],
      cuisine: map['cuisine'],
      phone: map['phone'],
      address: map['address'],
      open: DateTime.fromMillisecondsSinceEpoch(map['open']),
      close: DateTime.fromMillisecondsSinceEpoch(map['close']),
      tables: Map<String, dynamic>.from(map['tables']),
      menu: Map<String, dynamic>.from(map['menu']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Restaurant.fromJson(String source) => Restaurant.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Restaurant(name: $name, adminId: $adminId, cuisine: $cuisine, phone: $phone, address: $address, open: $open, close: $close, tables: $tables, menu: $menu)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Restaurant &&
      o.name == name &&
      o.adminId == adminId &&
      o.cuisine == cuisine &&
      o.phone == phone &&
      o.address == address &&
      o.open == open &&
      o.close == close &&
      mapEquals(o.tables, tables) &&
      mapEquals(o.menu, menu);
  }

  @override
  int get hashCode {
    return name.hashCode ^
      adminId.hashCode ^
      cuisine.hashCode ^
      phone.hashCode ^
      address.hashCode ^
      open.hashCode ^
      close.hashCode ^
      tables.hashCode ^
      menu.hashCode;
  }
}
