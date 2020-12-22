import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_notes/blocs/blocs.dart';

class ColorPicker extends StatelessWidget {
  final NoteDetailState state;
  final List<Color> colors;

  const ColorPicker({Key key, this.state, this.colors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: colors.map((color) {
          bool isSelected = state.note?.color == color;

          return GestureDetector(
            onTap: () =>
                context.read<NoteDetailBloc>().add(NoteColorUpdated(color)),
            child: Container(
              width: 30.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  border: isSelected
                      ? Border.all(color: Colors.black, width: 2.0)
                      : null),
            ),
          );
        }).toList(),
      ),
    );
  }
}
