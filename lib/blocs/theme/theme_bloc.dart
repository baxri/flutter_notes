import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/themes.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String sharedTheme = 'sharedTheme';

  ThemeBloc()
      : super(ThemeState(themeData: Themes.themeData[AppTheme.DarkTheme]));

  @override
  Stream<ThemeState> mapEventToState(
    ThemeEvent event,
  ) async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (event is LoadTheme) {
      yield* _mapLoadThemeToState(prefs);
    } else if (event is UpdateTheme) {
      yield* _mapUpdateThemeToState(prefs);
    }
  }

  Stream<ThemeState> _mapLoadThemeToState(SharedPreferences prefs) async* {
    yield* _mapSetTheme(prefs, prefs.getBool(sharedTheme) ?? false);
  }

  Stream<ThemeState> _mapUpdateThemeToState(SharedPreferences prefs) async* {
    yield* _mapSetTheme(prefs, !prefs.getBool(sharedTheme) ?? false);
  }

  Stream<ThemeState> _mapSetTheme(
      SharedPreferences prefs, bool isDarkMode) async* {
    prefs.setBool(sharedTheme, isDarkMode);
    yield ThemeState(
        themeData: Themes
            .themeData[isDarkMode ? AppTheme.DarkTheme : AppTheme.LightTheme]);
  }
}
