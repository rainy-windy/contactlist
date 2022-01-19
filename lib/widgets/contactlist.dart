import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/contacts.dart';
import '../models/person.dart';

import '../widgets/sliverbar.dart';
import 'deletedialogue.dart';

class ContactList extends StatefulWidget {
  const ContactList({Key? key }) : super(key: key);

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  int? _expand;

  @override
  Widget build(BuildContext context) {
    final List<Person> listing = Provider.of<Contacts>(context, listen: true).listing;

    return  CustomScrollView(
      slivers: <Widget>[
        const SliverBar(),
        SliverToBoxAdapter(child:  Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: const <Widget>[
              Text('To view more details, tap on the each card! Swipe right to delete, double tap to edit straight! For more actions, tap on the arrow head.'),
              Divider()
            ],
          ),
        ),),
        SliverList(delegate: SliverChildBuilderDelegate((BuildContext context, int n) {
          return Dismissible(
                key: ValueKey<int>(n),
                background: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20.0),
                  color: Theme.of(context).errorColor,
                  child: const Icon(Icons.delete_forever, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                confirmDismiss: (_) => showDialog(
                  context: context, 
                  builder: (BuildContext ctx) => DeleteDialogue(name: '${listing[n].firstName} ${listing[n].lastName}', index: n),
                ),
                child: GestureDetector(
                  onTap: () =>  setState(() =>  _expand = (_expand != n)? n : null),
                  onDoubleTap: () => Navigator.of(context).pushNamed('/edit', arguments: n),
                  child: Card(
                    elevation: 8,
                    margin: const EdgeInsets.symmetric(horizontal:8.0, vertical: 4.0),
                    shadowColor: Theme.of(context).primaryColorDark,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child:  CircleAvatar(
                              child: const Icon(Icons.person,  color: Colors.black, size: 32, ),
                              backgroundColor: Theme.of(context).secondaryHeaderColor,
                              minRadius: 16.0,
                              maxRadius: 24.0,
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${listing[n].firstName} ${listing[n].lastName}',
                                  style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColorDark),
                                ),
                                Text(
                                  listing[n].mobileNumber as String,
                                  style: TextStyle(fontSize: 12, color: Theme.of(context).primaryColorLight, fontWeight: FontWeight.bold),
                                ),
                                (n == _expand)? Text(listing[n].emailAddress as String, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: Theme.of(context).primaryColorLight)) : Container(),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child:  IconButton(
                              splashColor: Theme.of(context).secondaryHeaderColor,
                              splashRadius: 24,
                              color: Colors.transparent,
                              padding: const EdgeInsets.all(0),
                              onPressed: () => Navigator.of(context).pushNamed('/persona', arguments: n),
                              icon: Icon( Icons.arrow_forward_ios, size: 20, color: Theme.of(context).primaryColorLight),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            childCount: listing.length,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 64))
      ],
    );
  }
}

