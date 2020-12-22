import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notes/blocs/auth/auth_bloc.dart';
import 'package:flutter_notes/models/models.dart';
import 'package:flutter_notes/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'note_detail_event.dart';
part 'note_detail_state.dart';

class NoteDetailBloc extends Bloc<NoteDetailEvent, NoteDetailState> {
  final AuthBloc _authBloc;
  final NotesRepository _notesRepository;

  NoteDetailBloc({AuthBloc authBloc, NotesRepository notesRepository})
      : _authBloc = authBloc,
        _notesRepository = notesRepository,
        super(NoteDetailState.empty());

  @override
  Stream<NoteDetailState> mapEventToState(
    NoteDetailEvent event,
  ) async* {
    if (event is NoteLoaded) {
      yield* _mapNoteLoadedToState(event);
    } else if (event is NoteContentUpdated) {
      yield* _mapNoteContentUpdatedToState(event);
    } else if (event is NoteColorUpdated) {
      yield* _mapNoteColorUpdatedToState(event);
    } else if (event is NoteAdded) {
      yield* _mapNoteAddedToState(event);
    } else if (event is NoteSaved) {
      yield* _mapNoteSavedToState();
    } else if (event is NoteDeleted) {
      yield* _mapNoteDeletedToState();
    }
  }

  String _getCurrentUSerId() {
    final AuthState authState = _authBloc.state;
    String currentSUerId;

    if (authState is Anonymous) {
      currentSUerId = authState.user.id;
    } else if (authState is Authtenticated) {
      currentSUerId = authState.user.id;
    }

    return currentSUerId;
  }

  Stream<NoteDetailState> _mapNoteLoadedToState(NoteLoaded event) async* {
    yield state.update(note: event.note);
  }

  Stream<NoteDetailState> _mapNoteContentUpdatedToState(
      NoteContentUpdated event) async* {
    if (state.note == null) {
      final String currentUSerId = _getCurrentUSerId();

      final Note note = Note(
          userId: currentUSerId,
          content: event.content,
          color: HexColor('#E74C3C'),
          timestamp: DateTime.now());
      yield state.update(note: note);
    } else {
      yield state.update(
          note: state.note
              .copy(content: event.content, timestamp: DateTime.now()));
    }
  }

  Stream<NoteDetailState> _mapNoteColorUpdatedToState(
      NoteColorUpdated event) async* {
    if (state.note == null) {
      final String currentUSerId = _getCurrentUSerId();

      final Note note = Note(
          userId: currentUSerId,
          content: '',
          color: event.color,
          timestamp: DateTime.now());
      yield state.update(note: note);
    } else {
      yield state.update(
          note: state.note.copy(color: event.color, timestamp: DateTime.now()));
    }
  }

  Stream<NoteDetailState> _mapNoteAddedToState(NoteAdded event) async* {
    yield NoteDetailState.submiting(note: state.note);

    try {
      await _notesRepository.addNote(note: state.note);
      yield NoteDetailState.success(note: state.note);

      event.completer.complete();
    } catch (err) {
      yield NoteDetailState.failure(
          note: state.note, errorMessage: 'Somethig went wrong!');
    }
  }

  Stream<NoteDetailState> _mapNoteSavedToState() async* {
    yield NoteDetailState.submiting(note: state.note);

    try {
      await _notesRepository.update(note: state.note);
    } catch (err) {
      yield NoteDetailState.failure(
          note: state.note, errorMessage: 'Somethig went wrong!');
    }
  }

  Stream<NoteDetailState> _mapNoteDeletedToState() async* {
    yield NoteDetailState.submiting(note: state.note);

    try {
      await _notesRepository.deleteNote(note: state.note);
    } catch (err) {
      yield NoteDetailState.failure(
          note: state.note, errorMessage: 'Somethig went wrong!');
    }
  }
}
