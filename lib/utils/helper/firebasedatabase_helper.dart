import 'package:chat_app/utils/helper/Auth_helper.dart';
import 'package:chat_app/utils/helper/FCM_notification_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  FirestoreHelper._();
  static final FirestoreHelper firestoreHelper = FirestoreHelper._();

  static final FirebaseFirestore db = FirebaseFirestore.instance;

  // Updated method to include username with email
  Future<void> addAuthenticalUser({
    required String email,
    required String username,
  }) async {
    bool isUserAlreadyExit = false;

    // Check if the user already exists
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await db.collection("users").get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> alldocs =
        querySnapshot.docs;

    alldocs.forEach((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
      Map<String, dynamic> docdata = doc.data();

      if (docdata['email'] == email) {
        isUserAlreadyExit = true;
      }
    });

    // If user doesn't exist, create a new entry
    if (isUserAlreadyExit == false) {
      DocumentSnapshot<Map<String, dynamic>> qs =
          await db.collection("records").doc("users").get();

      Map<String, dynamic>? data = qs.data();

      int id = data!['id'];
      int counter = data['counter'];
      id++;

      String? tokan =
          await FCMNotificationHelper.fCMNotificationHelper.fetchFMCToken();

      // Adding user with email and username
      await db.collection("users").doc("$id").set({
        "email": email,
        "username": username,
        "tokan": tokan,
      });

      counter++;

      await db.collection("records").doc("users").update({
        "id": id,
        "counter": counter,
      });
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllUsers() {
    return db.collection("users").snapshots();
  }

  Future<void> deleteUser({required String docId}) async {
    await db.collection("users").doc(docId).delete();

    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await db.collection("records").doc("users").get();

    int counter = userDoc.data()!['counter'];

    counter--;

    await db.collection("records").doc("users").update({
      "counter": counter,
    });
  }

  Future<void> sendMessage({
    required String receiverEmail,
    required String message,
    required String tokan,
  }) async {
    String senderEmail = AuthHelper.firebaseAuth.currentUser!.email!;
    bool ischatroomexists = false;
    QuerySnapshot<Map<String, dynamic>> quaryanapshot =
        await db.collection("chatrooms").get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> allchatrooms =
        quaryanapshot.docs;
    String? chatroomdId;
    allchatrooms
        .forEach((QueryDocumentSnapshot<Map<String, dynamic>> cahtroom) {
      List users = cahtroom.data()['users'];

      if (users.contains(receiverEmail) && users.contains(senderEmail)) {
        ischatroomexists = true;
        chatroomdId = cahtroom.id;
      }
    });

    if (ischatroomexists == false) {
      DocumentReference<Map<String, dynamic>> docref =
          await db.collection("chatrooms").add({
        "users": [senderEmail, receiverEmail]
      });
      chatroomdId = docref.id;
    }

    await db
        .collection("chatrooms")
        .doc(chatroomdId)
        .collection("messages")
        .add({
      "message": message,
      "senderEmail": senderEmail,
      "receiverEmail": receiverEmail,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  Future<void> deletemessages({
    required String receiverEmail,
    required String messageDocId,
  }) async {
    String? senderEmail = AuthHelper.firebaseAuth.currentUser!.email;

    QuerySnapshot<Map<String, dynamic>> quaryanapshot =
        await db.collection("chatrooms").get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> allchatrooms =
        quaryanapshot.docs;
    String? chatroomdId;
    allchatrooms
        .forEach((QueryDocumentSnapshot<Map<String, dynamic>> cahtroom) {
      List users = cahtroom.data()['users'];

      if (users.contains(receiverEmail) && users.contains(senderEmail)) {
        chatroomdId = cahtroom.id;
      }
    });
    await db
        .collection("chatrooms")
        .doc(chatroomdId)
        .collection("messages")
        .doc(messageDocId)
        .delete();
  }

  Future<void> updatemessages({
    required String receiverEmail,
    required String messageDocId,
    required String message,
  }) async {
    String? senderEmail = AuthHelper.firebaseAuth.currentUser!.email;

    QuerySnapshot<Map<String, dynamic>> quaryanapshot =
        await db.collection("chatrooms").get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> allchatrooms =
        quaryanapshot.docs;
    String? chatroomdId;
    allchatrooms
        .forEach((QueryDocumentSnapshot<Map<String, dynamic>> cahtroom) {
      List users = cahtroom.data()['users'];

      if (users.contains(receiverEmail) && users.contains(senderEmail)) {
        chatroomdId = cahtroom.id;
      }
    });
    await db
        .collection("chatrooms")
        .doc(chatroomdId)
        .collection("messages")
        .doc(messageDocId)
        .update({
      "message": message,
      "updatedTimeStamp": FieldValue.serverTimestamp(),
    });
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> fetchMessages({
    required String receiverEmail,
  }) async {
    String senderEmail = AuthHelper.firebaseAuth.currentUser!.email!;
    QuerySnapshot<Map<String, dynamic>> quaryanapshot =
        await db.collection("chatrooms").get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> allchatrooms =
        quaryanapshot.docs;
    String? chatroomdId;
    allchatrooms
        .forEach((QueryDocumentSnapshot<Map<String, dynamic>> cahtroom) {
      List users = cahtroom.data()['users'];

      if (users.contains(receiverEmail) && users.contains(senderEmail)) {
        chatroomdId = cahtroom.id;
      }
    });

    return db
        .collection("chatrooms")
        .doc(chatroomdId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }
}
