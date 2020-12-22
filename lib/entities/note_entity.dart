import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class NoteEntity extends Equatable {
  final String id;
  final String userId;
  final String content;
  final String color;
  final Timestamp timestamp;

  NoteEntity({this.id, this.userId, this.content, this.color, this.timestamp});

  factory NoteEntity.fromSnapshot(DocumentSnapshot doc) {
    return NoteEntity(
        id: doc.id,
        userId: doc.get('userId') ?? '',
        content: doc.get('content') ?? '',
        color: doc.get('color') ?? '#FFFFFF',
        timestamp: doc.get('timestamp'));
  }

  @override
  List<Object> get props => [id, userId, content, color, timestamp];

  Map<String, dynamic> toDocument() {
    return {
      'userId': userId,
      'content': content,
      'color': color,
      'timestamp': timestamp,
    };
  }
}
