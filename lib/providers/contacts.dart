import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../models/person.dart';

class Contacts with ChangeNotifier {

  //Attributes of Contacts
  final List<Person> _items = [
     Person(
      lastName: 'Grant',
      firstName: 'Adam',
      emailAddress: 'thinkagain@outlook.com',
      mobileNumber: '91301081',
    ), Person(
      lastName: 'Pink',
      firstName: 'Daniel',
      emailAddress: 'tosellishuman@gmail.com',
      mobileNumber: '91211081',
    ),  Person(
      lastName: 'Gladwell',
      firstName: 'Malcolm',
      emailAddress: 'davidandgoliath@gmail.com',
      mobileNumber: '91401081',
    ), Person(
      firstName: 'Nicholas',
      lastName: 'Taleb',
      emailAddress: 'theblackswan@gmail.com',
      mobileNumber: '91801081',
    ), Person(
      lastName: 'Dalio',
      firstName: 'Ray',
      emailAddress: 'changingworldorder@outlook.com',
      mobileNumber: '91701081',
    ), Person(
      lastName: 'Huntington',
      firstName: 'Samuel',
      emailAddress: 'clashofcivilisations@yahoo.com',
      mobileNumber: '91601081',
    ), Person(
      lastName: 'Hobbes',
      firstName: 'Thomas',
      emailAddress: 'leviathan@yahoo.com',
      mobileNumber: '91001081',
    ), Person(
      lastName: 'Zhuang',
      firstName: 'Yufeng',
      emailAddress: 'yufeng@u.nus.com',
      mobileNumber: '91501081',
    ), Person(
      lastName: 'Harari',
      firstName: 'Yuval',
      emailAddress: 'homodeusi@gmail.com',
      mobileNumber: '91201081',
    ),  
  ];

  Set<String> _fav = {'91501081', '91601081', '91801081'};

  //Current total contacts
  int get total {
    return _items.length;
  }
  
  //Current contacts
  List<Person> get listing {
    return [..._items];
  }

  //Current favourites
  Set<String> get favourites {
    return {..._fav};
  }

  //One particular contact
  Person getDetails (int index){
    return _items[index];
  }

  //Edit or Add a contact
  void edit(Person editPerson, [int? index]) {
    if(_items.isNotEmpty && index!= null){
      if(index >= _items.length){
        throw Error();
      }

      if(_fav.contains(_items[index].mobileNumber)){
        _fav.remove(_items[index].mobileNumber);
        _fav.add(editPerson.mobileNumber as String);
      }
      
      _items.removeAt(index);
    }
    
    _items.add(editPerson);
    _items.sort((one, two) => one.firstName!.compareTo(two.firstName!)); //optional 
    notifyListeners();
  }

  //Delete a contact
  void remove(int index) {
    if(_items.isNotEmpty ){
      if(_fav.contains('${_items[index].firstName}${_items[index].lastName}')){
        _fav.remove('${_items[index].firstName}${_items[index].lastName}');
      }
      _items.removeAt(index);
    }
    
    notifyListeners();
  }

  //Favourite a contact
  void like(String pid){
    if (_fav.contains(pid)) {
      _fav.remove(pid);
    } else {
      _fav.add(pid);
    }
    
    notifyListeners();
  }

}
