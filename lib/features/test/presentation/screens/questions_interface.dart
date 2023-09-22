import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:renalizapp/features/test/presentation/screens/history_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Question {
  final String question;
  final List<Answer> answers;

  Question({
    required this.question,
    required this.answers,
  });
}

class Answer {
  final int value;
  final String text;

  Answer({
    required this.value,
    required this.text,
  });
}

class QuizzPage extends StatefulWidget {
  final GoRouter appRouter; // Agrega una propiedad para almacenar el enrutador

  QuizzPage({required this.appRouter});
  @override
  _QuizzPageState createState() => _QuizzPageState();
}

List<String> testHistory = [];

class _QuizzPageState extends State<QuizzPage> {
  Map<int, int> _answersMap =
      {}; // Almacena las respuestas seleccionadas por pregunta
  List<Question> questions = [
    Question(
      question:
          "¿Cuántas veces a la semana te ejercitas durante al menos 30 minutos?",
      answers: [
        Answer(value: 0, text: "Más de 3 veces"),
        Answer(value: 1, text: "1-3 veces"),
        Answer(value: 2, text: "Menos de 1 vez"),
        Answer(value: 3, text: "No hago ejercicio"),
      ],
    ),
    Question(
      question: "¿Cómo describirías tu dieta en general?",
      answers: [
        Answer(value: 0, text: "Saludable y balanceada"),
        Answer(
            value: 1,
            text:
                "Mayormente saludable pero ocasionalmente consumo alimentos poco saludables"),
        Answer(
            value: 2,
            text: "Poco saludable con alimentos procesados y altos en sal"),
        Answer(value: 3, text: "Muy poco saludable"),
      ],
    ),
    Question(
      question:
          "¿Te has realizado pruebas de nivel de azúcar en sangre en los últimos 2 años?",
      answers: [
        Answer(value: 0, text: "Sí"),
        Answer(
            value: 1,
            text: "No, pero no tengo factores de riesgo para diabetes"),
        Answer(value: 2, text: "No, y tengo factores de riesgo para diabetes"),
      ],
    ),
    Question(
      question: "¿Has revisado tu presión arterial en el último año?",
      answers: [
        Answer(value: 0, text: "Sí, está dentro del rango normal"),
        Answer(
            value: 1, text: "Sí, está ligeramente elevada pero bajo control"),
        Answer(value: 2, text: "No, pero no tengo factores de riesgo"),
        Answer(value: 3, text: "No, y tengo factores de riesgo"),
      ],
    ),
    Question(
      question:
          "¿Cuántos vasos de agua u otras bebidas consumes en un día promedio?",
      answers: [
        Answer(value: 0, text: "8 vasos o más"),
        Answer(value: 1, text: "4-7 vasos"),
        Answer(value: 2, text: "Menos de 4 vasos"),
      ],
    ),
    Question(
      question: "¿Eres fumador/a?",
      answers: [
        Answer(value: 0, text: "No"),
        Answer(value: 3, text: "Sí"),
      ],
    ),
    Question(
      question:
          "¿Con qué frecuencia tomas medicamentos antiinflamatorios sin esteroides (NSAIDs) o pastillas para el dolor?",
      answers: [
        Answer(value: 0, text: "Nunca o raramente"),
        Answer(value: 1, text: "Ocasionalmente"),
        Answer(value: 2, text: "Frecuentemente"),
      ],
    ),
    Question(
      question: "¿Tienes uno o más de los siguientes factores de alto riesgo?",
      answers: [
        Answer(value: 1, text: "Diabetes"),
        Answer(value: 1, text: "Hipertensión"),
        Answer(value: 1, text: "Obesidad"),
        Answer(value: 1, text: "Historial familiar de enfermedad renal"),
        Answer(value: 0, text: "Ninguno de los anteriores"),
      ],
    ),
  ];

  int _currentQuestionIndex = 0;
  int _score = 0;

  @override
  void initState() {
    super.initState();

    // Retrasa la visualización del diálogo de instrucciones.
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Instrucciones"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Responde a cada pregunta seleccionando la opción que mejor se aplique a ti.",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "El test asigna el valor de puntos correspondiente a cada respuesta y los suma al final para obtener tu puntuación total.",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Comenzar"),
              ),
            ],
          );
        },
      );
    });
  }

  void _onAnswerSelected(Answer answer) async {
    setState(() {
      // Almacena la respuesta seleccionada en el mapa de respuestas
      _answersMap[_currentQuestionIndex] = answer.value;
    });

    if (_currentQuestionIndex < questions.length - 1) {
      _currentQuestionIndex++;
    } else {
      String resultMessage;
      String resultDescription;
      // Calcula el puntaje total sumando las respuestas del mapa
      int _score = _answersMap.values.reduce((a, b) => a + b);

      if (_score >= 0 && _score <= 4) {
        resultMessage = "Buenas prácticas para la salud renal.";
        resultDescription = "Sigue cuidando tus riñones.";
      } else if (_score >= 5 && _score <= 10) {
        resultMessage = "Riesgo moderado.";
        resultDescription =
            "Considera hablar con un médico para una evaluación.";
      } else {
        resultMessage = "Riesgo alto.";
        resultDescription =
            "Se recomienda consultar a un médico para una evaluación y consejo médico.";
      }

      // Obtiene una instancia de SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Obtiene la fecha actual
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);

      // Agrega la cadena actual a testHistory
      testHistory
          .add('$_score;$resultMessage;$resultDescription;$formattedDate');

      // Almacena testHistory en SharedPreferences
      prefs.setStringList('history', testHistory);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Puntuación Total"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Tu puntuación es $_score.",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  resultMessage,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  resultDescription,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Reinicia el total al valor inicial (0).
                  setState(() {
                    _score = 0;
                  });
                  widget.appRouter.go('/test');
                },
                child: Text("Cerrar"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Test de Evaluación de Riesgo Renal",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LinearProgressIndicator(
                value: (_currentQuestionIndex + 1) / questions.length,
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              SizedBox(height: 10),
              Text(
                "Pregunta ${_currentQuestionIndex + 1} de ${questions.length}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                questions[_currentQuestionIndex].question,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Column(
                children: questions[_currentQuestionIndex]
                    .answers
                    .asMap()
                    .entries
                    .map(
                      (entry) => Column(
                        children: [
                          ElevatedButton(
                            onPressed: () => _onAnswerSelected(entry.value),
                            child: Text(
                              entry.value.text,
                              style: TextStyle(fontSize: 16),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              minimumSize: Size(double.infinity, 48),
                            ),
                          ),
                          if (entry.key <
                              questions[_currentQuestionIndex].answers.length -
                                  1)
                            SizedBox(height: 10),
                        ],
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 20),
              if (_currentQuestionIndex > 0)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentQuestionIndex--;
                    });
                  },
                  child: Text("Regresar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(double.infinity, 48),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
