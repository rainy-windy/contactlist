import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import './providers/contacts.dart';
import './screens/home.dart';
import './screens/persona.dart';
import './screens/edit.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool _initialising = false;

  @override
  void initState() {
    _initialising = true;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_initialising) {
      print('Start-up successfully!');
      _initialising = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return _initialising
      ? const CircularProgressIndicator(strokeWidth: 8, backgroundColor: Colors.blue)
      : MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: Contacts(),
            ),
          ],
          child: MaterialApp(
            title: 'Contact List',
            theme: ThemeData(
              primaryColor: Colors.white,
              primaryColorLight:  Colors.orange,
              primaryColorDark: Colors.blue,
              secondaryHeaderColor: Colors.pink[200],
              dividerColor: Colors.pinkAccent,
              errorColor: Colors.red[700],
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(primary: Theme.of(context).errorColor),
              ),
            ),
            home: const Home(),
            routes: <String, WidgetBuilder>{
              Home.routeName: (_) => const Home(),
              Persona.routeName: (_) => const Persona(),
              Edit.routeName: (_) => Edit(),
            },
            onUnknownRoute: (settings) => MaterialPageRoute(
              builder: (_) => const Home(),
            ),
          ),
        );
  }
}
