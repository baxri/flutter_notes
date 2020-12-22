import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_notes/models/models.dart';
import 'package:flutter_notes/entities/entities.dart';
import 'package:flutter_notes/repositories/repositories.dart';

class NotesRepository extends BaseNotesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Note> addNote({Note note}) async {
    await _firestore.collection('notes').add(note.toEntity().toDocument());
    return note;
  }

  @override
  Future<Note> deleteNote({Note note}) async {
    await _firestore.collection('notes').doc(note.id).delete();
    return note;
  }

  @override
  Stream<List<Note>> streamNotes({String userId}) {
    return _firestore
        .collection('notes')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Note.fromEntity(NoteEntity.fromSnapshot(doc)))
            .toList()
              ..sort((a, b) {
                return b.timestamp.compareTo(a.timestamp);
              }));
  }

  @override
  Future<Note> update({Note note}) async {
    await _firestore
        .collection('notes')
        .doc(note.id)
        .update(note.toEntity().toDocument());
    return note;
  }

  @override
  void dispose() {}
}
