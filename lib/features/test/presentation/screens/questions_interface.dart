import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SurveyPage extends StatefulWidget {
  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  // Lista de preguntas quemadas
  final List<String> questions = [
    '¿Cuál es tu color favorito?',
    '¿Cuál es tu animal favorito?',
    '¿Cuál es tu comida favorita?',
    // ... puedes agregar más preguntas aquí
  ];

  int currentQuestionIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Encuesta'),
      ),
      body: Column(
        children: [
          // Barra de progreso
          LinearProgressIndicator(
            value: (currentQuestionIndex + 1) / questions.length,
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(questions[currentQuestionIndex]),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Botón de pregunta anterior
              ElevatedButton(
                onPressed: currentQuestionIndex > 0
                    ? () {
                        setState(() {
                          currentQuestionIndex--;
                        });
                      }
                    : null,
                child: Text('Anterior'),
              ),
              // Botón de siguiente pregunta
              ElevatedButton(
                onPressed: currentQuestionIndex < questions.length - 1
                    ? () {
                        setState(() {
                          currentQuestionIndex++;
                        });
                      }
                    : null,
                child: Text('Siguiente'),
              ),
            ],
          ),
          SizedBox(height: 20), // Espacio al final
        ],
      ),
    );
  }
}
