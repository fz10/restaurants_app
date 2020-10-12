import 'dart:convert';

class User {
  final String role;
  final String name;
  final String last;
  final String email;
  final String phone;
  final DateTime regDate;
  User({
    this.role,
    this.name,
    this.last,
    this.email,
    this.phone,
    this.regDate,
  });

  User copyWith({
    String role,
    String name,
    String last,
    String email,
    String phone,
    DateTime regDate,
  }) {
    return User(
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
      'role': role,
      'name': name,
      'last': last,
      'email': email,
      'phone': phone,
      'regDate': regDate?.millisecondsSinceEpoch,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return User(
      role: map['role'],
      name: map['name'],
      last: map['last'],
      email: map['email'],
      phone: map['phone'],
      regDate: DateTime.fromMillisecondsSinceEpoch(map['regDate']),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(role: $role, name: $name, last: $last, email: $email, phone: $phone, regDate: $regDate)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is User &&
      o.role == role &&
      o.name == name &&
      o.last == last &&
      o.email == email &&
      o.phone == phone &&
      o.regDate == regDate;
  }

  @override
  int get hashCode {
    return role.hashCode ^
      name.hashCode ^
      last.hashCode ^
      email.hashCode ^
      phone.hashCode ^
      regDate.hashCode;
  }
}
