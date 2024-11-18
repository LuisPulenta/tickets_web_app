import 'package:flutter/material.dart';
import 'package:tickets_web_app/ui/buttons/custom_outlined_button.dart';
import 'package:tickets_web_app/ui/inputs/custom_inputs.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 100),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 370),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  //validator: ,
                  style: const TextStyle(color: Colors.white),
                  decoration: CustomInput.loginInputDecoration(
                    hint: "Ingrese su correo",
                    label: "Correo",
                    icon: Icons.email_outlined,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  //validator: ,
                  style: const TextStyle(color: Colors.white),

                  decoration: CustomInput.loginInputDecoration(
                    hint: "**********",
                    label: "Contraseña",
                    icon: Icons.lock_outline_rounded,
                  ),
                  obscureText: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomOutlinedButton(
                  text: "Ingresar",
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
