import 'package:flutter/material.dart';

class FilterDrawer extends StatefulWidget {
  FilterDrawer({super.key, required this.authors, required this.tags});
  List authors;
  List tags;

  @override
  State<FilterDrawer> createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  @override
  Widget build(BuildContext context) {
    widget.authors.sort((a, b) => a.compareTo(b));
    widget.tags.sort((a, b) => a.compareTo(b));

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.65,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [],
      ),
    );
  }
}
