import 'package:flutter/material.dart';
import 'package:meditivitytest2/page1/mindfulness_page.dart';
import 'package:meditivitytest2/style.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meditivity test task',
      theme: _theme(),
      home: MindfulnessPage(),
    );
  }
}

ThemeData _theme(){
  return ThemeData(
    appBarTheme: AppBarTheme(
      color: Colors.grey[50],

      textTheme: TextTheme(title: AppBarTextStyle),

    ),
    textTheme: TextTheme(
      title: TitleTextStyle,
      body1: TabBarTextStyle,
      subtitle: SubtitleTextStyle,
      button: ButtonTextStyle,
      headline: AppBarTextStyle,
      subhead: InfoTextStyle,
      display2: Heading1TextStyle,

    ),
  );
}