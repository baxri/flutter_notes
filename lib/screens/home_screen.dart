import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes/blocs/blocs.dart';
import 'package:flutter_notes/config/themes.dart';
import 'package:flutter_notes/repositories/notes/notes_repository.dart';
import 'package:flutter_notes/screens/screens.dart';
import 'package:flutter_notes/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        context.read<NotesBloc>().add(FetchNotes());
      },
      builder: (context, authState) {
        return BlocBuilder<NotesBloc, NotesState>(
          builder: (context, notesState) {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                child: const Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return BlocProvider<NoteDetailBloc>(
                        create: (_) {
                          return NoteDetailBloc(
                              authBloc: context.read<AuthBloc>(),
                              notesRepository: NotesRepository());
                        },
                        child: NoteDetailScreen());
                  }));
                },
              ),
              body: _buildBody(context, authState, notesState),
            );
          },
        );
      },
    );
  }

  Stack _buildBody(
      BuildContext context, AuthState authState, NotesState notesState) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Your Notes'),
              ),
              leading: IconButton(
                  icon: authState is Authtenticated
                      ? Icon(Icons.exit_to_app)
                      : Icon(Icons.account_circle),
                  iconSize: 28.0,
                  onPressed: () => authState is Authtenticated
                      ? context.read<AuthBloc>().add(LogOut())
                      : print('Go to login screen!')),
              actions: [
                _buildThemeIconButton(context),
              ],
            ),
            notesState is NotesLoaded
                ? NotesGrid(
                    notes: notesState.notes,
                    onTap: (note) {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return BlocProvider<NoteDetailBloc>(
                            create: (_) {
                              return NoteDetailBloc(
                                  authBloc: context.read<AuthBloc>(),
                                  notesRepository: NotesRepository())
                                ..add(NoteLoaded(note));
                            },
                            child: NoteDetailScreen(
                              note: note,
                            ));
                      }));
                    },
                  )
                : const SliverPadding(padding: const EdgeInsets.all(0.0)),
          ],
        ),
        notesState is NotesLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : const SizedBox.shrink(),
        notesState is NotesError
            ? Center(
                child: Text(
                  'Something wen wrong!',
                  textAlign: TextAlign.center,
                ),
              )
            : const SizedBox.shrink()
      ],
    );
  }

  Widget _buildThemeIconButton(BuildContext context) {
    return BlocConsumer<ThemeBloc, ThemeState>(
        builder: (context, state) {
          final isLightTheme =
              state.themeData == Themes.themeData[AppTheme.LightTheme];

          return IconButton(
              icon: !isLightTheme
                  ? Icon(Icons.brightness_4)
                  : Icon(Icons.brightness_5),
              onPressed: () {
                context.read<ThemeBloc>().add(UpdateTheme());
              });
        },
        listener: (contect, state) {});
  }
}
