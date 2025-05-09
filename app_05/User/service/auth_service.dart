import 'package:firebase_auth/firebase_auth.dart';
import '../model/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel(
        id: result.user!.uid,
        username: result.user!.displayName ?? '',
        password: '',
        email: result.user!.email!,
        createdAt: DateTime.now(),
        lastActive: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<UserModel?> signUp(String username, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await result.user!.updateDisplayName(username);
      return UserModel(
        id: result.user!.uid,
        username: username,
        password: '',
        email: email,
        createdAt: DateTime.now(),
        lastActive: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  Future<void> signInWithGoogle() async {
    // Implement Google Sign-In
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}