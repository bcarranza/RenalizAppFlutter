import 'package:flutter/material.dart';

class MainList extends StatefulWidget {
  const MainList({super.key});

  @override
  State<MainList> createState() => _MainListState();
}

class _MainListState extends State<MainList> {
  @override
  Widget build(BuildContext context) {
    var items = <Map>[
      {
        "title": 'Título 1',
        "description": 'Descripción del artículo 1.',
        "imageUrl": 'https://source.unsplash.com/random',
        "isStarred": false
      },
      {
        "title": 'Título 2',
        "description": 'Descripción del artículo 2.',
        "imageUrl": 'https://source.unsplash.com/random',
        "isStarred": false
      },
      {
        "title": 'Título 3',
        "description": 'Descripción del artículo 3.',
        "imageUrl": 'https://source.unsplash.com/random',
        "isStarred": false
      },
    ];

    return StatefulBuilder(
        builder: (context, setState) => ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.network(items[index]["imageUrl"]),
                  title: Text(items[index]["title"]),
                  subtitle: Text(items[index]["description"]),
                  trailing: IconButton(
                    icon: Icon(
                      items[index]["isStarred"]
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.orange,
                    ),
                    onPressed: () {
                      setState(() {
                        items[index]["isStarred"] = !items[index]["isStarred"];
                      });
                    },
                  ),
                );
              },
            ));
  }
}
