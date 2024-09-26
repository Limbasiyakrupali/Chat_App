import 'package:chat_app/utils/helper/Auth_helper.dart';
import 'package:chat_app/utils/helper/firebasedatabase_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../component/mydrawer_component.dart'; // Ensure this import matches your file structure

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    final User? user = ModalRoute.of(context)?.settings.arguments as User?;

    return Scaffold(
      drawer: user != null ? MyDrawer(user: user) : null,
      appBar: AppBar(
        title: Text("Chat App"),
        actions: [],
      ),
      body: StreamBuilder(
          stream: FirestoreHelper.firestoreHelper.fetchAllUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("ERROR: ${snapshot.error}"),
              );
            } else if (snapshot.hasData) {
              QuerySnapshot<Map<String, dynamic>>? data = snapshot.data;

              List<QueryDocumentSnapshot<Map<String, dynamic>>> alldata =
                  (data == null) ? [] : data.docs;

              return ListView.separated(
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 15,
                  );
                },
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.all(8),
                    elevation: 3,
                    child: Container(
                      alignment: Alignment.center,
                      height: 70,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          radius: 30,
                          child: (AuthHelper.firebaseAuth.currentUser!.email ==
                                  alldata[index].data()['email'])
                              ? Icon(Icons.person)
                              : Text(
                                  "${alldata[index].data()['username']}"
                                      .characters
                                      .first,
                                  style: GoogleFonts.getFont("Mulish",
                                      textStyle: TextStyle(fontSize: 20)),
                                ),
                        ),
                        title: (AuthHelper.firebaseAuth.currentUser!.email ==
                                alldata[index].data()['email'])
                            ? Text("You (${alldata[index].data()['username']})")
                            : Text("${alldata[index].data()['username']}"),
                        onTap: () {
                          Navigator.of(context).pushNamed("chat_page",
                              arguments: alldata[index].data());
                        },
                        trailing: IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("DELETE"),
                                      content:
                                          Text("Are you sure want to delete"),
                                      actions: [
                                        TextButton(
                                            onPressed: () async {
                                              await FirestoreHelper
                                                  .firestoreHelper
                                                  .deleteUser(
                                                      docId: alldata[index].id);
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Delete"))
                                      ],
                                    );
                                  });
                            },
                            icon: Icon(Icons.delete_outline)),
                      ),
                    ),
                  );
                },
                itemCount: alldata.length,
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
