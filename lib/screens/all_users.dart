import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lead_track/models/usermodel.dart';
import 'package:lead_track/screens/login_screen.dart';
import 'package:lead_track/screens/user_task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key key}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  List<UserModel> userList = [];
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  getData() {
    FirebaseDatabase.instance
        .reference()
        .child('users')
        .once()
        .then((DataSnapshot snapshot) {
      print("snapshot${snapshot.value}");

      var keys = snapshot.value.keys;
      print("keys${keys}");
      var values = snapshot.value;
      print("values${values}");
      for (String key in keys) {
        print("key $key");
        UserModel data = UserModel(
          userId: values[key]['userId'],
          name: values[key]['name'],
        );

        setState(() {
          userList.add(data);
        });
        print(userList[0].name);
        print(userList.length);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Container(
        width: MediaQuery.of(context).size.width*0.60,

        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              width: double.infinity,
              margin: EdgeInsets.only(top: 50),
              color: Colors.blue,
              child: CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage(
                    "https://s28164.pcdn.co/files/Malayan-Tiger-0155-2199.jpg"),
              ),

            ),
            SizedBox(height: 5,),
            GestureDetector(
                onTap: () {
                  firebaseAuth.signOut().then((value) {
                    logOut();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => LogInScreen()));
                  });
                },
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("LogOut"),
                ))
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Users"),
        actions: [
          /*GestureDetector(
              onTap: () {
                firebaseAuth.signOut().then((value) {
                  logOut();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => LogInScreen()));
                });
              },
              child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                "LogOut",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
                  )))*/
        ],
      ),
      body: userList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                  itemCount: userList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    UserTask(userModel: userList[index])));
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(userList[index].name),
                        ),
                      ),
                    );
                  }),
            ),
    );
  }

  logOut() async {
    print("logInValue");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("isLogIn", false);
  }
}
