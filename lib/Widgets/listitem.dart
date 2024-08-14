import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Listitem extends StatelessWidget {
  Listitem(
      {super.key,
      required this.Name,
      required this.College,
      required this.Age,
      required this.Marks,
      required this.edit});

  final String Name;
  final String College;
  final int Age;
  final int Marks;
  final Function edit;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        edit();
      },
      title: Row(
        children: [
          Text(Name + ", ",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(Age.toString(),
              style:const  TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
        ],
      ),
      subtitle: Text(College),
      trailing:
               Text(Marks.toString(), style: const TextStyle(fontSize: 20,color: Colors.green)));

  }
}
