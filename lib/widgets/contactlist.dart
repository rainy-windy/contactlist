import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/contacts.dart';
import '../models/person.dart';

import '../widgets/sliverbar.dart';

class ContactList extends StatefulWidget {
  const ContactList({Key? key }) : super(key: key);

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  int? _expand;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final List<Person> listing = Provider.of<Contacts>(context, listen: true).listing;

    return  CustomScrollView(
      slivers: <Widget>[
        const SliverBar(),
        SliverToBoxAdapter(child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: const Text('To view more details, tap on the each card! Swipe right to delete, double tap to edit straight! For more actions, tap on the arrow head'),
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
                  builder: (BuildContext ctx) => AlertDialog(
                    content: Container(
                          padding: const EdgeInsets.only(top: 32),
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: double.maxFinite,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                            Text(
                              'Are you sure you want to delete\n${listing[n].firstName} ${listing[n].lastName}', 
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
                                    Provider.of<Contacts>(context, listen: false).remove(n);
                                    Navigator.of(ctx).pop();
                                  }, 
                                  child: Text(
                                    'Confirm',
                                    style: TextStyle(color: Theme.of(context).errorColor)
                                  ),
                                ),
                              ],
                            ),
                          ],)
                    ),
                  ),
                ),
                child: GestureDetector(
                  onTap: () =>  setState(() =>  _expand = (_expand != n)? n : null),
                  onDoubleTap: () => Navigator.of(context).pushNamed('/edit', arguments: n),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 1000),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      boxShadow: [ BoxShadow(
                          color: Theme.of(context).primaryColorDark.withOpacity(0.05),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(3, 2),
                        ),
                      ],
                      border:  Border.all(color: Theme.of(context).primaryColorDark, width: 0.5),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
                    height: 72,
                    alignment: Alignment.center,
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
                            onPressed: () => Navigator.of(context).pushNamed(  '/persona', arguments: n),
                            icon: Icon( Icons.arrow_forward_ios, size: 20, color: Theme.of(context).primaryColorLight),
                          ),
                        ),
                      ],
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
