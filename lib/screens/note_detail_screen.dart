import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_notes/blocs/blocs.dart';
import 'package:flutter_notes/models/models.dart';
import 'package:flutter_notes/widgets/widgets.dart';

class NoteDetailScreen extends StatefulWidget {
  final Note note;

  const NoteDetailScreen({Key key, this.note}) : super(key: key);

  @override
  _NoteDetailScreenState createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  final TextEditingController _contentController = TextEditingController();

  final List<HexColor> _colors = [
    HexColor('#E74C3C'),
    HexColor('#3498DB'),
    HexColor('#27AE60'),
    HexColor('#F6C924'),
    HexColor('#8E44AD'),
  ];

  bool get isEditing => widget.note != null;

  @override
  void initState() {
    if (isEditing) {
      _contentController.text = widget.note.content;
    }

    super.initState();
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (isEditing) {
          context.read<NoteDetailBloc>().add(NoteSaved());
        }

        return Future.value(true);
      },
      child: BlocConsumer<NoteDetailBloc, NoteDetailState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              actions: [_buildAction()],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.only(
                  left: 24.0, right: 24.0, top: 10.0, bottom: 80.0),
              child: TextField(
                controller: _contentController,
                style: TextStyle(fontSize: 18.0, height: 1.2),
                decoration: InputDecoration.collapsed(
                    hintText: 'Write about anything!'),
                maxLines: null,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (value) {
                  context.read<NoteDetailBloc>().add(NoteContentUpdated(value));
                },
              ),
            ),
            bottomSheet: ColorPicker(
              state: state,
              colors: _colors,
            ),
          );
        },
      ),
    );
  }

  Future<void> addNote() {
    final completer = new Completer<void>();
    context.read<NoteDetailBloc>().add(NoteAdded(completer));
    return completer.future;
  }

  FlatButton _buildAction() {
    return isEditing
        ? FlatButton(
            onPressed: () {
              context.read<NoteDetailBloc>().add(NoteDeleted());
              Navigator.of(context).pop();
            },
            child: Text(
              'Delete',
              style: TextStyle(
                fontSize: 17.0,
                color: Colors.red,
              ),
            ))
        : FlatButton(
            onPressed: () async {
              await addNote();
              Navigator.of(context).pop();
            },
            child: Text(
              'Add Note',
              style: TextStyle(
                fontSize: 17.0,
                color: Colors.green,
              ),
            ));
  }
}
