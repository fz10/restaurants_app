import 'dart:convert';

class User {
  final String role;
  final String name;
  final String email;
  final String phone;
  User({
    this.role,
    this.name,
    this.email,
    this.phone,
  });

  User copyWith({
    String role,
    String name,
    String email,
    String phone,
  }) {
    return User(
      role: role ?? this.role,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'role': role,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return User(
      role: map['role'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(role: $role, name: $name, email: $email, phone: $phone)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is User &&
      o.role == role &&
      o.name == name &&
      o.email == email &&
      o.phone == phone;
  }

  @override
  int get hashCode {
    return role.hashCode ^
      name.hashCode ^
      email.hashCode ^
      phone.hashCode;
  }
  }
