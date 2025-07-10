import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:expense_tracker/widgets/expenses.dart';

var kColorScheme = ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 155, 217, 255));
var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 5, 99, 125));

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //  DeviceOrientation.portraitUp,
  //]).then((fn) {
      runApp(
    MaterialApp(
      // dark mode theme settings
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
        cardTheme: const CardThemeData().copyWith(
          color: kDarkColorScheme.secondaryContainer,
          margin: const EdgeInsets.all(10)
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorScheme.primaryContainer,
            foregroundColor: kDarkColorScheme.onPrimaryContainer,
          )
        ),
      ),
      // light mode theme settings
      theme: ThemeData().copyWith(
        // adds shades of color scheme through app
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.onPrimaryContainer,
          foregroundColor: kColorScheme.primaryContainer,
        ),
        cardTheme: const CardThemeData().copyWith(
          color: kColorScheme.secondaryContainer,
          margin: const EdgeInsets.all(10)
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.primaryContainer,
          )
        ),
        textTheme: ThemeData().textTheme.copyWith(
          titleLarge: TextStyle(fontWeight: FontWeight.bold,
          color: kColorScheme.onSecondaryContainer,
          fontSize: 20)
        )
      ),
      home: Expenses(),
    ),
  );
  //});
  
}