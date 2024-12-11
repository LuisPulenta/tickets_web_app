import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets_web_app/models/models.dart';
import 'package:tickets_web_app/providers/providers.dart';
import 'package:tickets_web_app/services/services.dart';
import 'package:tickets_web_app/ui/buttons/custom_outlined_button.dart';
import 'package:tickets_web_app/ui/cards/white_card.dart';
import 'package:tickets_web_app/ui/inputs/custom_inputs.dart';
import 'package:tickets_web_app/ui/labels/custom_labels.dart';
import 'package:flutter/services.dart';

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

    ticketFormProvider.description = '';

    ticketFormProvider.ticketCab.id = widget.ticketCab?.id ?? 0;
    ticketFormProvider.ticketCab.companyName =
        widget.ticketCab?.companyName ?? '';
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
            //------------- Fila Nuevo Ticket y X de cierre -------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.ticketCab?.companyId.toString() ?? 'Nuevo Ticket',
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
            //----------------- Fila Asunto y Descripción - Imagen ----------------------
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 600,
                            child: TextFormField(
                              onFieldSubmitted: (_) => onFormSubmit(
                                  ticketFormProvider,
                                  token,
                                  userLogged,
                                  companyLogged),
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
                        height: 25,
                      ),
                      SizedBox(
                        height: 100,
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          minLines: null,
                          maxLines: null,
                          expands: true,
                          onFieldSubmitted: (_) => onFormSubmit(
                              ticketFormProvider,
                              token,
                              userLogged,
                              companyLogged),
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
                            ticketFormProvider.description = value;
                          },
                          initialValue: ticketFormProvider.description,
                          decoration: CustomInput.loginInputDecoration(
                            hint: 'Descripción',
                            label: 'Descripción',
                            icon: Icons.comment,
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const _AvatarContainer(),
              ],
            ),
            const SizedBox(
              height: 10,
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
        //Nuevo Ticket
        if (ticketFormProvider.ticketCab.id == 0) {
          final ticketsProvider =
              Provider.of<TicketCabsProvider>(context, listen: false);
          await ticketsProvider
              .newTicketCab(
                ticketFormProvider.ticketCab,
                userLogged,
                companyLogged,
                ticketFormProvider.description,
                ticketFormProvider.photoChanged
                    ? ticketFormProvider.base64Image
                    : '',
              )
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

//-------------------------------------------------------
class _AvatarContainer extends StatefulWidget {
  const _AvatarContainer();

  @override
  State<_AvatarContainer> createState() => _AvatarContainerState();
}

class _AvatarContainerState extends State<_AvatarContainer> {
  PlatformFile? file;

  @override
  Widget build(BuildContext context) {
    final companyFormProvider = Provider.of<CompanyFormProvider>(context);

    Widget image = (companyFormProvider.base64Image != '' &&
            !companyFormProvider.photoChanged)
        ? Image.network(companyFormProvider.base64Image)
        : (file != null)
            ? Image.memory(
                Uint8List.fromList(file!.bytes!),
                width: 250,
                height: 160,
              )
            : const Image(
                image: AssetImage('no-image.jpg'),
              );

    return Stack(
      children: [
        WhiteCard(
          width: 250,
          child: SizedBox(
            width: double.infinity,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Imagen',
                    style: CustomLabels.h2,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: 180,
                    height: 110,
                    child: Stack(
                      children: [
                        Center(
                          child: image,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(companyFormProvider.name,
                      style: const TextStyle(fontWeight: FontWeight.bold))
                ]),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 5),
              borderRadius: BorderRadius.circular(100),
            ),
            child: FloatingActionButton(
              backgroundColor: Colors.indigo,
              elevation: 0,
              child: const Icon(
                Icons.camera_alt_outlined,
                size: 20,
              ),
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['jpg', 'jpeg', 'png'],
                  allowMultiple: false,
                );
                if (result != null) {
                  NotificationsService.showBusyIndicator(context);

                  file = result.files.first;
                  companyFormProvider.photoChanged = true;

                  if (companyFormProvider.photoChanged) {
                    List<int> imageBytes = file!.bytes!;
                    companyFormProvider.base64Image = base64Encode(imageBytes);
                  }

                  setState(() {});

                  Navigator.of(context).pop();
                } else {}
              },
            ),
          ),
        ),
      ],
    );
  }
}
