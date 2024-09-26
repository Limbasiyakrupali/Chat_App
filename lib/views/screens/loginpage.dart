import 'dart:developer';

import 'package:chat_app/utils/helper/Auth_helper.dart';
import 'package:chat_app/utils/helper/FCM_notification_helper.dart';
import 'package:chat_app/utils/helper/firebasedatabase_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> with WidgetsBindingObserver {
  Future<void> requestpermission() async {
    PermissionStatus notificationpermisionstatus =
        await Permission.notification.request();
    PermissionStatus schedualextraalrampermisionstatus =
        await Permission.scheduleExactAlarm.request();

    log("==================");
    log("$notificationpermisionstatus");
    log("$schedualextraalrampermisionstatus");
    log("==================");
  }

  @override
  void initState() {
    super.initState();
    getFCMtokan();
    requestpermission();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> getFCMtokan() async {
    await FCMNotificationHelper.fCMNotificationHelper.fetchFMCToken();
  }

  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  String? email;
  String? fullname;
  String? password;
  String id = "1";
  String name = "simpal notifications";

  bool istapped = false;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    log("===================");
    log("$state");
    log("===================");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 852,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          "https://w0.peakpx.com/wallpaper/1020/46/HD-wallpaper-whatsapp-cartoon-random-skull-simple-dark-black.jpg"))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Welcome to the Chat App',
                      style: GoogleFonts.getFont(
                        "Mulish",
                        textStyle: TextStyle(
                          color: Colors.white70,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 40, left: 15, right: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('sign up',
                                style: GoogleFonts.getFont(
                                  "Mulish",
                                  textStyle: TextStyle(
                                      fontSize: 25, color: Colors.white70),
                                )),
                            Form(
                              key: signUpFormKey,
                              child: Column(
                                children: [
                                  SizedBox(height: 16),
                                  TextFormField(
                                    controller: nameController,
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "Enter name first...";
                                      }
                                      return null;
                                    },
                                    onSaved: (val) {
                                      fullname = val;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Full Name',
                                      labelStyle:
                                          TextStyle(color: Colors.white70),
                                      hintText: "Enter the name",
                                      hintStyle:
                                          TextStyle(color: Colors.white70),
                                      border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white)),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  TextFormField(
                                    controller: emailController,
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "Enter Email first...";
                                      }
                                      return null;
                                    },
                                    onSaved: (val) {
                                      email = val!;
                                    },
                                    decoration: const InputDecoration(
                                      // filled: true,
                                      // fillColor: Colors.white38,
                                      labelText: 'Email',
                                      labelStyle:
                                          TextStyle(color: Colors.white70),
                                      hintText: "Enter the Email",
                                      hintStyle:
                                          TextStyle(color: Colors.white70),
                                      border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white)),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  SizedBox(height: 16),
                                  TextFormField(
                                    controller: passwordController,
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "Enter password first...";
                                      }
                                      return null;
                                    },
                                    onSaved: (val) {
                                      password = val!;
                                    },
                                    decoration: const InputDecoration(
                                      // filled: true,
                                      // enabled: true,
                                      // fillColor: Colors.white38,
                                      labelText: 'Password',
                                      labelStyle:
                                          TextStyle(color: Colors.white70),
                                      hintText: "Enter the Password",
                                      hintStyle:
                                          TextStyle(color: Colors.white70),
                                      border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white)),
                                    ),
                                    obscureText: true,
                                  ),
                                  SizedBox(height: 16),
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 50, vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (signUpFormKey.currentState!
                                          .validate()) {
                                        signUpFormKey.currentState!.save();
                                        if (email != null && password != null) {
                                          emailController.clear();
                                          passwordController.clear();
                                          Map<String, dynamic> res =
                                              await AuthHelper.authHelper
                                                  .signUpuserwithemailandpassword(
                                            email: email!,
                                            password: password!,
                                          );
                                          if (res['user'] != null) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Sign up successfully..."),
                                              backgroundColor: Colors.green,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            ));
                                          } else if (res['error'] != null) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text("${res['error']}"),
                                              backgroundColor: Colors.red,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            ));
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content:
                                                  Text("Sign up failed..."),
                                              backgroundColor: Colors.red,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            ));
                                          }
                                        }
                                      }
                                    },
                                    child: Text('Sign up',
                                        style: GoogleFonts.getFont(
                                          "Mulish",
                                          textStyle: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white70),
                                        )),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Already have an account?",
                                        style: GoogleFonts.getFont(
                                          "Mulish",
                                          textStyle: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white70),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          AlertBox();
                                        },
                                        child: Text(
                                          "sign In",
                                          style: GoogleFonts.getFont(
                                            "Mulish",
                                            textStyle: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.blue,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Or Continue with",
                        style: GoogleFonts.getFont(
                          "Mulish",
                          textStyle:
                              TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Map<String, dynamic> res =
                              await AuthHelper.authHelper.signInwithGuestuser();
                          if (res['user'] != null) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Sign in successfully..."),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                            ));
                            Navigator.of(context).pushReplacementNamed("/",
                                arguments: res['user']);
                          } else if (res['error'] != null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("${res['error']}"),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                            ));
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Sign in failed..."),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                            ));
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 50,
                                  width: 38,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "https://t3.ftcdn.net/jpg/05/53/79/60/360_F_553796090_XHrE6R9jwmBJUMo9HKl41hyHJ5gqt9oz.jpg"))),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Guest User",
                                  style: GoogleFonts.getFont(
                                    "Mulish",
                                    textStyle: TextStyle(
                                        fontSize: 16, color: Colors.white70),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          Map<String, dynamic> res =
                              await AuthHelper.authHelper.signInwithGoogle();
                          if (res['user'] != null) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Sign In successfully..."),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                            ));
                            User user = res['user'];
                            await FirestoreHelper.firestoreHelper
                                .addAuthenticalUser(
                                    email: user.email!, username: fullname!);
                            Navigator.of(context).pushReplacementNamed("/",
                                arguments: res['user']);
                          } else if (res['error'] != null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("${res['error']}"),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                            ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Sign In failed..."),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                            ));
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 50,
                                  width: 38,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              "https://static-00.iconduck.com/assets.00/google-icon-512x512-wk1c10qc.png"))),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "Google",
                                  style: GoogleFonts.getFont(
                                    "Mulish",
                                    textStyle: TextStyle(
                                        fontSize: 16, color: Colors.white70),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            )
            // Padding(
            //   padding: const EdgeInsets.only(left: 20, top: 80, right: 20),
            //   child: Text(
            //     "Hello! Register to get started",
            //     style: GoogleFonts.getFont(
            //       "Mulish",
            //       textStyle: TextStyle(fontSize: 25),
            //     ),
            //     textAlign: TextAlign.center,
            //   ),
            // ),

            // const SizedBox(
            //   height: 30,
            // ),
            // GestureDetector(
            //   onTap: () async {
            //     await LocalNotificationHelper.localNotificationHelper
            //         .showSimpleNotification(id: id, name: name);
            //   },
            //   child: Container(
            //     height: 50,
            //     width: 220,
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.circular(12),
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.black.withOpacity(0.1),
            //           blurRadius: 10,
            //           offset: Offset(0, 5),
            //         ),
            //       ],
            //     ),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Text(
            //           "Show notifications",
            //           style: GoogleFonts.getFont(
            //             "Mulish",
            //             textStyle: TextStyle(fontSize: 16),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // const SizedBox(
            //   height: 30,
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     GestureDetector(
            //       onTap: () async {
            //         await LocalNotificationHelper.localNotificationHelper
            //             .showBigPictureNotification();
            //       },
            //       child: Container(
            //         height: 50,
            //         width: 170,
            //         decoration: BoxDecoration(
            //           color: Colors.white,
            //           borderRadius: BorderRadius.circular(12),
            //           boxShadow: [
            //             BoxShadow(
            //               color: Colors.black.withOpacity(0.1),
            //               blurRadius: 10,
            //               offset: Offset(0, 5),
            //             ),
            //           ],
            //         ),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             Text(
            //               "Show Big Picture",
            //               style: GoogleFonts.getFont(
            //                 "Mulish",
            //                 textStyle: TextStyle(fontSize: 16),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //     GestureDetector(
            //       onTap: () async {
            //         await LocalNotificationHelper.localNotificationHelper
            //             .showSimpleNotification(id: id, name: name);
            //       },
            //       child: Container(
            //         height: 50,
            //         width: 170,
            //         decoration: BoxDecoration(
            //           color: Colors.white,
            //           borderRadius: BorderRadius.circular(12),
            //           boxShadow: [
            //             BoxShadow(
            //               color: Colors.black.withOpacity(0.1),
            //               blurRadius: 10,
            //               offset: Offset(0, 5),
            //             ),
            //           ],
            //         ),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             Text(
            //               "Show Media Style",
            //               style: GoogleFonts.getFont(
            //                 "Mulish",
            //                 textStyle: TextStyle(fontSize: 16),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }

  void AlertBox() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Sign In",
          ),
          content: Form(
            key: signInFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please enter your email.";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    email = val;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter Email",
                    labelText: "Email",
                    prefixIcon: Icon(
                      Icons.email,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please enter your password.";
                    } else if (val.length <= 6) {
                      return "Password must contain at least 6 characters.";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    password = val;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter Password",
                    labelText: "Password",
                    prefixIcon: Icon(
                      Icons.security,
                    ),
                  ),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                emailController.clear();
                passwordController.clear();
                email = null;
                password = null;
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              onPressed: () async {
                if (signInFormKey.currentState!.validate()) {
                  signInFormKey.currentState!.save();

                  Map<String, dynamic> res = await AuthHelper.authHelper
                      .signInuserwithemailandpassword(
                          email: email!, password: password!);

                  if (res['user'] != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Signed in successfully."),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    User user = res['user'];
                    await FirestoreHelper.firestoreHelper.addAuthenticalUser(
                        email: user.email!, username: fullname!);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/', (route) => false,
                        arguments: res['user']);
                  } else if (res['error'] != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${res['error']}"),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Sign in failed."),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    Navigator.of(context).pop();
                  }

                  emailController.clear();
                  passwordController.clear();
                  email = null;
                  password = null;
                }
              },
              child: Text(
                "Sign In",
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
