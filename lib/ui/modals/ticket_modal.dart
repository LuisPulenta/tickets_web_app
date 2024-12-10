import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets_web_app/models/models.dart';
import 'package:tickets_web_app/providers/providers.dart';
import 'package:tickets_web_app/services/services.dart';
import 'package:tickets_web_app/ui/buttons/custom_outlined_button.dart';
import 'package:tickets_web_app/ui/inputs/custom_inputs.dart';
import 'package:tickets_web_app/ui/labels/custom_labels.dart';

class TicketModal extends StatefulWidget {
  final TicketCab? ticketCab;

  const TicketModal({Key? key, this.ticketCab}) : super(key: key);

  @override
  State<TicketModal> createState() => _TicketModalState();
}

class _TicketModalState extends State<TicketModal> {
//---------------------------------------------------------------------------
  int? id;
  late Token token;
  late TicketFormProvider ticketFormProvider;

//---------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    final userBody = LocalStorage.prefs.getString('userBody');
    var decodedJson = jsonDecode(userBody!);
    token = Token.fromJson(decodedJson);

    ticketFormProvider =
        Provider.of<TicketFormProvider>(context, listen: false);

    ticketFormProvider.ticketCab.id = widget.ticketCab?.id ?? 0;
    ticketFormProvider.ticketCab.company = widget.ticketCab?.company ?? '';
  }

//---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final userLogged =
        Provider.of<AuthProvider>(context, listen: false).user!.fullName;
    final companyLogged =
        Provider.of<AuthProvider>(context, listen: false).user!.companyName;

    return Container(
      padding: const EdgeInsets.all(20),
      height: 500,
      width: 300,
      decoration: buildBoxDecoration(),
      child: Form(
        autovalidateMode: AutovalidateMode.always,
        key: ticketFormProvider.formKey,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.ticketCab?.company ?? 'Nuevo Ticket',
                  style: CustomLabels.h1.copyWith(color: Colors.white),
                ),
                IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ],
            ),
            Divider(
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  width: 600,
                  child: TextFormField(
                    onFieldSubmitted: (_) => onFormSubmit(
                        ticketFormProvider, token, userLogged, companyLogged),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Ingrese Asunto";
                      }
                      if (value.length < 3) {
                        return "Mínimo 3 caracteres";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      ticketFormProvider.ticketCab.title = value;
                    },
                    initialValue: widget.ticketCab?.title ?? '',
                    decoration: CustomInput.loginInputDecoration(
                      hint: 'Asunto',
                      label: 'Asunto',
                      icon: Icons.title,
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 80,
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                minLines: null,
                maxLines: null,
                expands: true,
                onFieldSubmitted: (_) => onFormSubmit(
                    ticketFormProvider, token, userLogged, companyLogged),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Ingrese Descripción";
                  }
                  if (value.length < 3) {
                    return "Mínimo 3 caracteres";
                  }
                  return null;
                },
                onChanged: (value) {
                  ticketFormProvider.ticketCab.description = value;
                },
                initialValue: widget.ticketCab?.description ?? '',
                decoration: CustomInput.loginInputDecoration(
                  hint: 'Descripción',
                  label: 'Descripción',
                  icon: Icons.comment,
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              child: CustomOutlinedButton(
                onPressed: () async {
                  onFormSubmit(
                      ticketFormProvider, token, userLogged, companyLogged);
                },
                text: "Guardar",
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //--------------------------------------------------------------------
  void onFormSubmit(TicketFormProvider ticketFormProvider, Token token,
      String userLogged, String companyLogged) async {
    final isValid = ticketFormProvider.validateForm();
    if (isValid) {
      try {
        //Nueva Ticket
        if (ticketFormProvider.ticketCab.id == 0) {
          final ticketsProvider =
              Provider.of<TicketCabsProvider>(context, listen: false);
          await ticketsProvider
              .newTicketCab(
                  ticketFormProvider.ticketCab, userLogged, companyLogged)
              .then((value) => Navigator.of(context).pop());
        } else {
          //Editar Ticket
          final ticketsProvider =
              Provider.of<TicketCabsProvider>(context, listen: false);
          await ticketsProvider
              .updateTicketCab(
                ticketFormProvider.ticketCab,
                userLogged,
              )
              .then((value) => Navigator.of(context).pop());
        }
      } catch (e) {
        NotificationsService.showSnackbarError("No se pudo guardar el Ticket");
      }
    }
  }

  //---------------------------------------------------------------------------
  BoxDecoration buildBoxDecoration() => const BoxDecoration(
          color: Color(0xff0f2041),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
            )
          ]);
}
