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

class RecoverPasswordView extends StatelessWidget {
  const RecoverPasswordView({Key? key}) : super(key: key);

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
                      Text('Recuperar Contraseña',
                          style: GoogleFonts.montserratAlternates(
                              fontSize: 26,
                              color: Colors.white.withOpacity(0.8))),
                      const SizedBox(
                        height: 20,
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
                        height: 20,
                      ),
                      CustomOutlinedButton(
                        text: 'Recuperar Contraseña',
                        onPressed: () {
                          onFormSubmit(loginFormProvider, authProvider);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      LinkText(
                        text: 'Volver al Login',
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, Flurorouter.loginRoute);
                        },
                      ),
                      const SizedBox(
                        height: 20,
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
      authProvider.recoverPassword(loginFormProvider.email);
    }
  }
}
