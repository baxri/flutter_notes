import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notes/entities/entities.dart';

class Note extends Equatable {
  final String id;
  final String userId;
  final String content;
  final Color color;
  final DateTime timestamp;

  Note({this.id, this.userId, this.content, this.color, this.timestamp});

  factory Note.fromEntity(NoteEntity noteEntity) {
    return Note(
      id: noteEntity.id,
      userId: noteEntity.userId,
      content: noteEntity.content,
      color: HexColor(noteEntity.color),
      timestamp: noteEntity.timestamp.toDate(),
    );
  }

  @override
  List<Object> get props => [id, userId, content, color, timestamp];

  NoteEntity toEntity() {
    return NoteEntity(
        id: id,
        userId: userId,
        content: content,
        color: '#${color.value.toRadixString(16)}',
        timestamp: Timestamp.fromDate(timestamp));
  }

  Note copy(
      {String id,
      String userId,
      String content,
      Color color,
      DateTime timestamp}) {
    return Note(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        content: content ?? this.content,
        color: color ?? this.color,
        timestamp: timestamp ?? this.timestamp);
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');

    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }

    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
