import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistoryPageDetail extends StatefulWidget {
  String? uid;
  HistoryPageDetail({
    Key? key,
    this.uid,
  }) : super(key: key);

  @override
  State<HistoryPageDetail> createState() => _HistoryPageDetailState();
}

class _HistoryPageDetailState extends State<HistoryPageDetail> {
  Future<void> obtenerEmpleadoPorId(String uid) async {
    final Uri url = Uri.parse(dotenv.env['API_URL']! + 'getDetailTest');

    final body = {
      "id": uid,
    };

    final response = await http.post(url, body: body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {});
    } else {
      print('Error: ${response.statusCode}');
      throw Exception('Error al obtener datos del empleado');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
