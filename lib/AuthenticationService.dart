import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Получение текущего пользователя
  User? get currentUser => _auth.currentUser;

  // Поток изменений состояния аутентификации
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Вход по Email и паролю
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Ошибка входа: $e");
      return null;
    }
  }

  // Регистрация нового пользователя
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Ошибка регистрации: $e");
      return null;
    }
  }

  // Выход из аккаунта
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
