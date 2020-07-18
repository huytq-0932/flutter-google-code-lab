import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Welcome to Flutter",
      theme: ThemeData(
        primaryColor: Colors.white
      ),
      home: Scaffold(
        body: RandomWords(),
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RandomWorksState();
}

class _RandomWorksState extends State<RandomWords> {
  final List<WordPair> _suggestions = <WordPair>[];
  final _saved = Set<WordPair>();
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Startup Name Generator"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: _pushSaved,
          )
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    final titles = _saved.map((wordPair) => ListTile(
          title: Text(
            wordPair.asPascalCase,
            style: _biggerFont,
          ),
        ));
    final getDivided = (BuildContext context) {
      return ListTile.divideTiles(
        context: context,
        tiles: titles,
      ).toList();
    };
    final route = MaterialPageRoute<void>(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Saved Suggestions"),
        ),
        body: ListView(children: getDivided(context)),
      );
    });
    Navigator.of(context).push(route);
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (BuildContext _context, int position) {
          if (position.isOdd) return Divider();

          final int index = position ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRaw(_suggestions[index]);
        });
  }

  Widget _buildRaw(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }
}
