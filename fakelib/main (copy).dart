//import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:number_inc_dec/number_inc_dec.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TakeYourMeds',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        errorColor: Colors.red,
        colorScheme: ThemeData().colorScheme.copyWith(primary: Colors.black),
        //TODO: expand theme
      ),
      home: const MedsHome(),
    );
  }
}

class MedsHome extends StatefulWidget {
  const MedsHome({super.key});

  @override
  State<MedsHome> createState() => _MedsHomeState();
}

class _MedsHomeState extends State<MedsHome> {
  final _suggestions = <String>[];
  final _saved = <String>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  int _generated = 0;

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
            body: const NewMedForm(),
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

class NewMedForm extends StatefulWidget {
  const NewMedForm({super.key});

  @override
  NewMedFormState createState() {
    return NewMedFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class NewMedFormState extends State<NewMedForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<NewMedFormState>.
  final _formKey = GlobalKey<FormState>();
  int timesValue = 0;
  final _timesItems = [0, 1, 2, 3, 4, 5, 6, 7, 8];
  String doseUnitValue = "Pill(s)";
  final _doseUnitItems = ["Pill(s)", "mg", "ml"];

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Name",
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Dosage",
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                      ),
                    ),
                    DropdownButton(
                      // Initial Value
                      value: doseUnitValue,
                      
                      // Down Arrow Icon
                      icon: const Icon(Icons.keyboard_arrow_down),   
                      
                      // Array list of items
                      items: _doseUnitItems.map((String item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          doseUnitValue = newValue!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text('Times Per Day'),
                    DropdownButton(
                      // Initial Value
                      value: timesValue,
                      
                      // Down Arrow Icon
                      icon: const Icon(Icons.keyboard_arrow_down),   
                      
                      // Array list of items
                      items: _timesItems.map((int item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item.toString()),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (int? newValue) {
                        setState(() {
                          timesValue = newValue!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    }
                  },
                  child: const Text('Add'),
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}