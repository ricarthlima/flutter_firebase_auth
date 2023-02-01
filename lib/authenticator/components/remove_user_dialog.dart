import 'package:flutter/material.dart';
import 'package:flutter_firebase_firestore_second/authenticator/services/auth_service.dart';

showRemoverUsuarioDialog(
    {required BuildContext context, required String email}) {
  showDialog(
    context: context,
    builder: (context) {
      TextEditingController senhaController = TextEditingController();
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Confirma remoção?"),
        content: SizedBox(
          height: 140,
          child: Column(
            children: [
              Text("Para confirmar a remoção de $email, digite a senha:"),
              TextFormField(
                controller: senhaController,
                obscureText: true,
                decoration:
                    const InputDecoration(label: Text("Confirme a senha")),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              AuthService()
                  .removerUsuario(senha: senhaController.text)
                  .then((value) => Navigator.pop(context));
            },
            child: const Text(
              "EXCLUIR CONTA",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      );
    },
  );
}
