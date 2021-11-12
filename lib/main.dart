import 'package:flutter/material.dart';
import 'inputpag.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'button.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {


  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'weight tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomepage(),
    );
  }
}
class MyHomepage extends StatefulWidget {
  const MyHomepage({Key? key}) : super(key: key);


  @override
  _MyHomepageState createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
  //function for sign in anonymously
  Future<void> signInAnonymously(BuildContext context) async {
    try {
      var cre= await FirebaseAuth.instance.signInAnonymously();
      if(cre.user!=null){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  const InputScreen()));
      }
    } catch (e) {
      print(e);

    }}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weight Tracker'),
        centerTitle: true,
      ),
      body:  Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ListView(
              children:  [
                const SizedBox(
                  height: 200,
                  width: 200,
                  child: Image(
                    image: AssetImage('assets/weight.jfif'),
                  ),
                ),
                const SizedBox(
                  height: 90,
                ),
                Button(text:'signIn Anonymous  ',onPress: ()async{
                  await signInAnonymously(context);
                }),
              ],
            ),
          )
    );
  }
}



