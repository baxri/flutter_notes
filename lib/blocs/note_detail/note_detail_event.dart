part of 'note_detail_bloc.dart';

abstract class NoteDetailEvent extends Equatable {
  const NoteDetailEvent();

  @override
  List<Object> get props => [];
}

class NoteLoaded extends NoteDetailEvent {
  final Note note;

  NoteLoaded(this.note);

  @override
  List<Object> get props => [note];
}

class NoteContentUpdated extends NoteDetailEvent {
  final String content;

  NoteContentUpdated(this.content);

  @override
  List<Object> get props => [content];
}

class NoteColorUpdated extends NoteDetailEvent {
  final Color color;

  NoteColorUpdated(this.color);

  @override
  List<Object> get props => [color];
}

class NoteAdded extends NoteDetailEvent {
  final Completer completer;

  NoteAdded(this.completer);

  @override
  List<Object> get props => [completer];
}

class NoteSaved extends NoteDetailEvent {}

class NoteDeleted extends NoteDetailEvent {}
