part of 'note_detail_bloc.dart';

@immutable
class NoteDetailState {
  final Note note;
  final bool isSubmiting;
  final bool isSuccess;
  final bool isFailure;
  final String errorMessage;

  NoteDetailState(
      {@required this.note,
      @required this.isSubmiting,
      @required this.isSuccess,
      @required this.isFailure,
      @required this.errorMessage});

  factory NoteDetailState.empty() {
    return NoteDetailState(
        note: null,
        isSubmiting: false,
        isSuccess: false,
        isFailure: false,
        errorMessage: '');
  }
  factory NoteDetailState.submiting({@required Note note}) {
    return NoteDetailState(
        note: note,
        isSubmiting: true,
        isSuccess: false,
        isFailure: false,
        errorMessage: '');
  }

  factory NoteDetailState.success({@required Note note}) {
    return NoteDetailState(
        note: note,
        isSubmiting: false,
        isSuccess: true,
        isFailure: false,
        errorMessage: '');
  }

  factory NoteDetailState.failure(
      {@required Note note, @required errorMessage}) {
    return NoteDetailState(
        note: note,
        isSubmiting: false,
        isSuccess: false,
        isFailure: true,
        errorMessage: errorMessage);
  }

  NoteDetailState update(
      {Note note,
      bool isSubmiting,
      bool isSuccess,
      bool isFailure,
      String errorMessage}) {
    return copyWith(
        note: note,
        isSubmiting: isSubmiting,
        isSuccess: isSuccess,
        isFailure: isFailure,
        errorMessage: errorMessage);
  }

  NoteDetailState copyWith(
      {Note note,
      bool isSubmiting,
      bool isSuccess,
      bool isFailure,
      String errorMessage}) {
    return NoteDetailState(
        note: note ?? this.note,
        isSubmiting: isSubmiting ?? this.isSubmiting,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure,
        errorMessage: errorMessage ?? this.errorMessage);
  }
}
