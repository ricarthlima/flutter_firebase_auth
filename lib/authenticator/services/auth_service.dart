import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> criarUsuario({
    required String email,
    required String senha,
    required String nome,
  }) async {
    try {
      UserCredential credencial = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      await credencial.user?.updateDisplayName(nome);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          return "E-mail em uso, esqueceu sua senha?";
      }

      return e.code;
    }

    return null;
  }

  Future<String?> entrarUsuario(
      {required String email, required String senha}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "user-not-found":
          return "Usuário não encontrado.";

        case "wrong-password":
          return "Senha incorreta.";
      }

      return e.code;
    }

    return null;
  }

  Future<String?> enviarEmailRedefinicao({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on Exception {
      return "Não foi possível enviar o e-mail de redefinição.";
    }

    return null;
  }
}
