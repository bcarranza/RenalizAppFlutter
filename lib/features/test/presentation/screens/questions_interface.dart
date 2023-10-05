import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';  // Importa la biblioteca aquí
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:renalizapp/features/shared/infrastructure/provider/auth_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';



class Question {
  final String question;
  final String type;
  final List<Answer> answers;

  Question({
    required this.question,
    required this.type,
    required this.answers,
  });
}

class Answer {
  final int value;
  final String text;
  bool isSelected;

  Answer({
    required this.value,
    required this.text,
    this.isSelected = false,
  });
}

class Response {
  final String id = '';
  final double score;
  final List<Map<String, dynamic>> answeredQuestions;
  final String timestamp;

  Response({
    required this.score,
    required this.answeredQuestions,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'score': score,
      'answered_questions': answeredQuestions,
      'timestamp': timestamp,
    };
  }
}

void main() {
  final goRouter = GoRouter(
    routes: [],  // Define tus rutas aquí
  );
  runApp(MyApp(appRouter: goRouter));
}

class MyApp extends StatelessWidget {
  final GoRouter appRouter;

  MyApp({required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        ...GlobalMaterialLocalizations.delegates,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es', 'ES'),
      ],
      home: QuizzPage(appRouter: appRouter),
    );
  }
}

class QuizzPage extends StatefulWidget {
  final GoRouter appRouter;

  QuizzPage({required this.appRouter});

  @override
  _QuizzPageState createState() => _QuizzPageState();
}

class _QuizzPageState extends State<QuizzPage> {
  bool isZeroSelected = false;
  late Future<List<Question>> questionsFuture;
  int questionIndex = 0;
  double score = 0;
  List<Map<String, dynamic>> answeredQuestions = [];

  Future<List<Question>> fetchQuizJson() async {
    final Uri uri = Uri.parse(dotenv.env['API_URL']! + 'getTestById');  // Utiliza dotenv aquí

    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id': 'test2',
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> quizMap = json.decode(response.body) as Map<String, dynamic>;
      return quizMap.entries.map<Question>((entry) {
        final Map<String, dynamic> questionMap = entry.value as Map<String, dynamic>;
        final List<Answer> answers = (questionMap['options'] as List<dynamic>).map<Answer>((option) {
          final Map<String, dynamic> answerMap = option as Map<String, dynamic>;
          return Answer(
            value: answerMap['weight'] as int,
            text: answerMap['text'] as String,
          );
        }).toList();
        return Question(
          question: questionMap['questionText'] as String,
          type: questionMap['type'] as String,
          answers: answers,
        );
      }).toList();
    } else {
      throw Exception('Failed to load quiz');
    }
  }

  @override
  void initState() {
    super.initState();
    questionsFuture = fetchQuizJson();
  }

  

  void answerQuestion(List<Question> questions) {
    Map<String, dynamic> answeredQuestion = {
      'question': questions[questionIndex].question,
      'answers': questions[questionIndex].answers.map((answer) {
        return {
          'value': answer.value,
          'text': answer.text,
          'isSelected': answer.isSelected,
        };
      }).toList()
    };

    answeredQuestions.add(answeredQuestion);

    if (questions[questionIndex].type == 'multiple') {
      for (var answer in questions[questionIndex].answers) {
        if (answer.isSelected) {
          score += answer.value.toDouble();
        }
      }
    } else {
      final selectedAnswer = questions[questionIndex].answers.firstWhere((answer) => answer.isSelected, orElse: () => Answer(value: 0, text: ''));
      score += selectedAnswer.value.toDouble();
    }

    setState(() {
      questionIndex++;
    });

     if (questionIndex >= questions.length) {
     


      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
      final response = Response(score: score, answeredQuestions: answeredQuestions, timestamp: formattedDate);
      final testResultJson = response.toJson();
      String response1 = jsonEncode(testResultJson);
      final authProvider = context.read<AuthProvider>();  // Cambio aquí
      String riskMessage;
      String riskDescription;

      String? uid = authProvider.currentUser?.uid;

      if (uid != null) {

        if (score >= 0 && score <= 4) {
            riskMessage = "Buenas prácticas para la salud renal.";
            riskDescription = "Sigue cuidando tus riñones.";
          } else if (score >= 5 && score <= 10) {
            riskMessage = "Riesgo moderado.";
            riskDescription = "Considera hablar con un médico para una evaluación.";
          } else {
            riskMessage = "Riesgo alto.";
            riskDescription =
                "Se recomienda consultar a un médico para una evaluación y consejo médico.";
          }
        _postTestResult(response1, uid);
        _saveToHistory(riskMessage, riskDescription);
        showRedirectDialog(context,score,riskMessage, riskDescription);

      } 
      
      else {
          
          if (score >= 0 && score <= 4) {
            riskMessage = "Buenas prácticas para la salud renal.";
            riskDescription = "Sigue cuidando tus riñones.";
          } else if (score >= 5 && score <= 10) {
            riskMessage = "Riesgo moderado.";
            riskDescription = "Considera hablar con un médico para una evaluación.";
          } else {
            riskMessage = "Riesgo alto.";
            riskDescription =
                "Se recomienda consultar a un médico para una evaluación y consejo médico.";
          }


          _saveTestResult(response1);
          _saveToHistory(riskMessage, riskDescription);  // Llamada al nuevo método aquí
          showRedirectDialog(context,score,riskMessage, riskDescription);
      }
      
      
    }
  }

