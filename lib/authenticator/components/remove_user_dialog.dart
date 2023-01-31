import 'package:flutter/material.dart';

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
          height: 100,
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
            onPressed: () {},
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
