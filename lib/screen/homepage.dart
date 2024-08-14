import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_app/Widgets/adding_data.dart';
import 'package:simple_app/Widgets/listitem.dart';
import 'package:simple_app/Widgets/update_data.dart';

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() {
    return _HomepageState();
  }
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Students Information'),
          backgroundColor: Colors.blue,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                useSafeArea: true,
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) => AddingData());
          },
          child: Icon(Icons.add),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Student_info')
                .snapshots(),
            builder: (ctx, AsyncSnapshot<QuerySnapshot> InfoSnapshots) {
              if (InfoSnapshots.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (InfoSnapshots.hasError) {
                return const Center(
                  child: Text('Something went Wrong !!!!'),
                );
              }
              if (!InfoSnapshots.hasData || InfoSnapshots.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No Information found try adding some...'),
                );
              }

              final Studentinfo = InfoSnapshots.data!.docs;
              return ListView.builder(
                  itemCount: Studentinfo.length,
                  itemBuilder: (ctx, index) {
                    final data =
                        Studentinfo[index].data() as Map<String, dynamic>;
                    final docId = Studentinfo[index].id;
                    return Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Card(
                            elevation: 3,
                            child: Dismissible(
                              background: Container(color: Colors.red),
                              onDismissed: (direction) async {
                                await FirebaseFirestore.instance
                                    .collection('Student_info')
                                    .doc(docId)
                                    .delete();
                              },
                              key: ValueKey(docId),
                              child: Listitem(
                                Name: data['StudentName'],
                                College: data['CollegeName'],
                                Marks: data['Marks'],
                                Age: data['Age'],
                                edit: () {
                                  showModalBottomSheet(
                                      useSafeArea: true,
                                      isScrollControlled: true,
                                      context: ctx,
                                      builder: (BuildContext ctx) => UpdateData(
                                            name: data['StudentName'],
                                            college: data['CollegeName'],
                                            age: data['Age'],
                                            marks: data['Marks'],
                                            indx: docId,
                                          ));
                                },
                              ),
                            )));
                  });
            }));
  }
}
