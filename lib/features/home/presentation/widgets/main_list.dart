import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:renalizapp/features/home/presentation/widgets/widgets.dart';

class MainList extends StatefulWidget {
  const MainList({super.key});

  @override
  State<MainList> createState() => _MainListState();
}

class _MainListState extends State<MainList> {
  ScrollController _scrollController = ScrollController();
  TextEditingController _filter = TextEditingController();
  List blogs = [];
  List filtredBlogs = [];
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
      filtredBlogs.addAll(jsonDecode(response.body)['data']);
      loading = false;
      return true;
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  void filterData(String filtro) {
    setState(() {
      filtredBlogs = blogs.where((articulo) {
        return articulo['title'].toLowerCase().contains(filtro.toLowerCase()) ||
            articulo['category'].toLowerCase().contains(filtro.toLowerCase());
        // articulo['tags']
        //     .any((tag) => tag.toLowerCase().contains(filtro.toLowerCase()));
      }).toList();
    });
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
        filtredBlogs.addAll(jsonDecode(response.body)['data']);
      });
      return true;
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    Color mainColor = Theme.of(context).colorScheme.primary;
    Color secondaryColor = Theme.of(context).colorScheme.secondary;
    double txtScale = MediaQuery.of(context).textScaleFactor;

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
              builder: (context, setState) => Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          onChanged: (texto) {
                            filterData(texto);
                          },
                          decoration: InputDecoration(
                            labelText: "Buscar",
                            hintText: "Ingrese un término de búsqueda",
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: filtredBlogs.length,
                          controller: _scrollController,
                          itemBuilder: (context, index) {
                            final blog = filtredBlogs[index] as Map;
                            final tags = blog['tags'] as List;
                            final displayedTags = tags.take(3).toList();
                            final remainingTagsCount =
                                tags.length - displayedTags.length;
                            final isTruncated = remainingTagsCount > 0;

                            return GestureDetector(
                                onTap: () {
                                  blogDetail = blog;
                                  context.go('/blog-detail');
                                },
                                child: Card(
                                  elevation:
                                      2, // Puedes ajustar la elevación según tus preferencias
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(
                                        16), // Ajusta el relleno según tus necesidades
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        blog['cover_image'],
                                      ),
                                      radius: 40,
                                    ),
                                    title: Text(
                                      blog['title'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0 * txtScale),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(blog['category'],
                                            style: TextStyle(
                                                fontSize: 16.0 * txtScale)),
                                        Text("Autor: ${blog['author']}",
                                            style: TextStyle(
                                                fontSize: 16.0 * txtScale)),
                                        Text(
                                            DateTime.fromMicrosecondsSinceEpoch(
                                                    blog['publication_date']
                                                            ["_seconds"] *
                                                        1000000)
                                                .toLocal()
                                                .toString()
                                                .split('.')[0]),
                                        Text(blog['description'],
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 18.0 * txtScale)),
                                        displayedTags.isNotEmpty
                                            ? SizedBox(height: 20)
                                            : Container(),
                                        Wrap(
                                          spacing: 6,
                                          runSpacing: 6,
                                          children: displayedTags
                                              .map((tag) => Chip(
                                                  label: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        vertical: 0.0,
                                                        horizontal:
                                                            2.0), // Ajusta el padding según tus preferencias
                                                    child: Text(tag , overflow: TextOverflow.ellipsis,),
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25.0),
                                                  ),
                                                  backgroundColor:
                                                      generateColorWithOpacity(tag, mainColor,secondaryColor,0.7),
                                                  labelStyle: TextStyle(
                                                    color: Colors.white,
                                                  )))
                                              .toList(),
                                        ),
                                        isTruncated
                                            ? Text(
                                                "(+$remainingTagsCount más)",
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              )
                                            : SizedBox()
                                      ],
                                    ),
                                    trailing: Icon(
                                      Icons.star,
                                      color: blog['isStarred']
                                          ? Colors.yellow
                                          : Colors
                                              .grey, // Color de la estrella según el valor de isEstrellado
                                    ),
                                  ),
                                ));
                          },
                        ),
                      ),
                    ],
                  ));
        }

        return Center(
          child: Text("Nothing to show..."),
        );
      },
    );
  }
}

Color generateColorWithOpacity(String text, Color baseColor1, Color baseColor2, double opacity) {
  final random = Random(text.hashCode);
  const delta = 30; // Ajusta el valor para controlar la variación de color

  // Componentes RGB de las dos bases de color
  int baseRed1 = baseColor1.red;
  int baseGreen1 = baseColor1.green;
  int baseBlue1 = baseColor1.blue;

  int baseRed2 = baseColor2.red;
  int baseGreen2 = baseColor2.green;
  int baseBlue2 = baseColor2.blue;

  // Alternar entre las dos bases de color
  Color selectedBaseColor = random.nextBool()
      ? baseColor1
      : baseColor2;

  // Generar variaciones aleatorias desde el color base seleccionado
  int deltaR = (selectedBaseColor.red + random.nextInt(delta * 2) - delta).clamp(0, 255);
  int deltaG = (selectedBaseColor.green + random.nextInt(delta * 2) - delta).clamp(0, 255);
  int deltaB = (selectedBaseColor.blue + random.nextInt(delta * 2) - delta).clamp(0, 255);

  return Color.fromRGBO(deltaR, deltaG, deltaB, opacity);
}