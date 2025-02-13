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
  late SideMenuProvider sideMenuProvider;

//---------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    final userBody = LocalStorage.prefs.getString('userBody');
    var decodedJson = jsonDecode(userBody!);
    token = Token.fromJson(decodedJson);

    ticketFormProvider =
        Provider.of<TicketFormProvider>(context, listen: false);

    final sideMenuProvider =
        Provider.of<SideMenuProvider>(context, listen: false);

    ticketFormProvider.description = '';

    ticketFormProvider.base64Image = '';

    ticketFormProvider.ticketCab.id = widget.ticketCab?.id ?? 0;
    ticketFormProvider.ticketCab.companyName =
        widget.ticketCab?.companyName ?? '';
    ticketFormProvider.photoChanged = false;

    sideMenuProvider.setAbsorbing(true);

    setState(() {});
  }

//---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final userLogged =
        Provider.of<AuthProvider>(context, listen: false).user!.fullName;
    final companyLogged =
        Provider.of<AuthProvider>(context, listen: false).user!.companyName;

    SideMenuProvider sideMenuProvider2 = Provider.of<SideMenuProvider>(context);

    return Container(
      padding: const EdgeInsets.all(20),
      height: 500,
      width: 300,
      decoration: buildBoxDecoration(),
      child: Form(
        autovalidateMode: AutovalidateMode.disabled,
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
                      sideMenuProvider2.setAbsorbing(false);
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
                                if (value.length > 50) {
                                  return "Máximo 50 caracteres";
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
                            if (value.length > 1000) {
                              return "Máximo 1000 caracteres";
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
    SideMenuProvider sideMenuProvider2 =
        Provider.of<SideMenuProvider>(context, listen: false);
    if (isValid) {
      try {
        //Nuevo Ticket
        if (ticketFormProvider.ticketCab.id == 0) {
          sideMenuProvider2.setAbsorbing(false);
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
                ticketFormProvider.photoChanged
                    ? ticketFormProvider.fileName
                    : '',
                ticketFormProvider.photoChanged
                    ? ticketFormProvider.fileExtension
                    : '',
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
    final ticketFormProvider = Provider.of<TicketFormProvider>(context);

    Widget image = (ticketFormProvider.base64Image != '' &&
            !ticketFormProvider.photoChanged)
        ? Image.network(ticketFormProvider.base64Image)
        : (file != null)
            ? ticketFormProvider.fileExtension == 'pdf'
                ? Image.asset('assets/pdf.png')
                : ticketFormProvider.fileExtension == 'rar'
                    ? Image.asset('assets/rar.png')
                    : ticketFormProvider.fileExtension == 'zip'
                        ? Image.asset('assets/zip.png')
                        : ticketFormProvider.fileExtension == 'xls' ||
                                ticketFormProvider.fileExtension == 'xlsx'
                            ? Image.asset('assets/xls.png')
                            : ticketFormProvider.fileExtension == 'doc' ||
                                    ticketFormProvider.fileExtension == 'docx'
                                ? Image.asset('assets/doc.png')
                                : Image.memory(
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
                    'Archivo',
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
                  SizedBox(
                    width: 140,
                    child: Text(
                      ticketFormProvider.fileName,
                      style: CustomLabels.h3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Text(ticketFormProvider.name,
                  //     style: const TextStyle(fontWeight: FontWeight.bold))
                ]),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: Container(
            width: 45,
            height: 45,
            child: FloatingActionButton(
              backgroundColor: Colors.indigo,
              elevation: 0,
              child: const Icon(
                Icons.file_present_outlined,
                size: 20,
              ),
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: [
                    'rar',
                    'zip',
                    'doc',
                    'docx',
                    'xls',
                    'xlsx',
                    'pdf'
                  ],
                  allowMultiple: false,
                );
                if (result != null) {
                  NotificationsService.showBusyIndicator(context);

                  file = result.files.first;
                  ticketFormProvider.photoChanged = true;
                  ticketFormProvider.fileName = file!.name;
                  ticketFormProvider.fileExtension = file!.extension!;

                  if (ticketFormProvider.photoChanged) {
                    List<int> imageBytes = file!.bytes!;
                    ticketFormProvider.base64Image = base64Encode(imageBytes);
                  }

                  setState(() {});

                  Navigator.of(context).pop();
                } else {}
              },
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Container(
            width: 45,
            height: 45,
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
                  ticketFormProvider.photoChanged = true;
                  ticketFormProvider.fileName = file!.name;
                  ticketFormProvider.fileExtension = file!.extension!;

                  if (ticketFormProvider.photoChanged) {
                    List<int> imageBytes = file!.bytes!;
                    ticketFormProvider.base64Image = base64Encode(imageBytes);
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
