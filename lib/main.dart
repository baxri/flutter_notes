import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes/blocs/blocs.dart';
import 'package:flutter_notes/repositories/repositories.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(create: (_) => ThemeBloc()..add(LoadTheme())),
        BlocProvider<AuthBloc>(
            create: (_) => AuthBloc(AuthRepository())..add(AppStarted())),
        BlocProvider<NotesBloc>(
            create: (_) => NotesBloc(AuthRepository(), NotesRepository())),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Flutter Firebase Bloc Notes',
            debugShowCheckedModeBanner: false,
            theme: state.themeData,
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}
