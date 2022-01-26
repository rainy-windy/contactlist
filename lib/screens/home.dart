import 'package:flutter/material.dart';
import '../widgets/contactlist.dart';
import '../widgets/favlist.dart';

const String PAGE = 'page';
const String TITLE = 'title';
const String ICON = 'icon';

class Home extends StatefulWidget {
  static const routeName = '/home';

  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Map<String, dynamic>> _pages = [
    {TITLE: 'My Contacts', PAGE: const ContactList(), ICON: const Icon(Icons.contacts) },
    {TITLE: 'Favourites', PAGE: const FavList(), ICON: const Icon(Icons.favorite)}
  ];

  int _page = 0;
  bool _loading = false;

  //Page change upon tap on navbar
  void _select(int index) {
    setState(() => _page = index);
  }

  @override
  void initState() {
    _loading = true;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    //Usually used for async calls to ensure data is ready - putting here for representation's sake
    if(_loading){
      _loading == false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:  _pages.elementAt(_page)[PAGE],
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColorDark,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        onPressed: () => Navigator.of(context).pushNamed('/edit', arguments: null),
        label: const Icon(Icons.person_add)
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).secondaryHeaderColor,
              width: 2.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          onTap: _select,
          iconSize: 32,
          showUnselectedLabels: true,
          elevation: 32,
          backgroundColor: Theme.of(context).primaryColor,
          selectedItemColor: Theme.of(context).primaryColorDark,
          unselectedItemColor: Theme.of(context).secondaryHeaderColor,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          currentIndex: _page,
          type: BottomNavigationBarType.shifting,
          items: _pages.map((page) => BottomNavigationBarItem( label: page[TITLE],icon: page[ICON])).toList(),
        ),
      ),
    );
  }
}
