import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

// Tujuan awal setelah app dibuka
enum AuthStartDestination {
  onboarding, // belum login sama sekali -> ke onboarding
  vehicleForm, // sudah login, belum punya data kendaraan
  home, // sudah login + sudah punya kendaraan
}

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Simpan instance supaya bisa dipakai untuk logout juga
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookAuth _facebookAuth = FacebookAuth.instance;

  // Helper
  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => _auth.currentUser != null;

  /// Apakah user saat ini punya provider "password" (email & password)?
  bool get currentUserHasPasswordProvider {
    final user = _auth.currentUser;
    if (user == null) return false;
    return user.providerData.any((p) => p.providerId == 'password');
  }

  Future<void> _ensureUserDocument(User user, {String? nameOverride}) async {
    final docRef = _db.collection("users").doc(user.uid);
    final snap = await docRef.get();

    final createdAt = user.metadata.creationTime ?? DateTime.now();

    if (snap.exists) {
      // update info dasar, tapi JANGAN ganti createdAt kalau sudah ada
      await docRef.set({
        "uid": user.uid,
        "email": user.email,
        "name": nameOverride ?? user.displayName ?? "",
      }, SetOptions(merge: true));
    } else {
      // pertama kali bikin doc user
      await docRef.set({
        "uid": user.uid,
        "email": user.email,
        "name": nameOverride ?? user.displayName ?? "",
        "createdAt": createdAt,
      }, SetOptions(merge: true));
    }
  }

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
      await _ensureUserDocument(user, nameOverride: name);

      // Simpan ke Firestore (bisa dipakai untuk cek emailExists / data user)
      await _db.collection("users").doc(user.uid).set({
        "uid": user.uid,
        "email": email,
        "name": name,
        "createdAt": DateTime.now(),
      }, SetOptions(merge: true));
    }

    return user;
  }

  // ===========================
  // FIRESTORE: CHECK EMAIL TERDAFTAR
  // ===========================
  Future<bool> emailExists(String email) async {
    final snap = await _db
        .collection("users")
        .where("email", isEqualTo: email)
        .limit(1)
        .get();

    return snap.docs.isNotEmpty;
  }

  // ===========================
  // RESET PASSWORD
  // ===========================
  Future<void> sendResetPasswordEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // ===========================
  // UBAH / BUAT KATA SANDI
  // ===========================
  /// Mengubah atau membuat kata sandi untuk user saat ini.
  ///
  /// Returns:
  /// - `true`  → sebelumnya user sudah punya password (mode ubah password)
  /// - `false` → sebelumnya user belum punya password (mode buat password baru)
  ///
  /// Throws:
  /// - `FirebaseAuthException('no-user')` jika user null / email null
  /// - `FirebaseAuthException('missing-old-password')` kalau account punya
  ///   password tapi oldPassword tidak diisi
  /// - plus error bawaan Firebase lain (wrong-password, weak-password, dll)
  Future<bool> changeOrCreatePassword({
    String? oldPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      throw FirebaseAuthException(
        code: 'no-user',
        message: 'User tidak ditemukan. Silakan login ulang.',
      );
    }

    final email = user.email!;
    final hasPassword = user.providerData.any(
      (p) => p.providerId == 'password',
    );

    if (hasPassword) {
      if (oldPassword == null || oldPassword.isEmpty) {
        throw FirebaseAuthException(
          code: 'missing-old-password',
          message: 'Kata sandi lama wajib diisi.',
        );
      }

      final cred = EmailAuthProvider.credential(
        email: email,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);
      return true;
    } else {
      final cred = EmailAuthProvider.credential(
        email: email,
        password: newPassword,
      );

      await user.linkWithCredential(cred);
      return false;
    }
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
  // LOGIN GOOGLE
  // ===========================
  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null; // user batal

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    final userCred = await _auth.signInWithCredential(credential);
    final user = userCred.user;

    if (user != null) {
      await _ensureUserDocument(user);
    }
    return userCred.user;
  }

  // ===========================
  // LOGIN FACEBOOK
  // ===========================
  Future<User?> signInWithFacebook() async {
    final LoginResult result = await _facebookAuth.login();

    if (result.status == LoginStatus.cancelled) return null;

    if (result.status != LoginStatus.success) {
      throw FirebaseAuthException(
        code: 'facebook-login-failed',
        message: 'Login Facebook gagal.',
      );
    }

    final accessToken = result.accessToken;
    if (accessToken == null) {
      throw FirebaseAuthException(
        code: 'facebook-no-token',
        message: 'Gagal mendapatkan token Facebook.',
      );
    }

    final userCred = await _auth.signInWithCredential(
      FacebookAuthProvider.credential(accessToken.tokenString),
    );
    final user = userCred.user;

    if (user != null) {
      await _ensureUserDocument(user);
    }
    return userCred.user;
  }

  // ===========================
  // LOGOUT (Firebase + Google + Facebook)
  // ===========================
  Future<void> logout() async {
    // Bersihin session Google
    try {
      await _googleSignIn.signOut();
    } catch (_) {
      // abaikan error kecil
    }

    // Bersihin session Facebook
    try {
      await _facebookAuth.logOut();
    } catch (_) {
      // abaikan juga
    }

    // Terakhir: keluar dari Firebase
    await _auth.signOut();
  }

  // ===========================
  // LOGIKA AWAL SETELAH APP DIBUKA
  // ===========================
  Future<AuthStartDestination> resolveStartDestination() async {
    final user = _auth.currentUser;

    // Belum login sama sekali -> ke onboarding (nanti onboarding -> login)
    if (user == null) {
      return AuthStartDestination.onboarding;
    }

    // Sudah login -> cek apakah sudah punya data kendaraan
    try {
      final hasVehicle = await hasVehicleData(user.uid);

      if (!hasVehicle) {
        return AuthStartDestination.vehicleForm;
      }

      // Sudah login + sudah punya kendaraan
      return AuthStartDestination.home;
    } catch (_) {
      // Kalau gagal cek Firestore, minimal tetap masuk app ke home
      return AuthStartDestination.home;
    }
  }
}
