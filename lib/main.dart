//chat gpt api key:
//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
import 'package:flutter/material.dart';
import 'questions_page.dart';
import 'login.dart';
import 'about_us.dart';
import 'results_page.dart';
import 'package:shared_preferences/shared_preferences.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ethical App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0x008296bd)),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(title: 'Login Page'),
        '/askQuestions': (context) => const QuestionsPage(title: 'Ask Questions!'),
        '/aboutUs': (context) => const AboutUsPage(),
        '/resultsPage': (context) => const ResultsPage(),
      },
     // home: const LoginPage(title: 'Login Page',)//const QuestionsPage(title: 'Ask Questions!',),
    );
  }
}
