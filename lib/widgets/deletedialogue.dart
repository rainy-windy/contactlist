import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/contacts.dart';

class DeleteDialogue extends StatelessWidget {
  const DeleteDialogue({ Key? key, required this.name, required this.index, this.back = false}) : super(key: key);

  final bool back;
  final String name;
  final int index;

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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
            padding: const EdgeInsets.only(top: 24),
            height: MediaQuery.of(context).size.height * 0.2,
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Are you sure you want to delete\n',
                    style: const TextStyle(color: Colors.black, fontSize: 16, overflow: TextOverflow.ellipsis),
                    children: <TextSpan>[
                      TextSpan(
                        text: '\n$name',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                ButtonBar(
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(), 
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () { 
                        try{
                          Provider.of<Contacts>(context, listen: false).remove(index);
                          _snackbar(context, name);
                          Navigator.of(context).pop() ;
                          if(back){
                            Navigator.of(context).popAndPushNamed('/home');
                          }
                        } catch(error){
                            print('$error');
                        }
                      }, 
                      child: Text(
                        'Confirm',
                        style: TextStyle(color: Theme.of(context).primaryColor)
                      ),
                    ),
                  ],
                ),
            ],)
      ),
    );
  }
}
