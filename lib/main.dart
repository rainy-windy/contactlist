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
      _initialising = false;
      print('Start-up successfully!');
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _initialising
        ? const CircularProgressIndicator()
        : MultiProvider(
            providers: [
              ChangeNotifierProvider.value(
                value: Contacts(),
              ),
            ],
            child: MaterialApp(
              title: 'Fresh Cars',
              theme: ThemeData(
                primaryColor: Colors.white,
                primaryColorLight:  Colors.orange,
                primaryColorDark: Colors.blue,
                secondaryHeaderColor: Colors.pinkAccent,
                dividerColor: Colors.pinkAccent,
                errorColor: Colors.red,
                // fontFamily: 'Montserrat',
              ),
              home: Home(),
              routes: <String, WidgetBuilder>{
                Home.routeName: (_) => Home(),
                Persona.routeName: (_) => Persona(),
                Edit.routeName: (_) => Edit(),
              },
              onUnknownRoute: (settings) => MaterialPageRoute(
                builder: (_) => Home(),
              ),
            ),
          );
  }
}
