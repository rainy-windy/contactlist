import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/person.dart';
import '../providers/contacts.dart';

class Edit extends StatefulWidget {
  static const routeName = '/edit';

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  bool _initialising = false;
  late int? _index;

  final _nameNode = FocusNode();
  final _mobileNode = FocusNode();
  final _emailNode = FocusNode();
  final _form = GlobalKey<FormState>();

  Person _current = Person(
    firstName: '',
    lastName: '',
    mobileNumber: '',
    emailAddress: '',
  );

  @override
  void initState() {
    _initialising = true;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_initialising) {
      _index = ModalRoute.of(context)!.settings.arguments as int?;
      if(_index != null){
        _current = Provider.of<Contacts>(context,listen: false).getDetails(_index!);
      }
      _initialising = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _emailNode.dispose();
    _nameNode.dispose();
    _mobileNode.dispose();
    super.dispose();
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _snackbar(BuildContext context, String name) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        elevation: 32,
        duration: const Duration(milliseconds: 1000),
        content: Text(
          'Saving $name',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        dismissDirection: DismissDirection.endToStart,
      ),
    );
  }

  InputDecoration _textstyle(String textLabel, Icon iconLabel) {
    return InputDecoration(
      focusedErrorBorder: InputBorder.none,
      labelText: textLabel,
      counterText: "",
      suffixIcon: iconLabel,
      focusedBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      hintText: '',
      errorStyle: const TextStyle(fontSize: 8),
      hintStyle: const TextStyle( fontSize: 16,),
    );
  }

  void _save() {
    final validity = _form.currentState!.validate();
    
    if (!validity) {
      return;
    }

    try{
      _form.currentState!.save();
      if(_index != null){
        Provider.of<Contacts>(context, listen: false).edit( _current, _index);
      }else{
        Provider.of<Contacts>(context, listen: false).edit( _current);
      }

      _snackbar(context, '${_current.firstName} ${_current.lastName}' );
      Navigator.of(context).pushReplacementNamed('/home');
      
    } catch(error){
      _snackbar(context, 'failed!' );
      print(error);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((_index == null)? 'Add New Contact' : 'Edit Contact' ),
        actions: <Widget>[
          IconButton(
            icon: const  Icon(Icons.save),
            onPressed: _save,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _current.firstName,
                maxLength: 12,
                decoration: _textstyle('First Name', const Icon(Icons.text_fields)),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_nameNode),
                validator: (value) => value!.isEmpty? 'Empty!' :  null,
                onSaved: (value) => _current = Person(
                    firstName: '${value![0].toUpperCase()}${value.substring(1).toLowerCase().trim()}',
                    lastName: _current.lastName,
                    mobileNumber: _current.mobileNumber,
                    emailAddress: _current.emailAddress,
                  )
              ),
              TextFormField(
                initialValue: _current.lastName,
                maxLength: 12,
                decoration: _textstyle('Last Name', const Icon(Icons.text_fields)),
                textInputAction: TextInputAction.next,
                focusNode: _nameNode,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_mobileNode),
                validator: (value) => value!.isEmpty? 'Empty!' :  null,
                onSaved: (value) => _current = Person(
                    firstName: _current.firstName,
                    lastName: value!.trim(),
                    mobileNumber: _current.mobileNumber,
                    emailAddress: _current.emailAddress,
                  )
              ),
              TextFormField(
                initialValue: _current.mobileNumber,
                maxLength: 12,
                decoration: _textstyle('Mobile', const Icon(Icons.phone_callback_outlined)),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _mobileNode,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_emailNode),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Empty!';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Invalid';
                  }
                  return null;
                },
                onSaved: (value) => _current = Person(
                    firstName: _current.firstName,
                    lastName: _current.lastName,
                    mobileNumber: value.toString(),
                    emailAddress: _current.emailAddress,
                  )
              ),
              TextFormField(
                initialValue: _current.emailAddress,
                decoration: _textstyle('Email', const Icon(Icons.mail_outline_outlined)),
                textInputAction: TextInputAction.done,
                focusNode: _emailNode,
                onFieldSubmitted: (_) =>  _save(),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Empty!';
                  }
                  if (!value.contains('@')) {
                    return 'Invalid';
                  }
                  return null;
                },
                onSaved: (value) => _current = Person(
                    firstName: _current.firstName,
                    lastName: _current.lastName,
                    mobileNumber:  _current.mobileNumber,
                    emailAddress: value!.trim(),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
