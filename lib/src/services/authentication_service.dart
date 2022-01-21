import 'package:bmind/src/utils/app_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:bmind/src/modals/app_user.dart';
import 'package:bmind/src/modals/current_app_user.dart';
import 'package:bmind/src/services/database_services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  /// Changed to idTokenChanges as it updates depending on more cases.
  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();

  Future<bool> getCurrentUser() async {
    User user = _firebaseAuth.currentUser;
    if (user != null) {
      String userId = user.uid;
      return await CurrentAppUser.currentUserData.getCurrentUserData(userId);
    }
    return false;
  }

  Future<void> signOut() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(CurrentAppUser.currentUserData.uid)
        .update({
      'fcm': '',
    });
    await _firebaseAuth.signOut();
  }

  Future<User> signIn({String email, String password}) async {
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        print("Email: $email");
        if (userCredential.user != null) {
          String fcmTok = await FirebaseMessaging.instance.getToken();
          FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user.uid)
              .update({
            'fcm': fcmTok,
          });
          await CurrentAppUser().getCurrentUserData(userCredential.user.uid);
          return userCredential.user;
        } else {
          return userCredential.user;
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Fluttertoast.showToast(
            msg: 'Email is not Registered!',
            gravity: ToastGravity.BOTTOM,
          );
          print('No user found for that email $e');
        } else if (e.code == 'wrong-password') {
          Fluttertoast.showToast(
            msg: 'Incorrect Password!',
            gravity: ToastGravity.BOTTOM,
          );
          print('Wrong password provided for that user');
        }
      } catch (e) {
        print("Here We got :: Error $e");
        AppUtils.showToast('Unexpected Error $e!');
      }
    } else {
      AppUtils.showToast('Failed! Internet not connected!');
      return null;
    }
  }

  Future<User> signupWithEmail(
      {String email,
      String password,
      String userName,
      String photo,
      double lng,
      double lat,
      String centerName,
      String centerLocaton,
      String phoneNumber,
      String role}) async {
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        UserCredential userCredential = await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);
        String fcmToken = await FirebaseMessaging.instance.getToken();
        if (userCredential.user != null) {
          AppUser appUser = AppUser(
            uid: userCredential.user.uid,
            email: email,
            name: userName,
            createdAt: Timestamp.now(),
            photo: photo,
            centerName: centerName,
            centerLocation: centerLocaton,
            phoneNumber: phoneNumber,
            lng: lng,
            lat: lat,
            role: role,
            fcm: fcmToken,
          );
          if (centerName != null) {
            await DatabaseServices.uploadNewSellerData(appUser);
          } else {
            await DatabaseServices.uploadNewBuyerData(appUser);
          }

          return userCredential.user;
        } else {
          Fluttertoast.showToast(
            msg: 'Upexpected Error, Something went wrong!',
            gravity: ToastGravity.BOTTOM,
          );
        }
        await CurrentAppUser().getCurrentUserData(userCredential.user.uid);
        return userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Fluttertoast.showToast(
            msg: 'Password is too weak!',
            gravity: ToastGravity.BOTTOM,
          );
        } else if (e.code == 'email-already-in-use') {
          Fluttertoast.showToast(
            msg: 'Email already exists!',
            gravity: ToastGravity.BOTTOM,
          );
        }
        return null;
      } catch (e) {
        print("Here we got Error $e");
        Fluttertoast.showToast(
            msg: 'Upexpected Error, Something went wrong!',
            gravity: ToastGravity.BOTTOM);
        return null;
      }
    } else {
      AppUtils.showToast('Failed! Internet not connected!');
      return null;
    }
  }

  //lOGIN WITH GOOGLE
  Future<User> signInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        // 'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    try {
      final GoogleSignInAccount account = await _googleSignIn.signIn();
      final GoogleSignInAuthentication _auth = await account.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: _auth.accessToken,
        idToken: _auth.idToken,
      );
      User user =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;
      if (user != null) {
        DocumentReference userDoc =
            FirebaseFirestore.instance.collection('users').doc('${user.uid}');
        DocumentSnapshot ds = await userDoc.get();
        if (ds.exists) {
          CurrentAppUser.currentUserData.uid = user.uid;
        } else {
          AppUser appUser = AppUser(
            uid: user.uid,
            email: user.email,
            name: user.displayName,
            createdAt: Timestamp.now(),
            photo: user.photoURL,
            fcm: '',
          );
          await DatabaseServices.uploadNewBuyerData(appUser);
        }
        await CurrentAppUser().getCurrentUserData(user.uid);
        return user;
      } else {
        Fluttertoast.showToast(
          msg: 'Upexpected Error, Something went wrong !',
          gravity: ToastGravity.TOP,
        );
        return null;
      }
    } catch (e) {
      print("Yahan tk a gaya hon.: $e");
      Fluttertoast.showToast(
          msg: "Login Failed! $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          fontSize: 16.0);
      return null;
    }
  }
}
