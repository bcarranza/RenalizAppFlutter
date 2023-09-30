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
  ScrollController _scrollController = ScrollController();
  List blogs = [];
  int perPage = 10;
  int page = 1;
  int allItems = 0;
  bool loading = false;

// Fetch Data

  Future _getBlogs() async {
    if (blogs.isNotEmpty) {
      return true;
    }

    Uri uri = Uri.parse(dotenv.env['API_URL']! + 'getAllBlogs');

    final headers = {'Accept': 'application/json'};

    final body = {"perPage": perPage.toString(), "page": page.toString()};

    final response = await http.post(uri, headers: headers, body: body);

    if (response.statusCode == 200) {
      allItems = jsonDecode(response.body)['allItems'];
      blogs.addAll(jsonDecode(response.body)['data']);
      loading = false;
      return true;
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  _loadMoreBlogs() async {
    Uri uri = Uri.parse(dotenv.env['API_URL']! + 'getAllBlogs');

    final headers = {'Accept': 'application/json'};

    page++;
    final body = {"perPage": perPage.toString(), "page": page.toString()};

    final response = await http.post(uri, headers: headers, body: body);

    if (response.statusCode == 200) {
      setState(() {
        blogs.addAll(jsonDecode(response.body)['data']);
      });
      return true;
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          ((perPage * page) <= allItems)) {
        await _loadMoreBlogs();
      }
    });

    return FutureBuilder(
      future: _getBlogs(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasData) {
          // List mapBlogs = blogs.map((e) {
          //   e['publication_date'] = Map.from(e['publication_date']);

          //   return Map.from(e);
          // }).toList();

          // mapBlogs.sort((a, b) => b['publication_date']['_seconds']
          //     .compareTo(a['publication_date']['_seconds']));

          return StatefulBuilder(
              builder: (context, setState) => ListView.builder(
                    itemCount: blogs.length,
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      final blog = blogs[index] as Map;
                      return Card(
                        elevation:
                            2, // Puedes ajustar la elevación según tus preferencias
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(
                              16), // Ajusta el relleno según tus necesidades
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              blog['cover_image'],
                            ),
                          ),
                          title: Text(
                            blog['title'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
                              Text(
                                blog['description'],
                                overflow: TextOverflow.ellipsis,
                              ),
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
