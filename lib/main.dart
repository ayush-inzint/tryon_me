import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/main_screen.dart';
import 'screens/results_screen.dart';
import 'utils/routes.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FASHN Virtual Try-On',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Routes.mainScreen,
      routes: {
        Routes.mainScreen: (context) => MainScreen(),
        Routes.resultsScreen: (context) {
          final args = ModalRoute.of(context)!.settings.arguments as String;
          return ResultsScreen(outputImageUrl: args);
        },
      },
    );
  }
}
