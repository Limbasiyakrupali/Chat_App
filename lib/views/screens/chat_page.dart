import 'package:chat_app/utils/helper/Auth_helper.dart';
import 'package:chat_app/utils/helper/firebasedatabase_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../utils/helper/FCM_notification_helper.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> receiver =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final TextEditingController chatcontroller = TextEditingController();
    final TextEditingController editingController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: (receiver['email'] == AuthHelper.firebaseAuth.currentUser!.email)
            ? Text(
                "You",
              )
            : Text(
                "${receiver['username']}",
                textAlign: TextAlign.center,
              ),
        centerTitle: true,
      ),
      body: Container(
        // height: 852,
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //         fit: BoxFit.cover,
        //         image: NetworkImage(
        //             "https://w0.peakpx.com/wallpaper/1020/46/HD-wallpaper-whatsapp-cartoon-random-skull-simple-dark-black.jpg"))),
        child: Column(
          children: [
            Expanded(
              flex: 14,
              child: FutureBuilder(
                future: FirestoreHelper.firestoreHelper
                    .fetchMessages(receiverEmail: receiver['email']),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("ERROR: ${snapshot.error}"),
                    );
                  } else if (snapshot.hasData) {
                    Stream<QuerySnapshot<Map<String, dynamic>>>? datastram =
                        snapshot.data;

                    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: datastram,
                      builder: (context, ss) {
                        if (ss.hasError) {
                          return Center(
                            child: Text("ERROR: ${ss.error}"),
                          );
                        } else if (ss.hasData) {
                          QuerySnapshot<Map<String, dynamic>> data = ss.data!;
                          List<QueryDocumentSnapshot<Map<String, dynamic>>>
                              allMessages = data.docs;

                          return allMessages.isEmpty
                              ? Center(child: Text("No Messages..."))
                              : ListView.builder(
                                  reverse: true,
                                  itemCount: allMessages.length,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      mainAxisAlignment: (receiver['email'] !=
                                              allMessages[index]
                                                  .data()['receiverEmail'])
                                          ? MainAxisAlignment.start
                                          : MainAxisAlignment.end,
                                      children: [
                                        (receiver['email'] !=
                                                allMessages[index]
                                                    .data()['receiverEmail'])
                                            ? Chip(
                                                label: Text(
                                                    "${allMessages[index].data()['message']}"),
                                              )
                                            : PopupMenuButton<String>(
                                                onSelected: (val) async {
                                                  if (val == "delete") {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                "Are you sure you want to delete this message?"),
                                                            content: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                        "Cancle")),
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      FirestoreHelper.firestoreHelper.deletemessages(
                                                                          receiverEmail: receiver[
                                                                              'email'],
                                                                          messageDocId:
                                                                              allMessages[index].id);
                                                                    },
                                                                    child: Text(
                                                                        "Delete")),
                                                              ],
                                                            ),
                                                          );
                                                        });
                                                  }
                                                  if (val == "edit") {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                "Edit Message"),
                                                            content: TextField(
                                                              controller:
                                                                  editingController,
                                                              decoration:
                                                                  InputDecoration(
                                                                hintText:
                                                                    "Edit Message...",
                                                                border:
                                                                    OutlineInputBorder(),
                                                              ),
                                                            ),
                                                            actions: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                        "Cancel"),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      FirestoreHelper
                                                                          .firestoreHelper
                                                                          .updatemessages(
                                                                        receiverEmail:
                                                                            receiver['email'],
                                                                        messageDocId:
                                                                            allMessages[index].id,
                                                                        message:
                                                                            editingController.text,
                                                                      );
                                                                    },
                                                                    child: Text(
                                                                        "Update"),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                  }
                                                },
                                                itemBuilder: (context) {
                                                  return [
                                                    PopupMenuItem(
                                                        value: 'edit',
                                                        child: Text("Edit")),
                                                    const PopupMenuItem(
                                                      value: 'delete',
                                                      child: Text('Delete'),
                                                    ),
                                                  ];
                                                },
                                                position:
                                                    PopupMenuPosition.under,
                                                child: Chip(
                                                  label: Text(
                                                      "${allMessages[index].data()['message']}"),
                                                ),
                                              ),
                                      ],
                                    );
                                  },
                                );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: chatcontroller,
                decoration: InputDecoration(
                  hintText: "Message",
                  suffixIcon: IconButton(
                    onPressed: () async {
                      String message = chatcontroller.text;
                      String? token =
                          await FirebaseMessaging.instance.getToken();
                      await FirestoreHelper.firestoreHelper.sendMessage(
                        receiverEmail: receiver['email'],
                        message: message,
                        tokan: token!,
                      );
                      chatcontroller.clear();
                      FCMNotificationHelper.fCMNotificationHelper.sendFCM(
                          title: message,
                          body: AuthHelper.firebaseAuth.currentUser!.email!,
                          tokan: receiver['tokan']);
                    },
                    icon: Icon(Icons.send),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
