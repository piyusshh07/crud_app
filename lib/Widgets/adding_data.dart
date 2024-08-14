import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class AddingData extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddingdataState();
  }
}

class _AddingdataState extends State<AddingData> {
  final formkey = GlobalKey<FormState>();
  var name;
  var college;
  int? age;
  int? marks;
  var isSaving = false;

  void Submit() async {
    var valid = formkey.currentState!.validate();
    if (valid) {
      formkey.currentState!.save();
      final studentsinfo = {
        'StudentName': name,
        'CollegeName': college,
        'Age': age,
        'Marks': marks,
      };
      try {
        setState(() {
          isSaving = true;
        });
        await FirebaseFirestore.instance
            .collection('Student_info')
            .add(studentsinfo);
      } catch (error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$error'.toString())));
      }
      setState(() {
        isSaving = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const  Text('Add students'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                      label: Text('Student Name'),
                      border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter valid value';
                    }
                  },
                  onSaved: (value) {
                    name = value;
                  },
                ),
              const  SizedBox(height: 10),
                TextFormField(
                  decoration:const InputDecoration(
                      label: Text('Collge Name'), border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter valid value';
                    }
                  },
                  onSaved: (value) {
                    college = value;
                  },
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 100,
                      child: TextFormField(
                        decoration: InputDecoration(
                            label: Text('Age'), border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter valid value';
                          }
                        },
                        onSaved: (value) {
                          age = int.tryParse(value!);
                        },
                      ),
                    ),
                    Container(
                      width: 200,
                      child: TextFormField(
                        decoration: InputDecoration(
                            label: Text('marks out of 100'),
                            border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
                        maxLength: 3,
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              int.tryParse(value)! > 100) {
                            return 'Please enter valid value';
                          }
                        },
                        onSaved: (value) {
                          marks = int.tryParse(value!);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigoAccent,
                            foregroundColor: Colors.black),
                        onPressed: () {
                          Submit();
                        },
                        child: isSaving
                            ? CircularProgressIndicator()
                            : Text(
                                'Sumbit details',
                                style: TextStyle(fontSize: 15),
                              )))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
