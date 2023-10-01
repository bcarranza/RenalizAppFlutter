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

      String? userName = authProvider.currentUser?.displayName;
      String? uid = authProvider.currentUser?.uid;
      if (uid != null) {
        _postTestResult(response1, uid);
      } else {
        _saveTestResult(response1);
      }
    }
  }

  // Nueva función para realizar la solicitud POST
  Future<void> _postTestResult(String testResultJson, String uid) async {
    final Uri uri = Uri.parse(dotenv.env['API_URL']! + 'postTestResults');  // Utiliza dotenv aquí

    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'uid': uid,  
        'testResult': jsonDecode(testResultJson),
      }),
    );

    if (response.statusCode == 200) {
      print('Test result posted successfully: ${response.body}');
    } else {
      print('Failed to post test result: ${response.statusCode}');
    }
}





  
  // Función para guardar el resultado del test en SharedPreferences
 Future<void> _saveTestResult(String testResultJson) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  // Obtén la lista existente de resultados de test
  List<String>? existingTestResults = prefs.getStringList('historyTests');
  
  // Si la lista existente es null (es decir, no hay resultados guardados previamente), inicialízala como una lista vacía
  if (existingTestResults == null) {
    existingTestResults = [];
  }
  
  // Agrega el nuevo resultado a la lista existente
  existingTestResults.add(testResultJson);
  
  // Guarda la lista actualizada de resultados de test
  await prefs.setStringList('historyTests', existingTestResults);
  
  // Imprime la lista actualizada de resultados de test
  print('Historial de tests guardados: $existingTestResults');
}
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Question>>(
      future: questionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Cargando...'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Error'),
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          final questions = snapshot.data!;

          if (questionIndex >= questions.length) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Cuestionario Completado'),
              ),
              body: Center(
                child: Text('Puntuación: $score'),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: Text('Cuestionario'),
            ),
            body: Column(
              children: [
                Text(
                  questions[questionIndex].question,
                  style: TextStyle(fontSize: 28),
                ),
                ...questions[questionIndex].answers.map<Widget>((answer) {
                  return questions[questionIndex].type == 'multiple'
                      ? CheckboxListTile(
                          title: Text(answer.text),
                          value: answer.isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              answer.isSelected = value!;
                            });
                          },
                        )
                      : RadioListTile<int>(
                          title: Text(answer.text),
                          value: answer.value,
                          groupValue: questions[questionIndex].answers.indexWhere((answer) => answer.isSelected),
                          onChanged: (int? value) {
                            setState(() {
                              for (var ans in questions[questionIndex].answers) {
                                ans.isSelected = ans.value == value;
                              }
                            });
                          },
                        );
                }).toList(),
                ElevatedButton(
                  onPressed: () => answerQuestion(questions),
                  child: Text('Siguiente'),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}