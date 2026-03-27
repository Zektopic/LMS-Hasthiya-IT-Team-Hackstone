import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _token;
  String? get token => _token;

  User? get currentUser => _auth.currentUser;
  String get displayName => currentUser?.displayName ?? 'Learner';
  String get email => currentUser?.email ?? '';
  String? get photoUrl => currentUser?.photoURL;

  // Optimization: Pre-calculate initials when user state changes to avoid expensive
  // string manipulation (split, where, take, map, join) on every UI rebuild
  String _initials = 'U';
  String get initials => _initials;

  AuthViewModel() {
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        _isAuthenticated = false;
        _token = null;
        _initials = 'U';
      } else {
        _isAuthenticated = true;
        _token = user.uid;
        _updateInitials(user.displayName);
      }
      notifyListeners();
    });
  }

  void _updateInitials(String? name) {
    final displayName = name ?? 'Learner';
    final computedInitials = displayName
        .split(' ')
        .where((s) => s.isNotEmpty)
        .take(2)
        .map((s) => s[0])
        .join()
        .toUpperCase();
    _initials = computedInitials.isEmpty ? 'U' : computedInitials;
  }

  String _parseFirebaseError(dynamic e) {
    if (e is! FirebaseAuthException) {
      return 'Something went wrong. Please try again.';
    }
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      default:
        return e.message ?? 'Authentication failed.';
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw _parseFirebaseError(e);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> register(String email, String password, {String? name}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (name != null && name.isNotEmpty) {
        await credential.user?.updateDisplayName(name);
        await credential.user?.reload();
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw _parseFirebaseError(e);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn.instance
          .authenticate();
      if (googleUser == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw _parseFirebaseError(e);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw _parseFirebaseError(e);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {}
    await _auth.signOut();
  }
}
