import 'package:flutter/material.dart';
import 'package:flutter_moor_db/Screen/note_list_screen.dart';
import 'package:flutter_moor_db/database/database.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => AppDatabase(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          textTheme: const TextTheme(
              headlineSmall: TextStyle(
                  fontFamily: 'EB Garamond',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 24),
              bodyMedium: TextStyle(
                  fontFamily: 'EB Garamond',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20),
              bodyLarge: TextStyle(
                  fontFamily: 'EB Garamond',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18),
              titleSmall: TextStyle(
                  fontFamily: 'EB Garamond',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 14)),
        ),
        home: NoteList(),
      ),
    );
  }
}
