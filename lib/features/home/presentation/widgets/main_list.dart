import 'dart:convert';
import 'dart:io';

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
  Future fetchBlogs() async {
    String uri = dotenv.env['API_URL']! + 'getAllBlogs';

    var res;
    try {
      res = await http.post(Uri.parse(uri),
          headers: {HttpHeaders.authorizationHeader: "bearer "});
    } catch (error) {
      print(error);
      return null;
    }

    return res;
  }

  Future<List> _getBlogs() async {
    // print("Token: *${dotenv.env["TOKEN"]}*");
    // print("URI: *${dotenv.env["API_URL"]}getAllBlogs*");

    Uri uri = Uri.parse(dotenv.env['API_URL']! + 'getAllBlogs');

    Map<String, String> headers = {
      "Authorization": "bearer ${dotenv.env['TOKEN']}"
    };

    final response = await http.post(uri, headers: headers);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body;
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
                      return Card(
                        elevation:
                            2, // Puedes ajustar la elevación según tus preferencias
                        child: ListTile(
                          contentPadding: EdgeInsets.all(
                              16), // Ajusta el relleno según tus necesidades
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              blogs[index]['article']['cover_image'],
                            ),
                          ),
                          title: Text(
                            blogs[index]['article']['title'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(blogs[index]['article']['category']),
                              Text(
                                  "Autor: ${blogs[index]['article']['author']}"),
                              Text(blogs[index]['article']['publication_date']
                                  .toString()),
                              Text(blogs[index]['article']['description']),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.star,
                              color: blogs[index]['article']['isEstrellado']
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
