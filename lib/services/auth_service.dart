import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Error signing in with email: $e');
      return null;
    }
  }

  // Sign up with email and password
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Create user document in Firestore
      if (result.user != null) {
        await _createUserDocument(result.user!);
      }
      
      return result.user;
    } catch (e) {
      print('Error signing up with email: $e');
      return null;
    }
  }

  // Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      
      // Create user document if it doesn't exist
      if (result.user != null) {
        await _createUserDocument(result.user!);
      }
      
      return result.user;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Create user document in Firestore
  Future<void> _createUserDocument(User user) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      
      if (!userDoc.exists) {
        UserModel userModel = UserModel(
          uid: user.uid,
          email: user.email ?? '',
          displayName: user.displayName,
          createdAt: DateTime.now(),
          portfolioValue: 0.0,
        );
        
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toMap());
      }
    } catch (e) {
      print('Error creating user document: $e');
    }
  }

  // Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }
} 