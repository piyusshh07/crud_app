import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UpdateData extends StatefulWidget {
  UpdateData(
      {super.key,
      required this.name,
      required this.college,
      required this.age,
      required this.marks,
      required this.indx});

  final String name;
  final String college;
  final int age;
  final int marks;
  final String indx;

  @override
  State<UpdateData> createState() {
    return _UpdateDataState();
  }
}

class _UpdateDataState extends State<UpdateData> {
  @override
  Widget build(BuildContext context) {
    var isSaving = false;

    TextEditingController namectrl = TextEditingController();
    TextEditingController collegectrl = TextEditingController();
    TextEditingController agectrl = TextEditingController();
    TextEditingController marksctrl = TextEditingController();

    namectrl..text = widget.name.toString();
    collegectrl..text = widget.college.toString();
    agectrl..text = widget.age.toString();
    marksctrl..text = widget.marks.toString();

    var name;
    var college;
    int? age;
    int? marks;

    String docId = widget.indx;
    final formkey = GlobalKey<FormState>();

    void update() async {
      var valid = formkey.currentState!.validate();
      if (valid) {
        formkey.currentState!.save();
        final updatedinfo = {
          'StudentName': name,
          'CollegeName': college,
          'Age': age,
          'Marks': marks,
        };
        try {
          setState(() {
            isSaving = true;
          });
          DocumentReference reference = await FirebaseFirestore.instance
              .collection('Student_info')
              .doc(docId);
          await reference.update(updatedinfo);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('info updated')));
          namectrl.clear();
          agectrl.clear();
          marksctrl.clear();
          collegectrl.clear();
        } catch (error) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('$error'.toString())));
        }
      }
      setState(() {
        isSaving = false;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Information'),
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
                  controller: namectrl,
                  decoration: const InputDecoration(
                      label: Text('Student Name'),
                      border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter valid value';
                    }
                  },
                  onSaved: (value) {
                    name = value!;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: collegectrl,
                  decoration: const InputDecoration(
                      label: Text('Collge Name'), border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter valid value';
                    }
                  },
                  onSaved: (value) {
                    college = value!;
                  },
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 100,
                      child: TextFormField(
                        controller: agectrl,
                        decoration: const InputDecoration(
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
                        controller: marksctrl,
                        decoration: const InputDecoration(
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
                const SizedBox(
                  height: 20,
                ),
                Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigoAccent,
                            foregroundColor: Colors.black),
                        onPressed: () {
                          update();
                        },
                        child: isSaving
                            ? CircularProgressIndicator()
                            : const Text(
                                'Update Information',
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
