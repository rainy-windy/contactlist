import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/person.dart';
import '../providers/contacts.dart';

import '../widgets/gesture.dart';

class Persona extends StatefulWidget {
  static const routeName = '/persona';
  
  const Persona({Key? key}) : super(key: key);

  @override
  State<Persona> createState() => _PersonaState();
}

class _PersonaState extends State<Persona> {
  bool _initialising = true;

  late int _index;
  Person? _person;

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _snackbar(BuildContext context, String name) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.fixed,
        elevation: 32,
        duration: const Duration(milliseconds: 1750),
        content: Text(
          'Deleted $name',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        dismissDirection: DismissDirection.endToStart,
      ),
    );
  }

  void _delete(){
    try{
      Provider.of<Contacts>(context, listen: false).remove(_index);
      _snackbar(context, '${_person!.firstName} ${_person!.lastName}');
      Navigator.of(context).popAndPushNamed('/home');
    }catch(error){
      print(error);
    }
  }

  @override
  void initState() {

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_initialising) {
      _index = ModalRoute.of(context)!.settings.arguments as int;
      _person = Provider.of<Contacts>(context).getDetails(_index);
    }
    _initialising = false;
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
                        title: Text('${_person?.firstName} ${_person?.lastName}', overflow: TextOverflow.ellipsis,),
                        background: Container(
                          padding: const EdgeInsets.all(10),
                          width: double.infinity,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(height: MediaQuery.of(context).padding.top),
                              CircleAvatar(radius: 48, child: const Icon(Icons.person, size: 48), backgroundColor:  Theme.of(context).primaryColor,
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
                                  child: Gesture(index: _index, caption: 'Delete', colourStart: const Color(0xFFFF9494), colourEnd: const Color(0xFFFF0000), icon: const Icon(Icons.delete)),
                                  onTap: () => showDialog(context: context, builder: (BuildContext ctx) => AlertDialog(
                                      content: Container(
                                            padding: const EdgeInsets.only(top: 32),
                                            height: MediaQuery.of(context).size.height * 0.2,
                                            width: double.maxFinite,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Are you sure you want to delete\n${_person!.firstName} ${_person!.lastName}', 
                                                  textAlign: TextAlign.center,
                                                ),
                                                ButtonBar(
                                                  children: [
                                                    TextButton(
                                                      onPressed: () => Navigator.of(ctx).pop(), 
                                                      child: const Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () { 
                                                        Navigator.of(ctx).pop();
                                                        _delete();
                                                      }, 
                                                      child: Text(
                                                        'Confirm',
                                                        style: TextStyle(color: Theme.of(context).errorColor)
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                            ],
                                        )
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 4,
                                  child: GestureDetector(
                                    child: Gesture(index: _index, caption: 'Edit', colourStart: const Color(0xFF90EE90), colourEnd: const Color(0xFF008080), icon: const Icon(Icons.edit)),
                                    onTap: () =>  Navigator.of(context).pushNamed('/edit', arguments: _index),
                                  ),
                              ),
                              Expanded(
                                  flex: 4,
                                  child: InkWell(
                                    child: Gesture(index: _index, caption: 'Fav', colourStart: const Color(0xFFFFFF00), colourEnd: const Color(0xFFCCCC00), icon: favlist.contains(_person!.mobileNumber)? const Icon(Icons.star) : const Icon(Icons.star_border)),
                                    onTap: () =>Provider.of<Contacts>(context,listen: false).like(_person!.mobileNumber as String),
                                    splashColor:  const Color(0xFFFFFF00),
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
                                    children: [...ListTile.divideTiles(
                                        context: context,
                                        tiles: [
                                          const ListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                            leading: Text(
                                              'Contact Info',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                           ListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                            leading: RichText(
                                              text: TextSpan(
                                                text: 'Email  ',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: _person?.emailAddress,
                                                    style:  TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            trailing: const  Icon(Icons.email),
                                          ),
                                          ListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                            leading: RichText(
                                              text: TextSpan(
                                                text: 'Mobile  ',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: _person?.mobileNumber,
                                                    style:  TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            trailing: const Icon(Icons.phone_android),
                                          ) ]
                                      ),
                                    ],
                                  ),
                                ),
                                // Card(
                                //   child: InkWell(
                                //     onTap: () => {},
                                //     child: ListTile(
                                //       contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                //       leading: Text('Log out'),
                                //       trailing: Icon(Icons.logout),
                                //     ),
                                //   ),
                                // ),
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
