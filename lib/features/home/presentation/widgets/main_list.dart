import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class MainList extends StatefulWidget {
  const MainList({super.key});

  @override
  State<MainList> createState() => _MainListState();
}

class _MainListState extends State<MainList> {
  late Future blogs;

// Fetch Data

  Future<List> _getBlogs() async {
    Uri uri = Uri.parse(dotenv.env['API_URL']! + 'getAllBlogs');

    final headers = {'Accept': 'application/json'};

    final body = {"perPage": "10", "page": "1"};

    final response = await http.post(uri, headers: headers, body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['response'];
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // blogs = fetchBlogs();

    return FutureBuilder(
      future: _getBlogs(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasData) {
          var blogs = snapshot.data;

          return StatefulBuilder(
              builder: (context, setState) => ListView.builder(
                    itemCount: blogs.length,
                    itemBuilder: (context, index) {
                      final blog = blogs[index] as Map;
                      return Card(
                        elevation:
                            2, // Puedes ajustar la elevación según tus preferencias
                        child: ListTile(
                          contentPadding: EdgeInsets.all(
                              16), // Ajusta el relleno según tus necesidades
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              blog['cover_image'],
                            ),
                          ),
                          title: Text(
                            blog['title'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(blog['category']),
                              Text("Autor: ${blog['author']}"),
                              Text(DateTime.fromMicrosecondsSinceEpoch(
                                      blog['publication_date']["_seconds"] *
                                          1000000)
                                  .toLocal()
                                  .toString()
                                  .split('.')[0]),
                              Text(blog['description']),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.star,
                              color: blog['isStarred']
                                  ? Colors.yellow
                                  : Colors
                                      .grey, // Color de la estrella según el valor de isEstrellado
                            ),
                            onPressed: () {
                              // Maneja la acción cuando se hace clic en la estrella aquí
                              // Puedes agregar lógica para cambiar el valor de isEstrellado
                            },
                          ),
                        ),
                      );
                    },
                  ));
        }

        return Center(
          child: Text("Nothing to show..."),
        );
      },
    );
  }
}
