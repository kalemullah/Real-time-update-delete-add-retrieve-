import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'button.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({Key? key}) : super(key: key);

  @override
  _InputScreenState createState() => _InputScreenState();
}

final myController = TextEditingController();
DatabaseReference reference = FirebaseDatabase.instance.reference().child(
    'user');
  bool isCheck= false;
   String docId= '';
class _InputScreenState extends State<InputScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MyHomepage()));
    } catch (e) {
      print(e); //
    }
  }
  Future<void> updateUser(CollectionReference<Object?> users) {
    return users
        .doc(docId)
        .update({'age': myController.text})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));

  }

  String? age;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('weight tracker'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 50, right: 25, left: 25),
          child: ListView(
            children: [
              SizedBox(
                height: 100,
                child: TextField(
                    controller: myController,
                    cursorColor: Colors.greenAccent,
                    decoration: InputDecoration(
                        hintText: "enter your weight in KG",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      age = value;
                    }


                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: SizedBox(
                  height: 50,
                  child: MaterialButton(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    onPressed: () async {
                      if(isCheck) {
                        updateUser(users);
                        isCheck=false;
                        myController.clear();
                      }
                      else{
                      print("Button is pressed");
                      try {
                        // String postID= FirebaseFirestore.instance.collection('users).doc().id;
                        var docId = FirebaseFirestore.instance
                            .collection('users')
                            .doc()
                            .id;
                        var myData = {
                          'age': age,
                          'time': DateTime.now(),
                          'id': docId,
                        };
                        await FirebaseFirestore.instance.collection('users')
                            .doc(docId.toString())
                            .set(myData);
                        myController.clear();
                        print("DATA UPLOADED");
                      }
                      catch (e) {
                        print("Exception@AddData=>$e");
                      }}
                    },
                    child: const Text(
                      "submit",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users').orderBy("time", descending: true)
                    .snapshots(),
                builder: (context, snapeshot) {
                  if (snapeshot.hasData) {
                    List<DocumentSnapshot> documents = snapeshot.data!.docs;
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        height: 100,
                        child: ListView.builder(
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 5,
                              child: ListTile(
                                  title: Text('${documents[index]["age"]}'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ButtonTheme(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                10)),
                                        child:  ElevatedButton(
                                            onPressed: () {
                                              CollectionReference users = FirebaseFirestore.instance.collection('users');
                                               docId = documents[index].id;
                                              print('id is here $docId');
                                             setState(() {
                                               isCheck = true;
                                             });
                                              myController.text=documents[index]['age'];
                                              print('Pressed');
                                            },
                                            child: const Icon(Icons.edit),
                                        ),),

                                        const SizedBox(
                                        width: 5,
                                      ),
                                      // Icon(Icons.edit),
                                      ButtonTheme(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .circular(10)),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              print('Pressed');
                                              //_showDeleteDialog;
                                              try {
                                                var collection = FirebaseFirestore
                                                    .instance.collection(
                                                    'users');
                                                collection
                                                    .doc(
                                                    '${documents[index]["id"]}') // <-- Doc ID to be deleted.
                                                    .delete();
                                              }
                                              catch (e) {
                                                print(e);
                                              }
                                            },
                                            child: Icon(Icons.delete),
                                          )
                                      ),
                                    ],

                                  )
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }
                  return const Text("No data found");
                },

              ),
              const SizedBox(
                height: 20,
              ),
              Button(
                  text: 'sign out ',
                  onPress: () {
                    _signOut(context);
                  }),
            ],
          ),
        ));
  }
}

