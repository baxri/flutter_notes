import 'package:flutter/material.dart';
import 'package:flutter_notes/models/models.dart';
import 'package:intl/intl.dart';

class NotesGrid extends StatelessWidget {
  final List<Note> notes;
  final Function(Note) onTap;

  const NotesGrid({Key key, this.notes, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
        padding: const EdgeInsets.only(
            left: 10.0, right: 10.0, bottom: 40.0, top: 10.0),
        sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate((_, index) {
            final Note note = notes[index];

            return GestureDetector(
              onTap: () => onTap(note),
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          note.content,
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      ),
                      Text(
                        DateFormat.yMd().add_jm().format(note.timestamp),
                        style: TextStyle(color: Colors.white, fontSize: 12.0),
                      )
                    ],
                  ),
                ),
                color: note.color,
              ),
            );
          }, childCount: notes.length),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200.0,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 0.8),
        ));
  }
}
