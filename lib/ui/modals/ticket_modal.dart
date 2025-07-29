import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets_web_app/helpers/api_helper.dart';
import 'package:tickets_web_app/models/models.dart';
import 'package:tickets_web_app/providers/providers.dart';
import 'package:tickets_web_app/services/services.dart';
import 'package:tickets_web_app/ui/buttons/custom_outlined_button.dart';
import 'package:tickets_web_app/ui/cards/white_card.dart';
import 'package:tickets_web_app/ui/inputs/custom_inputs.dart';
import 'package:tickets_web_app/ui/labels/custom_labels.dart';
import 'package:flutter/services.dart';

import '../../helpers/constants.dart';

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
  List<Category> _categories = [];
  List<Subcategory> _subcategories = [];

//---------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();

    final userBody = LocalStorage.prefs.getString('tickets-userBody');
    var decodedJson = jsonDecode(userBody!);
    token = Token.fromJson(decodedJson);

    ticketFormProvider =
        Provider.of<TicketFormProvider>(context, listen: false);

    final sideMenuProvider =
        Provider.of<SideMenuProvider>(context, listen: false);

    ticketFormProvider.description = '';

    ticketFormProvider.base64Image = '';

    ticketFormProvider.categoryId = 0;

    ticketFormProvider.subcategoryId = 0;

    ticketFormProvider.ticketCab.id = widget.ticketCab?.id ?? 0;
    ticketFormProvider.ticketCab.companyName =
        widget.ticketCab?.companyName ?? '';
    ticketFormProvider.photoChanged = false;

    sideMenuProvider.setAbsorbing(true);

    _getCategories();

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
              height: 5,
            ),
            //----------------- Fila Asunto y Descripción - Imagen ----------------------
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _showCategory(),
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                          Expanded(
                            child: _showSubcategory(),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 600,
                            child: TextFormField(
                              onFieldSubmitted: (_) => onFormSubmit(
                                ticketFormProvider,
                                token,
                                userLogged,
                                companyLogged,
                              ),
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
                        height: 15,
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
                backGroundColor: colorEnviado,
                onPressed: () async {
                  onFormSubmit(
                    ticketFormProvider,
                    token,
                    userLogged,
                    companyLogged,
                  );
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
  Future<void> _getCategories() async {
    Response response = await ApiHelper.getCategoriesCombo();

    if (!response.isSuccess) {
      NotificationsService.showSnackbarError("Error al cargar las Categorías");
      return;
    }

    setState(() {
      _categories = response.result;
    });
  }

//---------------------------------------------------------------------------
  Widget _showCategory() {
    return Container(
      child: _categories.isEmpty
          ? const Text('Cargando Categorías...')
          : DropdownButtonFormField(
              validator: (value) {
                if (value == 0) {
                  return "Seleccione una Categoría...";
                }
                return null;
              },
              dropdownColor: const Color(0xff0f2041),
              isExpanded: true,
              isDense: true,
              style:
                  TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16),
              items: _getComboCategories(),
              value: ticketFormProvider.categoryId,
              onChanged: (option) {
                setState(() {
                  ticketFormProvider.categoryId = option!;
                  ticketFormProvider.ticketCab.categoryId = option;
                  for (Category category in _categories) {
                    if (category.id == option) {
                      ticketFormProvider.categoryName = category.name;
                      ticketFormProvider.ticketCab.categoryName = category.name;
                    }
                  }
                  ticketFormProvider.subcategoryId = 0;
                  _getSubcategories(option);
                });
              },
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
                prefixIcon:
                    Icon(Icons.category, color: Colors.white.withOpacity(0.5)),
                labelStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                hintText: 'Seleccione una Categoría...',
                labelText: 'Categoría',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
    );
  }

  //---------------------------------------------------------------------------
  List<DropdownMenuItem<int>> _getComboCategories() {
    List<DropdownMenuItem<int>> list = [];
    list.add(const DropdownMenuItem(
      value: 0,
      child: Text('Seleccione una Categoría...'),
    ));

    for (var category in _categories) {
      list.add(DropdownMenuItem(
        value: category.id,
        child: Text(category.name),
      ));
    }
    return list;
  }

  //--------------------------------------------------------------------
  Future<void> _getSubcategories(int categoryId) async {
    Response response = await ApiHelper.getSubcategoriesCombo(categoryId);

    if (!response.isSuccess) {
      NotificationsService.showSnackbarError(
          "Error al cargar las Subcategorías");
      return;
    }

    setState(() {
      _subcategories = response.result;
    });
  }

  //---------------------------------------------------------------------------
  Widget _showSubcategory() {
    return Container(
      child: _categories.isEmpty
          ? const Text('Cargando Subcategorías...')
          : DropdownButtonFormField(
              validator: (value) {
                if (value == 0) {
                  return "Seleccione una Subcategoría...";
                }
                return null;
              },
              dropdownColor: const Color(0xff0f2041),
              isExpanded: true,
              isDense: true,
              style:
                  TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16),
              items: _getComboSubcategories(),
              value: ticketFormProvider.subcategoryId,
              onChanged: (option) {
                setState(() {
                  ticketFormProvider.subcategoryId = option!;
                  ticketFormProvider.ticketCab.subcategoryId = option;
                  for (Subcategory subcategory in _subcategories) {
                    if (subcategory.id == option) {
                      ticketFormProvider.subcategoryName = subcategory.name;
                      ticketFormProvider.ticketCab.subcategoryName =
                          subcategory.name;
                    }
                  }
                });
              },
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
                prefixIcon: Icon(Icons.category_outlined,
                    color: Colors.white.withOpacity(0.5)),
                labelStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                hintText: 'Seleccione una Subcategoría...',
                labelText: 'Subcategoría',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
    );
  }

  //---------------------------------------------------------------------------
  List<DropdownMenuItem<int>> _getComboSubcategories() {
    List<DropdownMenuItem<int>> list = [];
    list.add(const DropdownMenuItem(
      value: 0,
      child: Text('Seleccione una Subcategoría...'),
    ));

    for (var subcategory in _subcategories) {
      list.add(DropdownMenuItem(
        value: subcategory.id,
        child: Text(subcategory.name),
      ));
    }
    return list;
  }

  //--------------------------------------------------------------------
  void onFormSubmit(
    TicketFormProvider ticketFormProvider,
    Token token,
    String userLogged,
    String companyLogged,
  ) async {
    final isValid = ticketFormProvider.validateForm();
    int newTicketCab;
    SideMenuProvider sideMenuProvider2 =
        Provider.of<SideMenuProvider>(context, listen: false);
    if (isValid) {
      try {
        //Nuevo Ticket
        if (ticketFormProvider.ticketCab.id == 0) {
          sideMenuProvider2.setAbsorbing(false);
          final ticketsProvider =
              Provider.of<TicketCabsProvider>(context, listen: false);
          var newTicketCab = await ticketsProvider.newTicketCab(
            ticketFormProvider.ticketCab,
            userLogged,
            companyLogged,
            ticketFormProvider.description,
            ticketFormProvider.photoChanged
                ? ticketFormProvider.base64Image
                : '',
            ticketFormProvider.photoChanged ? ticketFormProvider.fileName : '',
            ticketFormProvider.photoChanged
                ? ticketFormProvider.fileExtension
                : '',
          );

          //------------------ ENVIAR MAIL -------------------------
          final emailLogged =
              Provider.of<AuthProvider>(context, listen: false).user!.email;

          final companyLoggedId =
              Provider.of<AuthProvider>(context, listen: false).user!.companyId;

          String toEmail = "";

          try {
            Response response = await ApiHelper.getMailsAdmin(companyLoggedId);
            EmailResponse emailResponse = response.result;
            toEmail = emailResponse.emails;
          } catch (e) {
            return null;
          }

          Map<String, dynamic> request = {
            'to': toEmail,
            'cc': emailLogged,
            'subject':
                'Nuevo Ticket N° $newTicketCab creado por $userLogged - Categoría: ${ticketFormProvider.categoryName} - Subcategoría: ${ticketFormProvider.subcategoryName}',
            'body': '''
Se ha creado el Ticket N° $newTicketCab <br>
Haga clic aquí --> <a href="https://keypress.serveftp.net/TicketsWeb" style="color: blue;">Ir al ticket</a>
''',
          };

          try {
            Response response = await ApiHelper.sendMail(request);
          } catch (e) {
            return null;
          }

          Navigator.of(context).pop();
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
