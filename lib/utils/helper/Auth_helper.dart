import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthHelper {
  AuthHelper._();
  static final AuthHelper authHelper = AuthHelper._();
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static GoogleSignIn googleSignIn = GoogleSignIn();

  Future<Map<String, dynamic>> signInwithGuestuser() async {
    Map<String, dynamic> res = {};
    try {
      UserCredential userCredential = await firebaseAuth.signInAnonymously();
      User? user = userCredential.user;
      res['user'] = user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "network-request-failed":
          res['error'] = "no internet available...";
          break;
        case "operation-not-allowed":
          res['error'] = "this is disabled by admin...";
          break;
        default:
          res['error'] = "${e.code}";
      }
    }
    return res;
  }

  Future<Map<String, dynamic>> signUpuserwithemailandpassword(
      {required String email, required String password}) async {
    Map<String, dynamic> res = {};
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;
      res['user'] = user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "network-request-failed":
          res['error'] = "no internet available...";
          break;
        case "operation-not-allowed":
          res['error'] = "this is disabled by admin...";
          break;
        case "weak-password":
          res['error'] = "password must be grater then 6 letters...";
          break;
        case "email-already-in-use":
          res['error'] = "this email is already exists...";
          break;
        default:
          res['error'] = "${e.code}";
      }
    }
    return res;
  }

  Future<Map<String, dynamic>> signInuserwithemailandpassword({
    required String email,
    required String password,
  }) async {
    Map<String, dynamic> res = {};
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        res['user'] = user;
      } else {
        res['error'] = "User not found.";
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "network-request-failed":
          res['error'] = "No internet connection.";
          break;
        case "operation-not-allowed":
          res['error'] = "Sign in method not allowed.";
          break;
        case "wrong-password":
          res['error'] = "Incorrect password.";
          break;
        case "invalid-email":
          res['error'] = "Invalid email address.";
          break;
        case "user-not-found":
          res['error'] = "No user found with this email.";
          break;
        default:
          res['error'] = "Error: ${e.code}";
      }
    } catch (e) {
      res['error'] = "An unexpected error occurred.";
    }
    return res;
  }

  Future<Map<String, dynamic>> signInwithGoogle() async {
    Map<String, dynamic> res = {};
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;
      res['user'] = user;
    } catch (e) {
      res['error'] = "${e}";
    }
    return res;
  }

  Future<User?> updateUsername(String newUsername) async {
    User? user = firebaseAuth.currentUser;

    if (user != null) {
      await user.updateProfile(displayName: newUsername);
      await user.reload();
      return firebaseAuth.currentUser;
    } else {
      print("No user is signed in");
      return null;
    }
  }

  Future<bool> updatePassword(String newPassword) async {
    User? user = firebaseAuth.currentUser;

    if (user != null) {
      try {
        await user.updatePassword(newPassword);
        await user.reload();
        return true;
      } on FirebaseAuthException catch (e) {
        print("Failed to update password: ${e.message}");
        return false;
      }
    } else {
      print("No user is signed in");
      return false;
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
  }
}
