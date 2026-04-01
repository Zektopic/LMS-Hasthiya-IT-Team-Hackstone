import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hackston_lms/viewmodels/auth_viewmodel.dart';
import 'dart:async';

// Manually mock FirebaseAuthException
class FakeFirebaseAuthException implements FirebaseAuthException {
  @override
  final String code;
  @override
  final String? message;

  @override
  final String plugin = 'firebase_auth';

  @override
  final StackTrace? stackTrace = null;

  @override
  final String? email;
  @override
  final AuthCredential? credential;
  @override
  final String? tenantId;
  @override
  final String? phoneNumber;

  FakeFirebaseAuthException({
    required this.code,
    this.message,
    this.email,
    this.credential,
    this.tenantId,
    this.phoneNumber,
  });
}

// Mock FirebaseAuth that throws exceptions when signInWithEmailAndPassword is called
class MockFirebaseAuth extends Fake implements FirebaseAuth {
  Object? errorToThrow;

  // Create a StreamController to provide a fake auth state stream
  final _authStateController = StreamController<User?>.broadcast();

  @override
  Stream<User?> authStateChanges() => _authStateController.stream;

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (errorToThrow != null) {
      throw errorToThrow!;
    }
    throw UnimplementedError('Not implemented for success case in this test.');
  }

  void dispose() {
    _authStateController.close();
  }
}

void main() {
  late MockFirebaseAuth mockAuth;
  late AuthViewModel authViewModel;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    authViewModel = AuthViewModel(auth: mockAuth);
  });

  tearDown(() {
    mockAuth.dispose();
  });

  group('AuthViewModel._parseFirebaseError indirect tests', () {
    test('returns "Something went wrong. Please try again." for non-FirebaseAuthException', () async {
      mockAuth.errorToThrow = Exception('Generic Error');

      try {
        await authViewModel.login('test@example.com', 'password');
        fail('Should throw an exception');
      } catch (e) {
        expect(e, 'Something went wrong. Please try again.');
      }
    });

    test('returns correct message for "user-not-found"', () async {
      mockAuth.errorToThrow = FakeFirebaseAuthException(code: 'user-not-found');

      try {
        await authViewModel.login('test@example.com', 'password');
        fail('Should throw an exception');
      } catch (e) {
        expect(e, 'No account found with this email.');
      }
    });

    test('returns correct message for "wrong-password"', () async {
      mockAuth.errorToThrow = FakeFirebaseAuthException(code: 'wrong-password');

      try {
        await authViewModel.login('test@example.com', 'password');
        fail('Should throw an exception');
      } catch (e) {
        expect(e, 'Incorrect password. Please try again.');
      }
    });

    test('returns correct message for "email-already-in-use"', () async {
      mockAuth.errorToThrow = FakeFirebaseAuthException(code: 'email-already-in-use');

      try {
        await authViewModel.login('test@example.com', 'password');
        fail('Should throw an exception');
      } catch (e) {
        expect(e, 'An account already exists with this email.');
      }
    });

    test('returns correct message for "weak-password"', () async {
      mockAuth.errorToThrow = FakeFirebaseAuthException(code: 'weak-password');

      try {
        await authViewModel.login('test@example.com', 'password');
        fail('Should throw an exception');
      } catch (e) {
        expect(e, 'Password is too weak. Use at least 6 characters.');
      }
    });

    test('returns correct message for "invalid-email"', () async {
      mockAuth.errorToThrow = FakeFirebaseAuthException(code: 'invalid-email');

      try {
        await authViewModel.login('test@example.com', 'password');
        fail('Should throw an exception');
      } catch (e) {
        expect(e, 'Please enter a valid email address.');
      }
    });

    test('returns correct message for "too-many-requests"', () async {
      mockAuth.errorToThrow = FakeFirebaseAuthException(code: 'too-many-requests');

      try {
        await authViewModel.login('test@example.com', 'password');
        fail('Should throw an exception');
      } catch (e) {
        expect(e, 'Too many attempts. Please try again later.');
      }
    });

    test('returns correct message for "invalid-credential"', () async {
      mockAuth.errorToThrow = FakeFirebaseAuthException(code: 'invalid-credential');

      try {
        await authViewModel.login('test@example.com', 'password');
        fail('Should throw an exception');
      } catch (e) {
        expect(e, 'Invalid email or password.');
      }
    });

    test('returns exception message or default for unknown code', () async {
      mockAuth.errorToThrow = FakeFirebaseAuthException(code: 'unknown-code', message: 'Some specific error message.');

      try {
        await authViewModel.login('test@example.com', 'password');
        fail('Should throw an exception');
      } catch (e) {
        expect(e, 'Some specific error message.');
      }
    });

    test('returns fallback default for unknown code with no message', () async {
      mockAuth.errorToThrow = FakeFirebaseAuthException(code: 'unknown-code'); // no message

      try {
        await authViewModel.login('test@example.com', 'password');
        fail('Should throw an exception');
      } catch (e) {
        expect(e, 'Authentication failed.');
      }
    });
  });
}
