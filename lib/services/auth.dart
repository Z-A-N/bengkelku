import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ===========================
  // LOGIN EMAIL & PASSWORD
  // ===========================
  Future<User?> login({required String email, required String password}) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }

  // ===========================
  // REGISTER
  // ===========================
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

  // ===========================
  // RESET PASSWORD
  // ===========================
  Future<void> sendResetPasswordEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // ===========================
  // CEK DATA KENDARAAN
  // ===========================
  Future<bool> hasVehicleData(String uid) async {
    final doc = await _db
        .collection("users")
        .doc(uid)
        .collection("vehicle")
        .doc("main")
        .get();

    return doc.exists;
  }

  // ===========================
  // SIMPAN DATA KENDARAAN
  // ===========================
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

  // ===========================
  // GOOGLE SIGN-IN
  // ===========================
  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null; // user cancel

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    final userCred = await _auth.signInWithCredential(credential);
    return userCred.user;
  }

  // ===========================
  // FACEBOOK SIGN-IN
  // ===========================
  Future<User?> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();

    // USER CANCEL LOGIN
    if (result.status == LoginStatus.cancelled) {
      return null;
    }

    // LOGIN GAGAL
    if (result.status != LoginStatus.success) {
      throw FirebaseAuthException(
        code: 'facebook-login-failed',
        message: 'Login Facebook gagal. Coba lagi.',
      );
    }

    final accessToken = result.accessToken;
    if (accessToken == null) {
      throw FirebaseAuthException(
        code: 'facebook-no-token',
        message: 'Gagal mendapatkan token Facebook. Coba lagi.',
      );
    }

    final userCred = await _auth.signInWithCredential(
      FacebookAuthProvider.credential(accessToken.tokenString),
    );

    return userCred.user;
  }
}
