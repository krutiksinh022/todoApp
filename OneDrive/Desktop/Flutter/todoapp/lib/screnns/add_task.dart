import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController discriptionController = TextEditingController();

  addtasktofirebase() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    String uid = user.uid;
    var time = DateTime.now();
    await Firestore.instance
        .collection('tasks')
        .document(uid)
        .collection('mytasks')
        .document(time.toString())
        .setData({
      'title': titleController.text,
      'description': discriptionController.text,
      'time': time.toString(),
      'timestamp': time
    });
    Fluttertoast.showToast(msg: 'Data Added');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Your task"),
          backgroundColor: Colors.purple,
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Add Your Task Title'),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: discriptionController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Add Your Task Discription'),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  //addTaskToFirestore();
                  addtasktofirebase();
                },
                child: Container(
                  height: 40,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                  ),
                  child: Center(
                      child: Text(
                    "Save Your Task",
                    style: TextStyle(fontSize: 20),
                  )),
                ),
              )
            ],
          ),
        ));
  }
}
