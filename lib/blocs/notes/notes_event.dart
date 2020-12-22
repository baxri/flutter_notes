part of 'notes_bloc.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}

class FetchNotes extends NotesEvent {}

class UpdateNotes extends NotesEvent {
  final List<Note> notes;

  UpdateNotes({this.notes});

  @override
  List<Object> get props => [notes];
}
