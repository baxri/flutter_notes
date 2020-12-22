import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:flutter_notes/entities/entities.dart';

class User extends Equatable {
  final String id;
  final String email;

  User({this.id, @required this.email});

  factory User.fromEntity(UserEntity userEntity) {
    return User(id: userEntity.id, email: userEntity.email);
  }

  @override
  List<Object> get props => [id, email];

  UserEntity toEntity() {
    return UserEntity(id: id, email: email);
  }
}
