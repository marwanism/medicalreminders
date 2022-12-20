import 'package:flutter/material.dart';
import 'package:medicalremcs/widgets/new-med-form.dart';
import 'package:medicalremcs/models/medicine.dart';

class MedsHome extends StatefulWidget {
  const MedsHome({super.key});

  @override
  State<MedsHome> createState() => _MedsHomeState();
}

class _MedsHomeState extends State<MedsHome> {
  final _suggestions = <String>[];
  final _saved = <String>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  List<Medicine> meds = [];
  int _generated = 0;

  saveMedicine(Medicine newMed) {
    setState(() {
      meds.add(newMed);
    });
  }

  @override
  Widget build(BuildContext context) {
    //final wordPair = WordPair.random();
    return Scaffold(   // NEW from here ...
      appBar: AppBar(  
        title: RichText(
          text: TextSpan(
            children: [
              WidgetSpan(child: Icon(Icons.more_vert, size: 16,) ), //TODO: change icon
              TextSpan(text: 'TakeYourMeds'),
            ],
          ),
        ),
        // title: const Text('TakeYourMeds'),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.list),
        //     onPressed: _pushSaved,
        //     tooltip: 'Saved Suggestions',
        //   ),
        // ],
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black87,
              ),
              child: Text(
                'TakeYourMeds',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
              ),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                //TODO: fix home pop, make it pop all the way to home
              },
            ),
            ListTile(
              leading: Icon(
                Icons.animation, //TODO: change icon to pill
              ),
              title: const Text('Medicines'),
              onTap: _pushMeds,
            ),
            ListTile(
              leading: Icon(
                Icons.account_circle,
              ),
              title: const Text('Profile'),
              onTap: _pushProfile,
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
              ),
              title: const Text('Settings'),
              onTap: _pushSettings,
            ),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider();

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(_getWords());
          }

          final alreadySaved = _saved.contains(_suggestions[index]);

          return ListTile(
            title: Text(
              _suggestions[index],
              style: _biggerFont,
            ),
            trailing: Icon(    // NEW from here ...
              alreadySaved ? Icons.favorite : Icons.favorite_border,
              color: alreadySaved ? Colors.red : null,
              semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
            ),
            onTap: () {
              setState(() {
                if (alreadySaved) {
                  _saved.remove(_suggestions[index]);
                } else {
                  _saved.add(_suggestions[index]);
                }
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pushAddMed,
        backgroundColor: Colors.black87,
        child: Icon(Icons.add),
      ),
    );
  }

  void _pushMeds() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return ListTile(
                title: Text(
                  pair,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Medicines'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  void _pushSettings() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return ListTile(
                title: Text(
                  pair,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  void _pushProfile() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return ListTile(
                title: Text(
                  pair,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  void _pushAddMed() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Add A New Medicine'),
            ),
            body: NewMedForm(notifyParent: saveMedicine,),
          );
        },
      ),
    );
  }

  List<String> _getWords() {
    return List<String>.filled(10, 'ZebbyManga').map((e) {
        _generated++;
        return e + _generated.toString();
      }
    ).toList();
  }
}