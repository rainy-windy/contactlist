import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/contacts.dart';
import '../models/person.dart';

import '../widgets/sliverbar.dart';

class FavList extends StatefulWidget {
  const FavList({Key? key }) : super(key: key);

  @override
  State<FavList> createState() => _FavListState();
}

class _FavListState extends State<FavList> {
  int? _expand;

  @override
  Widget build(BuildContext context) {
    final List<Person> listing = Provider.of<Contacts>(context, listen: true).listing;
    final Set<String> _favlist = Provider.of<Contacts>(context, listen: true).favourites;

    return  CustomScrollView(
      slivers: <Widget>[
        const SliverBar(),
        SliverToBoxAdapter(child: SizedBox(height: 64, child: Container(alignment: Alignment.center, 
          child: const  Text('My Favourites', 
            style: TextStyle(
              decoration: TextDecoration.underline,               
              shadows: [ Shadow(color: Colors.black, offset: Offset(0, -5)) ],
              decorationColor: Colors.black,
              color: Colors.transparent)
            ),
          ),
        )),
        (_favlist.isEmpty)
          ? SliverToBoxAdapter(
            child: Container(
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
              margin: const EdgeInsets.all(16), 
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: RichText(
                text: const TextSpan(
                    text: 'Favourtie List currently empty :(\n',
                    style: TextStyle(fontSize: 20, color: Colors.black54),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Start adding!',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              )
            ) 
          : SliverList(delegate: SliverChildBuilderDelegate((BuildContext context, int n) {
              return (_favlist.contains(listing[n].mobileNumber!))? GestureDetector(
                key: ValueKey<String>(listing[n].mobileNumber as String),
                onTap: () =>  setState(() =>  _expand = (_expand != n)? n : null),
                onDoubleTap: () => Navigator.of(context).pushNamed(  '/persona', arguments: n),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    boxShadow: [ BoxShadow(
                        color: Theme.of(context).primaryColorDark.withOpacity(0.05),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(2, 1.5),
                      ),
                    ],
                    border:  Border.all(color: Theme.of(context).primaryColorDark, width: 0.5),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
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
                          onPressed: () => Provider.of<Contacts>(context, listen: false).like(listing[n].mobileNumber as String),
                          icon: Icon( Icons.star, size: 20, color: Theme.of(context).primaryColorLight),
                        ),
                      ),
                    ],
                  ),
                ),
              ) : Container();
            },
            childCount: listing.length,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 64))
      ],
    );
  }
}
