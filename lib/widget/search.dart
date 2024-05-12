import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}


class _SearchState extends State<Search> {
  final TextEditingController search = TextEditingController();

  @override
  void initState() {
    super.initState();
    search.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  void _printLatestValue() {
    final text = search.text;
    print('$text (${text.characters.length})');
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: search,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).secondaryHeaderColor,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.zero),
          borderSide: BorderSide.none,
        ),
        hintText: 'Search',
      ),
    );
  }
}
