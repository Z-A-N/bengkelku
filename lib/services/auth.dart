import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  AuthService._(); // private constructor
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // LOGIN email & password
  Future<User?> login({required String email, required String password}) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }

  // REGISTER
  Future<User?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = cred.user;
    if (user != null) {
      await user.updateDisplayName(name);
    }
    return user;
  }

  // KIRIM LINK RESET PASSWORD
  Future<void> sendResetPasswordEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // CEK APAKAH USER PUNYA DATA KENDARAAN
  Future<bool> hasVehicleData(String uid) async {
    final doc = await _db
        .collection("users")
        .doc(uid)
        .collection("vehicle")
        .doc("main")
        .get();
    return doc.exists;
  }

  // SIMPAN DATA KENDARAAN
  Future<void> saveVehicleData({
    required String uid,
    required String jenis,
    required String nomorPolisi,
    required String? merek,
    required String? model,
    required String? tahun,
    required String? km,
  }) async {
    await _db
        .collection("users")
        .doc(uid)
        .collection("vehicle")
        .doc("main")
        .set({
          "jenis": jenis,
          "nomorPolisi": nomorPolisi,
          "merek": merek,
          "model": model,
          "tahun": tahun,
          "km": km,
          "updatedAt": DateTime.now(),
        }, SetOptions(merge: true));
  }

  // =========================
  // GOOGLE SIGN IN
  // =========================
  Future<User?> signInWithGoogle() async {
    // buka pop up / chooser akun Google
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      // user cancel
      return null;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    final userCred = await _auth.signInWithCredential(credential);
    return userCred.user;
  }

  // =========================
  // FACEBOOK SIGN IN
  // =========================
  Future<User?> signInWithFacebook() async {
    // 1. login Facebook (muncul UI facebook)
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status != LoginStatus.success) {
      // kalau user cancel / error
      throw FirebaseAuthException(
        code: 'facebook-login-failed',
        message: result.message ?? 'Login Facebook dibatalkan atau gagal.',
      );
    }

    // 2. ambil access token
    final accessToken = result.accessToken;

    // 3. buat credential
    final facebookAuthCredential = FacebookAuthProvider.credential(
      accessToken!.tokenString,
    );

    // 4. login ke Firebase
    final userCred = await FirebaseAuth.instance.signInWithCredential(
      facebookAuthCredential,
    );
    return userCred.user;
  }
}
