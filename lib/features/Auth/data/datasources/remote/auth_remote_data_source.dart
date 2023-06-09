import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:uber_clone/features/Auth/data/models/user_model.dart';

abstract class BaseAuthRemoteDataSource {
  Future<void> verifyPhone(
      {required String phone,
      required void Function(PhoneAuthCredential) completed,
      required void Function(FirebaseAuthException) failed,
      required void Function(String, int?) codeSent,
      required void Function(String) codeAutoRetrievalTimeout});
  Future<void> verifyOTP(
      {required String smsCode, required String verificationId});
  Future<void> saveUserInformation({required UserModel userModel});
  Future<String> getImageUrl(String uid);
}

class AuthRemoteDataSource implements BaseAuthRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  AuthRemoteDataSource(
    this._auth,
    this._firestore,
    this._storage,
  );
  @override
  Future<void> verifyPhone(
      {required String phone,
      required void Function(PhoneAuthCredential credential) completed,
      required void Function(FirebaseAuthException exception) failed,
      required void Function(String verificationId, int? forceRsendingToken)
          codeSent,
      required void Function(String verificationId)
          codeAutoRetrievalTimeout}) async {
    await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: completed,
        verificationFailed: failed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  @override
  Future<void> verifyOTP(
      {required String smsCode, required String verificationId}) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    await _auth.signInWithCredential(credential);
  }

  @override
  Future<void> saveUserInformation({required UserModel userModel}) async {
    Future.wait([
      _auth.currentUser!.updateEmail(userModel.email),
      _auth.currentUser!.updatePhotoURL(userModel.image),
      _firestore
          .collection('user')
          .doc(_auth.currentUser!.uid)
          .set(userModel.toJson())
    ]);
  }
    
   @override
     Future<String> getImageUrl(String uid) async {
    final profileImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    File profileImage0 = File(profileImage!.path);
    await _storage
        .ref('UserProfileImages/$uid')
        .putFile(profileImage0);
    return await _storage
        .ref('UserProfileImages/$uid')
        .getDownloadURL();
  }
}
