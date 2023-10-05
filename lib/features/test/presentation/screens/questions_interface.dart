import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importa la biblioteca aquí
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
    routes: [], // Define tus rutas aquí
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
    final Uri uri = Uri.parse(
        dotenv.env['API_URL']! + 'getTestById'); // Utiliza dotenv aquí

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
      final Map<String, dynamic> quizMap =
          json.decode(response.body) as Map<String, dynamic>;
      return quizMap.entries.map<Question>((entry) {
        final Map<String, dynamic> questionMap =
            entry.value as Map<String, dynamic>;
        final List<Answer> answers =
            (questionMap['options'] as List<dynamic>).map<Answer>((option) {
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
      final selectedAnswer = questions[questionIndex].answers.firstWhere(
          (answer) => answer.isSelected,
          orElse: () => Answer(value: 0, text: ''));
      score += selectedAnswer.value.toDouble();
    }

    setState(() {
      questionIndex++;
    });

    if (questionIndex >= questions.length) {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
      final response = Response(
          score: score,
          answeredQuestions: answeredQuestions,
          timestamp: formattedDate);
      final testResultJson = response.toJson();
      String response1 = jsonEncode(testResultJson);
      final authProvider = context.read<AuthProvider>(); // Cambio aquí
      String riskMessage;
      String riskDescription;

      String? userName = authProvider.currentUser?.displayName;
      String? uid = authProvider.currentUser?.uid;

      if (uid != null) {
        if (score >= 0 && score <= 4) {
          riskMessage = "Buenas prácticas para la salud renal.";
          riskDescription = "Sigue cuidando tus riñones.";
        } else if (score >= 5 && score <= 10) {
          riskMessage = "Riesgo moderado.";
          riskDescription =
              "Considera hablar con un médico para una evaluación.";
        } else {
          riskMessage = "Riesgo alto.";
          riskDescription =
              "Se recomienda consultar a un médico para una evaluación y consejo médico.";
        }
        _postTestResult(response1, uid);
        _saveToHistory(riskMessage, riskDescription);
        showRedirectDialog(context, score, riskMessage, riskDescription);
      } else {
        if (score >= 0 && score <= 4) {
          riskMessage = "Buenas prácticas para la salud renal.";
          riskDescription = "Sigue cuidando tus riñones.";
        } else if (score >= 5 && score <= 10) {
          riskMessage = "Riesgo moderado.";
          riskDescription =
              "Considera hablar con un médico para una evaluación.";
        } else {
          riskMessage = "Riesgo alto.";
          riskDescription =
              "Se recomienda consultar a un médico para una evaluación y consejo médico.";
        }

        _saveTestResult(response1);
        _saveToHistory(
            riskMessage, riskDescription); // Llamada al nuevo método aquí
        showRedirectDialog(context, score, riskMessage, riskDescription);
      }
    }
  }

  void navigateToLogin(BuildContext context) {
    final goRouter = GoRouter.of(context);
    goRouter.go('/test');
  }

  Future<void> showRedirectDialog(BuildContext context, double puntuacion,
      String mensaje, String descripcion) {
    String score = puntuacion.toString();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button to close dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Puntuación: ' + score),
          content: Column(
            mainAxisSize:
                MainAxisSize.min, // para tomar el espacio mínimo necesario
            children: [
              Text(
                mensaje,
                style: TextStyle(
                  fontSize: 18.0, // tamaño de la fuente
                  fontFamily: 'Roboto', // fuente
                  // y otros estilos que desees
                ),
              ),
              SizedBox(height: 20), // espacio entre los mensajes
              Text(
                descripcion,
                style: TextStyle(
                  fontSize: 18.0, // tamaño de la fuente
                  fontFamily: 'Roboto', // fuente
                  // y otros estilos que desees
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Redirigir'),
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
                navigateToLogin(context); // Navegar al login
              },
            ),
          ],
        );
      },
    );
  }

  // Nueva función para realizar la solicitud POST
  Future<void> _postTestResult(String testResultJson, String uid) async {
    final Uri uri = Uri.parse(
        dotenv.env['API_URL']! + 'postTestResults'); // Utiliza dotenv aquí

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

  Future<void> _saveToHistory(
      String riskMessage, String riskDescription) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

    String newResult = "$score;$riskMessage;$riskDescription;$formattedDate";

    List<String>? existingResults = prefs.getStringList('history');

    if (existingResults == null) {
      existingResults = [newResult];
    } else {
      existingResults.add(newResult);
    }

    await prefs.setStringList('history', existingResults);
    //print('Historial de tests para USUARIO: $existingResults');
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
    // print('Historial de tests guardados: $existingTestResults');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double maxWidth = 1200.0;

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

          var isAnswerSelected = questions[questionIndex]
              .answers
              .any((answer) => answer.isSelected);

          return Scaffold(
            appBar: AppBar(
              title: Text('Cuestionario'),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // Navega a la ruta específica
                  context.go(
                      "/test"); // Reemplaza '/ruta_especifica' con la ruta que desees.
                },
              ),
            ),
            body: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: size.width,
                        padding: EdgeInsets.all(16.0),
                        margin: EdgeInsets.only(bottom: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          questions[questionIndex].question,
                          style: TextStyle(fontSize: 28, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ...questions[questionIndex].answers.map<Widget>((answer) {
                        return questions[questionIndex].type == 'multiple'
                            ? CheckboxListTile(
                                title: Text(answer.text),
                                value: answer.isSelected,
                                onChanged: (answer.value == 0 ||
                                        !isZeroSelected)
                                    ? (bool? value) {
                                        setState(() {
                                          answer.isSelected = value!;
                                          if (answer.value == 0) {
                                            isZeroSelected = value;
                                          }
                                          for (var otherAnswer
                                              in questions[questionIndex]
                                                  .answers) {
                                            if (otherAnswer.value != 0) {
                                              if (isZeroSelected) {
                                                otherAnswer.isSelected = false;
                                              }
                                            }
                                          }
                                        });
                                      }
                                    : null,
                              )
                            : RadioListTile<int>(
                                title: Text(answer.text),
                                value: answer.value,
                                groupValue: questions[questionIndex]
                                    .answers
                                    .indexWhere((answer) => answer.isSelected),
                                onChanged: (int? value) {
                                  setState(() {
                                    for (var ans
                                        in questions[questionIndex].answers) {
                                      ans.isSelected = ans.value == value;
                                    }
                                  });
                                },
                              );
                      }).toList(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isAnswerSelected
                              ? () => answerQuestion(questions)
                              : null,
                          child: Text('Siguiente'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
