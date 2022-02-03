import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/person.dart';
import '../providers/contacts.dart';

import '../widgets/gesture.dart';
import '../widgets/deletedialogue.dart';

class Persona extends StatefulWidget {
  static const routeName = '/persona';

  const Persona({Key? key}) : super(key: key);

  @override
  State<Persona> createState() => _PersonaState();
}

class _PersonaState extends State<Persona> {
  bool _initialising = false;
  double _height = 64;
  Person? _person;
  late int _index;

  @override
  void initState() {
    _initialising = true;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_initialising) {
      _index = ModalRoute.of(context)!.settings.arguments as int;
      _person = Provider.of<Contacts>(context, listen: false).getDetails(_index);
      _initialising = false;
    }

    if (_height < 64) {
      Future.delayed(const Duration(milliseconds: 400)).then((_) => setState(() => _height = 64)).catchError((error) {
        print(error);
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final favlist = Provider.of<Contacts>(context, listen: true).favourites;

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height - 96,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: true,
              leading: IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back)),
              expandedHeight: 185,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  '${_person?.firstName} ${_person?.lastName}',
                  overflow: TextOverflow.ellipsis,
                ),
                background: Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: MediaQuery.of(context).padding.top),
                      CircleAvatar(
                        radius: 48,
                        child: const Icon(Icons.person, size: 48),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 4,
                      child: GestureDetector(
                        child: Gesture(caption: 'Delete', colourStart: const Color(0xFFFF9494), colourEnd: const Color(0xFFFF0000), icon: const Icon(Icons.delete)),
                        onTap: () => showDialog(
                          context: context,
                          builder: (BuildContext ctx) => DeleteDialogue(name: '${_person!.firstName} ${_person!.lastName}', index: _index, back: true),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: GestureDetector(
                        child: Gesture(caption: 'Edit', colourStart: const Color(0xFFFFE0B2), colourEnd: Theme.of(context).primaryColorLight, icon: const Icon(Icons.edit)),
                        onTap: () => Navigator.of(context).pushNamed('/edit', arguments: _index),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: InkWell(
                        child: Gesture(
                            caption: 'Star', colourStart: const Color(0xFFFCE4EC), colourEnd: Theme.of(context).secondaryHeaderColor, icon: favlist.contains(_person!.mobileNumber) ? const Icon(Icons.star) : const Icon(Icons.star_border), stretch: _height),
                        onTap: () {
                          setState(() => _height = 56);
                          Provider.of<Contacts>(context, listen: false).like(_person!.mobileNumber as String);
                        },
                        splashColor: const Color(0xFFFFFF00),
                        radius: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Card(
                          child: Column(
                            children: [
                              ...ListTile.divideTiles(context: context, tiles: [
                                const ListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                  leading: Text(
                                    'Contact Info',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                  leading: RichText(
                                    text: TextSpan(
                                      text: 'Email  ',
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: _person?.emailAddress,
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  trailing: const Icon(Icons.email),
                                ),
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                  leading: RichText(
                                    text: TextSpan(
                                      text: 'Mobile  ',
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: _person?.mobileNumber,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  trailing: const Icon(Icons.phone_android),
                                )
                              ]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
