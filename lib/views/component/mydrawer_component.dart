import 'package:chat_app/utils/helper/Auth_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  final User user;
  MyDrawer({required this.user});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final GlobalKey<FormState> usernameKey = GlobalKey<FormState>();
  final GlobalKey<FormState> passwordKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? userName;
  String? password;

  @override
  void initState() {
    super.initState();
    userName = widget.user.displayName;
  }

  bool isGoogle() {
    for (var data in widget.user.providerData) {
      if (data.providerId == "google.com") {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.black),
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: Container(
              height: 150,
              width: double.infinity,
              color: Colors.black,
              // decoration: BoxDecoration(
              //     image: DecorationImage(
              //         fit: BoxFit.cover,
              //         image: NetworkImage(
              //             "https://images.rawpixel.com/image_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIzLTA3L2pvYjE0NDgtYmFja2dyb3VuZC0wNGEteF8xLmpwZw.jpg"))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: widget.user.isAnonymous ||
                            widget.user.photoURL == null
                        ? NetworkImage(
                            "https://t3.ftcdn.net/jpg/05/53/79/60/360_F_553796090_XHrE6R9jwmBJUMo9HKl41hyHJ5gqt9oz.jpg")
                        : NetworkImage(widget.user.photoURL!) as ImageProvider,
                  ),
                  SizedBox(height: 10),
                  Text(
                    (widget.user.isAnonymous)
                        ? "Guest User"
                        : userName ?? 'Unknown User',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (!widget.user.isAnonymous)
                    Text(
                      "${widget.user.email}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                ],
              ),
            ),
          ),
          (widget.user.isAnonymous || isGoogle())
              ? Container()
              : ListTile(
                  leading: Icon(
                    Icons.lock,
                  ),
                  title: Text(
                    "Change Password",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    showChangePasswordDialog();
                  },
                ),
          ListTile(
            leading: Icon(Icons.lock_outline, color: Colors.grey[800]),
            title: Text(
              "Change Password",
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              showChangePasswordDialog();
            },
          ),
          ListTile(
            leading: Icon(Icons.power_settings_new_outlined,
                color: Colors.grey[800]),
            title: Text(
              "sign Out",
              style: TextStyle(fontSize: 16),
            ),
            onTap: () async {
              await AuthHelper.authHelper.signOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("login", (routes) => false);
            },
          ),
          Spacer(),
        ],
      ),
    );
  }

  void showEditUsernameDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Username"),
          content: Form(
            key: usernameKey,
            child: TextFormField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (val) => val!.isEmpty ? "Enter a username" : null,
              onSaved: (val) => userName = val,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                usernameController.clear();
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              onPressed: () async {
                if (usernameKey.currentState!.validate()) {
                  usernameKey.currentState!.save();
                  User? updatedUser =
                      await AuthHelper.authHelper.updateUsername(userName!);
                  if (updatedUser != null) {
                    setState(() {
                      userName = updatedUser.displayName;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Username updated successfully!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Failed to update username."),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                  usernameController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                "Save",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Change Password"),
          content: Form(
            key: passwordKey,
            child: TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "New Password",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
              validator: (val) => val!.isEmpty ? "Enter a password" : null,
              onSaved: (val) => password = val,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                passwordController.clear();
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              onPressed: () async {
                if (passwordKey.currentState!.validate()) {
                  passwordKey.currentState!.save();
                  bool isUpdated =
                      await AuthHelper.authHelper.updatePassword(password!);
                  if (isUpdated) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Password updated successfully!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Failed to update password."),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                  passwordController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                "Save",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
