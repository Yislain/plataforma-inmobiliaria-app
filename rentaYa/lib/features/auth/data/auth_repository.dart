import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  // Rol en caché para acceso rápido en toda la UI ('inquilino' o 'propietario')
  String currentRole = 'inquilino';
  String currentUserName = 'Usuario RentaFácil';

  AuthRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Iniciar sesión y cargar rol desde Firestore
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential credential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        await fetchUserRole(credential.user!.uid);
      }
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Registrar usuario guardando su rol ('inquilino' o 'propietario') en Firestore
  Future<User?> createUserWithEmailAndPassword(
    String email,
    String password, {
    String role = 'inquilino',
    String name = '',
  }) async {
    try {
      final UserCredential credential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        final displayName =
            name.trim().isNotEmpty ? name.trim() : email.split('@').first;

        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email.trim(),
          'name': displayName,
          'role': role, // 'inquilino' o 'propietario'
          'createdAt': FieldValue.serverTimestamp(),
        });

        currentRole = role;
        currentUserName = displayName;
      }
      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Consultar el rol del usuario autenticado
  Future<String> fetchUserRole(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        currentRole = doc.data()!['role'] ?? 'inquilino';
        currentUserName = doc.data()!['name'] ?? 'Usuario';
      }
    } catch (_) {
      currentRole = 'inquilino';
    }
    return currentRole;
  }

  Future<void> signOut() async {
    currentRole = 'inquilino';
    await _firebaseAuth.signOut();
  }

  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('No se encontró un usuario con ese correo.');
      case 'wrong-password':
      case 'invalid-credential':
        return Exception('Correo o contraseña incorrectos.');
      case 'email-already-in-use':
        return Exception('El correo ya está registrado.');
      case 'invalid-email':
        return Exception('El formato del correo no es válido.');
      case 'weak-password':
        return Exception('La contraseña debe tener al menos 6 caracteres.');
      default:
        return Exception('Ocurrió un error: ${e.message}');
    }
  }
}