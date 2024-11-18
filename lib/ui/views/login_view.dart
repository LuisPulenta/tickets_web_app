import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets_web_app/providers/auth_provider.dart';
import 'package:tickets_web_app/providers/login_form_provider.dart';
import 'package:tickets_web_app/ui/buttons/custom_outlined_button.dart';
import 'package:tickets_web_app/ui/inputs/custom_inputs.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return ChangeNotifierProvider(
        create: (_) => LoginFormProvider(),
        child: Builder(builder: (context) {
          final loginFormProvider =
              Provider.of<LoginFormProvider>(context, listen: false);
          return Container(
            margin: const EdgeInsets.only(top: 100),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 370),
                child: Form(
                  autovalidateMode: AutovalidateMode.always,
                  key: loginFormProvider.formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Ingrese su correo";
                          }
                          if (!EmailValidator.validate(value)) {
                            return "El correo no tiene formato válido";
                          }
                          return null;
                        },
                        style: const TextStyle(color: Colors.white),
                        onChanged: (value) {
                          loginFormProvider.email = value;
                        },
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Ingrese su contraseña";
                          }
                          if (value.length < 6) {
                            return "La contraseña debe tener al menos 6 caracteres";
                          }
                          return null;
                        },
                        style: const TextStyle(color: Colors.white),
                        onChanged: (value) {
                          loginFormProvider.password = value;
                        },
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
                        onPressed: () {
                          final isValid = loginFormProvider.validateForm();
                          if (isValid) {
                            authProvider.login(loginFormProvider.email,
                                loginFormProvider.password);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }));
  }
}
