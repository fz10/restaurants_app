import 'dart:convert';

import 'package:flutter/foundation.dart';

class Reservation {
  final String id;
  final String restId;
  final String restName;
  final String userId;
  final String userName;
  final String userEmail;
  final String date;
  final int tables;
  final String inTime;
  final String outTime;
  final Map<String, dynamic> order;
  final String state;
  final int priority;

  Reservation({
    this.id,
    this.restId,
    this.restName,
    this.userId,
    this.userName,
    this.userEmail,
    this.date,
    this.tables,
    this.inTime,
    this.outTime,
    this.order,
    this.state,
    this.priority,
  });

  Reservation copyWith({
    String id,
    String restId,
    String restName,
    String userId,
    String userName,
    String userEmail,
    String date,
    int tables,
    String inTime,
    String outTime,
    Map<String, dynamic> order,
    String state,
    int priority,
  }) {
    return Reservation(
      id: id ?? this.id,
      restId: restId ?? this.restId,
      restName: restName ?? this.restName,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      date: date ?? this.date,
      tables: tables ?? this.tables,
      inTime: inTime ?? this.inTime,
      outTime: outTime ?? this.outTime,
      order: order ?? this.order,
      state: state ?? this.state,
      priority: priority ?? this.priority,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'restId': restId,
      'restName': restName,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'date': date,
      'tables': tables,
      'inTime': inTime,
      'outTime': outTime,
      'order': order,
      'state': state,
      'priority': priority,
    };
  }

  factory Reservation.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Reservation(
      id: map['id'],
      restId: map['restId'],
      restName: map['restName'],
      userId: map['userId'],
      userName: map['userName'],
      userEmail: map['userEmail'],
      date: map['date'],
      tables: map['tables'],
      inTime: map['inTime'],
      outTime: map['outTime'],
      order: (map['order'] != null)
          ? Map<String, dynamic>.from(map['order'])
          : null,
      state: map['state'],
      priority: map['priority'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Reservation.fromJson(String source) =>
      Reservation.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Reservation(id: $id, restId: $restId, restName: $restName, userId: $userId, userName: $userName, userEmail: $userEmail, date: $date, tables: $tables, inTime: $inTime, outTime: $outTime, order: $order, state: $state, priority: $priority)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Reservation &&
        o.id == id &&
        o.restId == restId &&
        o.restName == restName &&
        o.userId == userId &&
        o.userName == userName &&
        o.userEmail == userEmail &&
        o.date == date &&
        o.tables == tables &&
        o.inTime == inTime &&
        o.outTime == outTime &&
        mapEquals(o.order, order) &&
        o.state == state &&
        o.priority == priority;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        restId.hashCode ^
        restName.hashCode ^
        userId.hashCode ^
        userName.hashCode ^
        userEmail.hashCode ^
        date.hashCode ^
        tables.hashCode ^
        inTime.hashCode ^
        outTime.hashCode ^
        order.hashCode ^
        state.hashCode ^
        priority.hashCode;
  }
}
