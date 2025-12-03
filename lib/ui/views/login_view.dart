import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/login_form_provider.dart';
import '../../router/router.dart';
import '../buttons/custom_outlined_button.dart';
import '../buttons/link_text.dart';
import '../inputs/custom_inputs.dart';

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
                  autovalidateMode: AutovalidateMode.disabled,
                  key: loginFormProvider.formKey,
                  child: Column(
                    children: [
                      Text('Login',
                          style: GoogleFonts.montserratAlternates(
                              fontSize: 26,
                              color: Colors.white.withOpacity(0.8))),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        onFieldSubmitted: (_) =>
                            onFormSubmit(loginFormProvider, authProvider),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese su correo';
                          }
                          if (!EmailValidator.validate(value)) {
                            return 'El correo no tiene formato válido';
                          }
                          return null;
                        },
                        style: const TextStyle(color: Colors.white),
                        onChanged: (value) {
                          loginFormProvider.email = value;
                        },
                        decoration: CustomInput.loginInputDecoration(
                          hint: 'Ingrese su correo',
                          label: 'Correo',
                          icon: Icons.email_outlined,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        onFieldSubmitted: (_) =>
                            onFormSubmit(loginFormProvider, authProvider),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese su contraseña';
                          }
                          if (value.length < 6) {
                            return 'La contraseña debe tener al menos 6 caracteres';
                          }
                          return null;
                        },
                        style: const TextStyle(color: Colors.white),
                        onChanged: (value) {
                          loginFormProvider.password = value;
                        },
                        decoration: CustomInput.loginInputDecoration(
                          hint: '**********',
                          label: 'Contraseña',
                          icon: Icons.lock_outline_rounded,
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomOutlinedButton(
                        text: 'Ingresar',
                        onPressed: () {
                          onFormSubmit(loginFormProvider, authProvider);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      LinkText(
                        text: 'Olvidé mi contraseña',
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, Flurorouter.recoverPasswordRoute);
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }));
  }

  //--------------------------------------------------------------------
  void onFormSubmit(
      LoginFormProvider loginFormProvider, AuthProvider authProvider) {
    final isValid = loginFormProvider.validateForm();
    if (isValid) {
      authProvider.login(loginFormProvider.email, loginFormProvider.password);
    }
  }
}
