import 'dart:convert';

class Client {
  final String id;
  final String restaurantId;
  final String role;
  final String name;
  final String last;
  final String email;
  final String phone;
  final DateTime regDate;

  Client({
    this.id,
    this.restaurantId,
    this.role,
    this.name,
    this.last,
    this.email,
    this.phone,
    this.regDate,
  });

  Client copyWith({
    String id,
    String restaurantId,
    String role,
    String name,
    String last,
    String email,
    String phone,
    DateTime regDate,
  }) {
    return Client(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      role: role ?? this.role,
      name: name ?? this.name,
      last: last ?? this.last,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      regDate: regDate ?? this.regDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'role': role,
      'name': name,
      'last': last,
      'email': email,
      'phone': phone,
      'regDate': regDate?.millisecondsSinceEpoch,
    };
  }

  factory Client.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Client(
      id: map['id'],
      restaurantId: map['restaurantId'],
      role: map['role'],
      name: map['name'],
      last: map['last'],
      email: map['email'],
      phone: map['phone'],
      regDate: DateTime.fromMillisecondsSinceEpoch(map['regDate']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Client.fromJson(String source) => Client.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Client(id: $id, restaurantId: $restaurantId, role: $role, name: $name, last: $last, email: $email, phone: $phone, regDate: $regDate)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Client &&
        o.id == id &&
        o.restaurantId == restaurantId &&
        o.role == role &&
        o.name == name &&
        o.last == last &&
        o.email == email &&
        o.phone == phone &&
        o.regDate == regDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        restaurantId.hashCode ^
        role.hashCode ^
        name.hashCode ^
        last.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        regDate.hashCode;
  }
}
