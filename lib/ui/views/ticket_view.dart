import 'dart:convert';
import 'dart:typed_data';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../helpers/api_helper.dart';
import '../../helpers/constants.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../services/services.dart';
import '../buttons/custom_outlined_button.dart';
import '../cards/white_card.dart';
import '../inputs/custom_inputs.dart';
import '../labels/custom_labels.dart';
import '../layouts/shared/widgets/loader_component.dart';

class TicketView extends StatefulWidget {
  final String id;

  const TicketView({Key? key, required this.id}) : super(key: key);

  @override
  State<TicketView> createState() => _TicketViewState();
}

class _TicketViewState extends State<TicketView> {
  //----------------------------------------------------------------------
  TicketCab? ticketCab;
  String ticketStateName = 'Enviado';
  late List<TicketDet> ticketDets;
  bool showLoader = false;
  late TicketFormProvider ticketFormProvider;

  late Token token;
  String userTypeLogged = '';
  List<User> _users = [];
  String userIdSelected = '';
  String userNameSelected = '';
  String userLogged = '';
  String companyLogged = '';
  User? userTicket;
  List<Category> _categories = [];
  List<Subcategory> _subcategories = [];
  int categoryId = 0;
  int subcategoryId = 0;

  bool verCambiarCategoria = false;

//----------------------------------------------------------------------
  @override
  void initState() {
    super.initState();

    userLogged =
        Provider.of<AuthProvider>(context, listen: false).user!.fullName;
    companyLogged =
        Provider.of<AuthProvider>(context, listen: false).user!.companyName;

    showLoader = true;

    final userBody = LocalStorage.prefs.getString('tickets-userBody');
    var decodedJson = jsonDecode(userBody!);
    token = Token.fromJson(decodedJson);
    userTypeLogged = token.user.userTypeName;
    final ticketCabsProvider =
        Provider.of<TicketCabsProvider>(context, listen: false);
    ticketFormProvider =
        Provider.of<TicketFormProvider>(context, listen: false);
    ticketDets = [];

    ticketFormProvider.description = '';

    ticketFormProvider.base64Image = '';

    ticketCabsProvider.getTicketCabById(widget.id).then((ticketCabDB) {
      setState(
        () {
          ticketCab = ticketCabDB;
          categoryId = ticketCab!.categoryId;
          subcategoryId = ticketCab!.subcategoryId;
          ticketDets =
              ticketCab!.ticketDets != null ? ticketCab!.ticketDets! : [];
          if (ticketCab!.ticketState == 0) {
            ticketStateName = 'Enviado';
          }
          if (ticketCab!.ticketState == 1) {
            ticketStateName = 'Devuelto';
          }

          if (ticketCab!.ticketState == 2) {
            ticketStateName = 'Asignado';
          }

          if (ticketCab!.ticketState == 3) {
            ticketStateName = 'En Curso';
          }

          if (ticketCab!.ticketState == 4) {
            ticketStateName = 'Resuelto';
          }
          if (ticketCab!.ticketState == 5) {
            ticketStateName = 'Derivado';
          }
          if (ticketCab!.ticketState == 7) {
            ticketStateName = 'Autorizar';
          }
          if (ticketCab!.ticketState == 8) {
            ticketStateName = 'Autorizado';
          }
          if (ticketCab!.ticketState == 9) {
            ticketStateName = 'Rechazado';
          }
        },
      );
      _getUsers();
      showLoader = false;
      setState(() {});
    });
  }

  //--------------------------------------------------------------------
  Future<void> _getUsers() async {
    final companyLoggedId =
        Provider.of<AuthProvider>(context, listen: false).user!.companyId;

    Response response = await ApiHelper.getUsersCombo(companyLoggedId);

    if (!response.isSuccess) {
      NotificationsService.showSnackbarError('Error al cargar los Usuarios');
      return;
    }

    setState(() {
      _users = response.result;
    });

    await _getUserTicket(ticketCab!.createUserId);
  }

  //--------------------------------------------------------------------
  Future<void> _getUserTicket(String userId) async {
    Response response = await ApiHelper.getUser(userId);

    if (!response.isSuccess) {
      NotificationsService.showSnackbarError(
          'Error buscar el Usuario del Ticket');
      return;
    }

    setState(() {
      userTicket = response.result;
    });

    await _getCategories();
  }

  //---------------------------------------------------------------------------
  List<String> _getComboUsers() {
    List<String> list = [];
    //list.add('Seleccione un Usuario...');

    for (var user in _users) {
      if (user.isResolver == 1) {
        list.add(user.fullName);
      }
    }
    return list;
  }

  //---------------------------------------------------------------------------
  Widget _showUser() {
    return SizedBox(
      width: 300,
      child: _users.isEmpty
          ? const Text('Cargando Usuarios...')
          : DropdownSearch<String>(
              items: _getComboUsers(),
              popupProps: PopupProps.menu(
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor:
                        Colors.grey.shade200, // Fondo de la caja de búsqueda
                    hintText: 'Buscar...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                itemBuilder: (context, item, isSelected) {
                  return Container(
                    color: isSelected
                        ? colorDerivado
                        : colorDerivado
                            .withOpacity(0.5), // fondo de cada opción
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      item,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.yellow
                            : Colors.white, // color del texto
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                },
                menuProps: MenuProps(
                  backgroundColor: colorDerivado, // Fondo del menú desplegable
                ),
              ),
              dropdownDecoratorProps: DropDownDecoratorProps(
                baseStyle: const TextStyle(color: Colors.white, fontSize: 16),
                dropdownSearchDecoration: InputDecoration(
                  fillColor: colorDerivado,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  filled: true,
                  //isDense: true,
                  labelStyle:
                      const TextStyle(color: Colors.white, fontSize: 16),

                  labelText: 'Usuario',
                  hintText: 'Seleccione un Usuario...',
                ),
              ),
              onChanged: (option) {
                setState(() {
                  userNameSelected = option!;

                  for (User user in _users) {
                    if (userNameSelected == user.fullName) {
                      userIdSelected = user.id;
                    }
                  }
                  ticketFormProvider.userAsign = userIdSelected;
                  ticketFormProvider.userAsignName = userNameSelected;
                });
              },
            ),
    );
  }

//----------------------------------------------------------------------------------
  void onFormSubmit(
    TicketFormProvider ticketFormProvider,
    String userLogged,
    String companyLogged,
    int estado,
  ) async {
    if (estado == 5 && userIdSelected == '') {
      NotificationsService.showSnackbarError('Debe seleccionar un Usuario');
      return;
    }

    try {
      final ticketsCabsProvider2 =
          Provider.of<TicketCabsProvider>(context, listen: false);

      Response response = await ApiHelper.getUser(ticketCab!.createUserId);
      User userTicket = response.result;
      if (estado == 7 && (userTicket.bossAsign == '')) {
        NotificationsService.showSnackbarError(
            'El Usuario que generó el Ticket no tiene Jefe asignado para que lo pueda autorizar');
        return;
      }
      String emailUserTicket = userTicket.email;
      String emailUserSelected = '';
      if (userIdSelected != '') {
        Response response2 = await ApiHelper.getUser(userIdSelected);
        User userSelected = response2.result;
        emailUserSelected = userSelected.email;
      }
      if (estado == 7) {
        ticketFormProvider.userAuthorize = userTicket.bossAsign;
        ticketFormProvider.userAuthorizeName = userTicket.bossAsignName;
        Response response3 =
            await ApiHelper.getUser(ticketFormProvider.userAuthorize);
        User userSelected = response3.result;
        emailUserSelected = userSelected.email;
      }

      ticketFormProvider.userAsign == '';
      ticketFormProvider.userAsignName == '';

      await ticketsCabsProvider2
          .newTicketDet(
        ticketCab!,
        userLogged,
        companyLogged,
        ticketFormProvider.description,
        ticketFormProvider.photoChanged ? ticketFormProvider.base64Image : '',
        estado,
        ticketFormProvider.userAsign,
        ticketFormProvider.userAsignName,
        ticketFormProvider.userAuthorize,
        ticketFormProvider.userAuthorizeName,
        ticketFormProvider.photoChanged ? ticketFormProvider.fileName : '',
        ticketFormProvider.photoChanged ? ticketFormProvider.fileExtension : '',
      )
          .then((value) {
        Provider.of<TicketCabsProvider>(context, listen: false)
            .getTicketCabById(widget.id)
            .then(
              (ticketCabDB) => setState(
                () {
                  ticketCab = ticketCabDB;

                  ticketDets = ticketCab!.ticketDets != null
                      ? ticketCab!.ticketDets!
                      : [];

                  if (estado == 0) {
                    ticketStateName = 'Enviado';
                  }

                  if (estado == 1) {
                    ticketStateName = 'Devuelto';
                  }

                  if (estado == 2) {
                    ticketStateName = 'Asignado';
                  }

                  if (estado == 3) {
                    ticketStateName = 'En Curso';
                  }

                  if (estado == 4) {
                    ticketStateName = 'Resuelto';
                  }

                  if (estado == 5) {
                    ticketStateName = 'Derivado';
                  }

                  if (estado == 7) {
                    ticketStateName = 'Autorizar';
                  }

                  _sendEmail(
                      estado,
                      ticketCab!.id,
                      emailUserTicket,
                      emailUserSelected,
                      ticketCab!.companyId,
                      ticketCab!.categoryName,
                      ticketCab!.subcategoryName);
                  ticketFormProvider.description = '';
                },
              ),
            );
      });
    } catch (e) {
      NotificationsService.showSnackbarError('No se pudo guardar el Ticket');
    }
  }

  //----------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return showLoader ||
            userTicket == null ||
            _categories.isEmpty ||
            _subcategories.isEmpty
        ? const Center(child: LoaderComponent(text: 'Por favor espere...'))
        : _getContent();
  }

//------------------------------ _getContent --------------------------
  Widget _getContent() {
    return Column(
      children: <Widget>[
        ticketDets.isEmpty
            ? Expanded(child: _noContent())
            : Expanded(child: _getListView()),
      ],
    );
  }

//------------------------------ _noContent -----------------------------
  Widget _noContent() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: const Center(
        child: Text(
          'No hay registros en este Ticket',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  //------------------------------ _getListView ---------------------------

  Widget _getListView() {
    return Stack(
      children: [
        Column(
          children: [
            //------------- CABECERA TICKET ---------------------
            SizedBox(
              width: double.infinity,
              height: 180,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  side: const BorderSide(
                    color: Colors.black,
                    width: 0.5,
                  ),
                ),
                color: const Color.fromARGB(255, 12, 133, 160),
                shadowColor: Colors.white,
                elevation: 10,
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Center(
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 350,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text('Creado por: ',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.white60,
                                              fontSize: 14)),
                                      Expanded(
                                        child: Text(ticketCab!.createUserName,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text('Teléfono: ',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.white60,
                                              fontSize: 14)),
                                      Expanded(
                                        child: Text(userTicket!.phoneNumber,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text('Sucursal: ',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.white60,
                                              fontSize: 14)),
                                      Expanded(
                                        child: Text(userTicket!.branchName,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text('Jefe: ',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.white60,
                                              fontSize: 14)),
                                      Expanded(
                                        child: Text(userTicket!.bossAsignName,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text('Empresa: ',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.white60,
                                              fontSize: 14)),
                                      Expanded(
                                        child: Text(ticketCab!.companyName,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text('Fecha: ',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.white60,
                                              fontSize: 14)),
                                      Text(
                                          DateFormat('dd/MM/yyyy').format(
                                              DateTime.parse(ticketCab!
                                                  .createDate
                                                  .toString())),
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text('Hora: ',
                                          style: TextStyle(
                                              color: Colors.white60,
                                              fontSize: 14)),
                                      Text(
                                          DateFormat('hh:mm').format(
                                              DateTime.parse(ticketCab!
                                                  .createDate
                                                  .toString())),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Text('Categoría: ',
                                                  style: TextStyle(
                                                      color: Colors.white60,
                                                      fontSize: 14)),
                                              Text(ticketCab!.categoryName,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14)),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Text('Subcategoría: ',
                                                  style: TextStyle(
                                                      color: Colors.white60,
                                                      fontSize: 14)),
                                              Text(ticketCab!.subcategoryName,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14)),
                                            ],
                                          ),
                                        ],
                                      ),
                                      if (!verCambiarCategoria)
                                        IconButton(
                                          icon: const Icon(
                                            Icons.refresh_outlined,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            verCambiarCategoria = true;
                                            setState(() {});
                                          },
                                        )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          if (verCambiarCategoria)
                            SizedBox(
                                width: 250,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Text(
                                              'Cambiar Categ. y Subcateg.',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.save,
                                              color: Colors.white),
                                          onPressed: () async {
                                            final ticketsCabsProvider2 =
                                                Provider.of<TicketCabsProvider>(
                                                    context,
                                                    listen: false);

                                            ticketCab!.categoryId = categoryId;
                                            for (Category c in _categories) {
                                              if (c.id == categoryId) {
                                                ticketCab!.categoryName =
                                                    c.name;
                                              }
                                            }
                                            ticketCab!.subcategoryId =
                                                subcategoryId;
                                            for (Subcategory s
                                                in _subcategories) {
                                              if (s.id == subcategoryId) {
                                                ticketCab!.subcategoryName =
                                                    s.name;
                                              }
                                            }

                                            if (subcategoryId == 0) {
                                              NotificationsService
                                                  .showSnackbarError(
                                                      'Debe seleccionar una Subcategoría');
                                              return;
                                            }

                                            await ticketsCabsProvider2
                                                .changeCategory(ticketCab!);
                                            verCambiarCategoria = false;
                                            setState(() {});
                                          },
                                        )
                                      ],
                                    ),
                                    const Divider(color: Colors.grey),
                                    _showCategory(),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    _showSubcategory(),
                                  ],
                                )),
                          SizedBox(
                            height: 60,
                            child: Center(
                              child: Container(
                                margin: const EdgeInsetsDirectional.only(
                                    start: 10.0, end: 10.0),
                                width: 0.5,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'TICKET N°: ${ticketCab?.id} - ${ticketCab?.title} - Detalles: ${ticketDets.length}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 60,
                            child: Center(
                              child: Container(
                                margin: const EdgeInsetsDirectional.only(
                                    start: 10.0, end: 10.0),
                                width: 0.5,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text('Estado: ',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.white60,
                                              fontSize: 14)),
                                      Expanded(
                                        child:
                                            CustomChip(estado: ticketStateName),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: const [
                                      Text(' ',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.white60,
                                              fontSize: 14)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text('Fec. Asignación: ',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.white60,
                                              fontSize: 14)),
                                      Expanded(
                                        child: Text(
                                            ticketCab!.asignDate != null
                                                ? DateFormat('dd/MM/yyyy')
                                                    .format(DateTime.parse(
                                                        ticketCab!.asignDate
                                                            .toString()))
                                                : '',
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text('Derivado a: ',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.white60,
                                              fontSize: 14)),
                                      Expanded(
                                        child: Text(ticketCab!.userAsignName,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text('Fec. En Curso: ',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.white60,
                                              fontSize: 14)),
                                      Expanded(
                                        child: Text(
                                            ticketCab!.inProgressDate != null
                                                ? DateFormat('dd/MM/yyyy')
                                                    .format(DateTime.parse(
                                                        ticketCab!
                                                            .inProgressDate
                                                            .toString()))
                                                : '',
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text('Fecha Fin: ',
                                          style: TextStyle(
                                              color: Colors.white60,
                                              fontSize: 14)),
                                      Expanded(
                                        child: Text(
                                            ticketCab!.finishDate != null
                                                ? DateFormat('dd/MM/yyyy')
                                                    .format(DateTime.parse(
                                                        ticketCab!.finishDate
                                                            .toString()))
                                                : '',
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 5,
                        right: 10,
                        child: InkWell(
                          onTap: () {
                            NavigationServices.replaceTo('/dashboard/tickets');
                          },
                          child: const Text('X',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            //------------- DETALLES TICKET ---------------------
            Expanded(
              // SizedBox(
              //   height: 300,
              child: ListView(
                children: ticketDets.map((e) {
                  var extension = e.imageFullPath.substring(
                      e.imageFullPath.length - 3, e.imageFullPath.length);

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      side: const BorderSide(
                        color: Colors.black,
                        width: 0.5,
                      ),
                    ),
                    color: Colors.white,
                    shadowColor: Colors.white,
                    elevation: 10,
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Container(
                      margin: const EdgeInsets.all(0),
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 200,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Text('Fecha: ',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 3, 30, 184),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                DateFormat('dd/MM/yyyy').format(
                                                    DateTime.parse(e.stateDate
                                                        .toString())),
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12)),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Text('Hora: ',
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 3, 30, 184),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                DateFormat('hh:mm').format(
                                                    DateTime.parse(e.stateDate
                                                        .toString())),
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12)),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Text('Usuario: ',
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 3, 30, 184),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Expanded(
                                              child: Text(e.stateUserName,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 60,
                                    child: Center(
                                      child: Container(
                                        margin:
                                            const EdgeInsetsDirectional.only(
                                                start: 10.0, end: 10.0),
                                        width: 0.5,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SelectableText(e.description,
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 12)),
                                  ),
                                  (e.image != null)
                                      ? SizedBox(
                                          height: 60,
                                          child: Center(
                                            child: Container(
                                              margin:
                                                  const EdgeInsetsDirectional
                                                          .only(
                                                      start: 10.0, end: 10.0),
                                              width: 0.5,
                                              color: Colors.black,
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  //---------------------- Imagen -------------------------------
                                  (e.image == null)
                                      ? Container()
                                      : InkWell(
                                          onTap: () async {
                                            (extension.toUpperCase() == 'PNG' ||
                                                    extension.toUpperCase() ==
                                                        'JPG' ||
                                                    extension.toUpperCase() ==
                                                        'JPEG')
                                                ? NotificationsService
                                                    .showImage(context,
                                                        e.imageFullPath)
                                                : await NotificationsService
                                                    .downLoadFile(
                                                        e.imageFullPath);
                                          },
                                          child: extension.toUpperCase() ==
                                                  'PDF'
                                              ? const Image(
                                                  image: AssetImage('pdf.png'),
                                                  width: 35,
                                                  height: 35,
                                                )
                                              : extension.toUpperCase() == 'RAR'
                                                  ? const Image(
                                                      image:
                                                          AssetImage('rar.png'),
                                                      width: 35,
                                                      height: 35,
                                                    )
                                                  : extension.toUpperCase() ==
                                                          'ZIP'
                                                      ? const Image(
                                                          image: AssetImage(
                                                              'zip.png'),
                                                          width: 35,
                                                          height: 35,
                                                        )
                                                      : extension.toUpperCase() ==
                                                              'DOC'
                                                          ? const Image(
                                                              image: AssetImage(
                                                                  'doc.png'),
                                                              width: 35,
                                                              height: 35,
                                                            )
                                                          : extension.toUpperCase() ==
                                                                  'OCX'
                                                              ? const Image(
                                                                  image: AssetImage(
                                                                      'doc.png'),
                                                                  width: 35,
                                                                  height: 35,
                                                                )
                                                              : extension.toUpperCase() ==
                                                                      'XLS'
                                                                  ? const Image(
                                                                      image: AssetImage(
                                                                          'xls.png'),
                                                                      width: 35,
                                                                      height:
                                                                          35,
                                                                    )
                                                                  : extension.toUpperCase() ==
                                                                          'LSX'
                                                                      ? const Image(
                                                                          image:
                                                                              AssetImage('xls.png'),
                                                                          width:
                                                                              35,
                                                                          height:
                                                                              35,
                                                                        )
                                                                      : FadeInImage
                                                                          .assetNetwork(
                                                                          placeholder:
                                                                              'loader.gif',
                                                                          image:
                                                                              e.imageFullPath,
                                                                          width:
                                                                              35,
                                                                          height:
                                                                              35,
                                                                        ),
                                        ),

                                  SizedBox(
                                    height: 60,
                                    child: Center(
                                      child: Container(
                                        margin:
                                            const EdgeInsetsDirectional.only(
                                                start: 10.0, end: 10.0),
                                        width: 0.5,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: CustomChip(estado: e.ticketState),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            //------------- PIE TICKET ---------------------

            //---------- Formulario para generar nuevo Ticket Detalle ----------
            ((userTypeLogged == 'User' &&
                        (ticketCab!.ticketState == 1 ||
                            ticketCab!.ticketState == 8 ||
                            (ticketCab!.ticketState == 5 &&
                                ticketCab!.userAsignName == userLogged))) ||
                    (userTypeLogged == 'User' &&
                        (ticketCab!.ticketState == 7 &&
                            ticketCab!.userAuthorize == token.user.id)) ||
                    (userTypeLogged == 'Admin' &&
                        (ticketCab!.ticketState == 0)) ||
                    (userTypeLogged == 'AdminKP' &&
                        (ticketCab!.ticketState == 2 ||
                            ticketCab!.ticketState == 3)))
                ? SizedBox(
                    height: 280,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        side: const BorderSide(
                          color: Colors.black,
                          width: 0.5,
                        ),
                      ),
                      color: const Color.fromARGB(255, 12, 133, 160),
                      shadowColor: Colors.white,
                      elevation: 10,
                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Form(
                        autovalidateMode: AutovalidateMode.always,
                        key: ticketFormProvider.formKey,
                        child: Column(
                          children: [
                            //-------------- Descripcion --------------------
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      color: Colors.white,
                                      height: 100,
                                      child: TextFormField(
                                        keyboardType: TextInputType.multiline,
                                        minLines: null,
                                        maxLines: null,
                                        expands: true,
                                        onChanged: (value) {
                                          ticketFormProvider.description =
                                              value;
                                        },
                                        initialValue: '',
                                        cursorColor: Colors.black,
                                        decoration:
                                            CustomInput.loginInputDecoration(
                                          hint: '',
                                          label: 'Escriba un mensaje',
                                          icon: Icons.comment,
                                          iconColor: Colors.black,
                                        ),
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  const _AvatarContainer(),
                                ],
                              ),
                            ),
                            //------------ Botones ---------------
                            Container(
                              height: 60,
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //---------- Botón Enviar ----------
                                  (userTypeLogged == 'User' &&
                                          ticketCab!.ticketState == 1)
                                      ? SizedBox(
                                          width: 200,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: CustomOutlinedButton(
                                              isFilled: true,
                                              backGroundColor: colorEnviado,
                                              onPressed: () async {
                                                onFormSubmit(
                                                    ticketFormProvider,
                                                    userLogged,
                                                    companyLogged,
                                                    0);
                                              },
                                              text: 'Enviar',
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      : Container(),

                                  //---------- Botón Devolver ----------
                                  ((userTypeLogged == 'User' &&
                                              (ticketCab!.ticketState == 5 ||
                                                  ticketCab!.ticketState ==
                                                      8)) ||
                                          (userTypeLogged == 'Admin' &&
                                              ticketCab!.ticketState == 0) ||
                                          (userTypeLogged == 'AdminKP' &&
                                              ticketCab!.ticketState == 2) ||
                                          (userTypeLogged == 'AdminKP' &&
                                              ticketCab!.ticketState == 3))
                                      ? SizedBox(
                                          width: 200,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: CustomOutlinedButton(
                                              isFilled: true,
                                              backGroundColor: colorDevuelto,
                                              onPressed: () async {
                                                onFormSubmit(
                                                    ticketFormProvider,
                                                    userLogged,
                                                    companyLogged,
                                                    1);
                                              },
                                              text: 'Devolver',
                                              color: Colors.black,
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  (userTypeLogged == 'Admin' &&
                                          ticketCab!.ticketState == 0)
                                      ? const Text('-',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold))
                                      : Container(),

                                  //---------- Botón Devolver al Admin ----------
                                  (userTypeLogged == 'User' &&
                                          (ticketCab!.ticketState == 5 ||
                                              ticketCab!.ticketState == 8))
                                      ? SizedBox(
                                          width: 200,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: CustomOutlinedButton(
                                              isFilled: true,
                                              backGroundColor: colorEnviado,
                                              onPressed: () async {
                                                onFormSubmit(
                                                    ticketFormProvider,
                                                    userLogged,
                                                    companyLogged,
                                                    0);
                                              },
                                              text: 'Dev. a Admin',
                                              color: Colors.black,
                                            ),
                                          ),
                                        )
                                      : Container(),

                                  //---------- Botón Solic. Autoriz ----------
                                  (userTypeLogged == 'User' &&
                                          ticketCab!.ticketState == 5)
                                      ? SizedBox(
                                          width: 200,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: CustomOutlinedButton(
                                              isFilled: true,
                                              backGroundColor: colorAutorizar,
                                              onPressed: () async {
                                                onFormSubmit(
                                                    ticketFormProvider,
                                                    userLogged,
                                                    companyLogged,
                                                    7);
                                              },
                                              text: 'Solic. Autoriz',
                                              color: Colors.black,
                                            ),
                                          ),
                                        )
                                      : Container(),

                                  (userTypeLogged == 'Admin' &&
                                          ticketCab!.ticketState == 0)
                                      ? const Text('-  ',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold))
                                      : Container(),

                                  //---------- Botón Autorizar ----------
                                  (userTypeLogged == 'User' &&
                                          ticketCab!.ticketState == 7 &&
                                          ticketCab!.userAuthorize ==
                                              token.user.id)
                                      ? SizedBox(
                                          width: 200,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: CustomOutlinedButton(
                                              isFilled: true,
                                              backGroundColor: colorAutorizado,
                                              onPressed: () async {
                                                onFormSubmit(
                                                    ticketFormProvider,
                                                    userLogged,
                                                    companyLogged,
                                                    8);
                                              },
                                              text: 'Autorizar',
                                              color: Colors.black,
                                            ),
                                          ),
                                        )
                                      : Container(),

                                  //---------- Botón Rechazar ----------
                                  (userTypeLogged == 'User' &&
                                          ticketCab!.ticketState == 7 &&
                                          ticketCab!.userAuthorize ==
                                              token.user.id)
                                      ? SizedBox(
                                          width: 200,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: CustomOutlinedButton(
                                              isFilled: true,
                                              backGroundColor: colorRechazado,
                                              onPressed: () async {
                                                onFormSubmit(
                                                    ticketFormProvider,
                                                    userLogged,
                                                    companyLogged,
                                                    9);
                                              },
                                              text: 'Rechazar',
                                              color: Colors.black,
                                            ),
                                          ),
                                        )
                                      : Container(),

                                  //---------- Botón Asignar ----------
                                  (userTypeLogged == 'Admin' &&
                                          ticketCab!.ticketState == 0)
                                      ? SizedBox(
                                          width: 200,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: CustomOutlinedButton(
                                              isFilled: true,
                                              backGroundColor: colorAsignado,
                                              onPressed: () async {
                                                onFormSubmit(
                                                    ticketFormProvider,
                                                    userLogged,
                                                    companyLogged,
                                                    2);
                                              },
                                              text: 'Asignar a KP',
                                              color: Colors.black,
                                            ),
                                          ),
                                        )
                                      : Container(),

                                  (userTypeLogged == 'Admin' &&
                                          ticketCab!.ticketState == 0)
                                      ? const Text('-  ',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold))
                                      : Container(),
                                  //---------- Botón Derivar ----------

                                  SizedBox(
                                    width: 300,
                                    child: userTypeLogged == 'Admin' &&
                                            ticketCab!.ticketState == 0
                                        ? _showUser()
                                        : Container(),
                                  ),

                                  (userTypeLogged == 'Admin' &&
                                          ticketCab!.ticketState == 0)
                                      ? SizedBox(
                                          width: 200,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: CustomOutlinedButton(
                                              isFilled: true,
                                              backGroundColor: colorDerivado,
                                              onPressed: () async {
                                                onFormSubmit(
                                                    ticketFormProvider,
                                                    userLogged,
                                                    companyLogged,
                                                    5);
                                              },
                                              text: 'Derivar',
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      : Container(),

                                  //---------- Botón En Curso ----------
                                  (userTypeLogged == 'AdminKP' &&
                                          ticketCab!.ticketState == 2)
                                      ? SizedBox(
                                          width: 200,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: CustomOutlinedButton(
                                              isFilled: true,
                                              backGroundColor: colorEnCurso,
                                              onPressed: () async {
                                                onFormSubmit(
                                                    ticketFormProvider,
                                                    userLogged,
                                                    companyLogged,
                                                    3);
                                              },
                                              text: 'En Curso',
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      : Container(),

                                  //---------- Botón Resuelto ----------

                                  ((userTypeLogged == 'User' &&
                                              (ticketCab!.ticketState == 5 ||
                                                  ticketCab!.ticketState ==
                                                      8)) ||
                                          (userTypeLogged == 'AdminKP' &&
                                              ticketCab!.ticketState == 2) ||
                                          (userTypeLogged == 'AdminKP' &&
                                              ticketCab!.ticketState == 3) ||
                                          (userTypeLogged == 'Admin' &&
                                              ticketCab!.ticketState == 0))
                                      ? SizedBox(
                                          width: 200,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: CustomOutlinedButton(
                                              isFilled: true,
                                              backGroundColor: colorResuelto,
                                              onPressed: () async {
                                                onFormSubmit(
                                                    ticketFormProvider,
                                                    userLogged,
                                                    companyLogged,
                                                    4);
                                              },
                                              text: 'Resuelto',
                                              color: Colors.black,
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ],
    );
  }

  //---------------------------------------------------------------------------------
  void _sendEmail(
      int estado,
      int nroTicket,
      String emailUserTicket,
      String emailUserSelected,
      int companyTicketId,
      String categoryName,
      String subcategoryName) async {
    String emailUserLogged =
        Provider.of<AuthProvider>(context, listen: false).user!.email;
    int companyLoggedId =
        Provider.of<AuthProvider>(context, listen: false).user!.companyId;

    Response response = await ApiHelper.getMailsAdmin(companyTicketId);
    EmailResponse emailResponse = response.result;

    String emailsAdmin = emailResponse.emails;

    Response response2 = await ApiHelper.getMailsAdminKP();
    EmailResponse emailResponse2 = response2.result;

    String emailsAdminKP = emailResponse2.emails;

    String to = '';
    String cc = '';
    String subject = '';
    String body = '';

    switch (estado) {
      //Enviado
      case 0:
        to = emailsAdmin;
        cc = emailUserTicket;
        subject =
            'TicketN N° $nroTicket ENVIADO - Categoría: $categoryName - Subcategoría: $subcategoryName';
        body = '''
Se ha enviado nuevamente el Ticket N° $nroTicket.<br>
Haga clic aquí --> <a href="https://gaos2.keypress.com.ar/TicketsWeb" style="color: blue;">Ir al ticket</a>
''';
        break;
      //Devuelto
      case 1:
        to = emailUserTicket;
        cc = emailUserLogged;
        subject =
            'TicketN N° $nroTicket DEVUELTO - Categoría: $categoryName - Subcategoría: $subcategoryName';
        body = '''
Se ha devuelto el Ticket N° $nroTicket para su revisión.<br>
Haga clic aquí --> <a href="https://gaos2.keypress.com.ar/TicketsWeb" style="color: blue;">Ir al ticket</a>
''';
        break;

      //Asignado
      case 2:
        to = emailsAdminKP;
        cc = emailUserTicket;
        subject =
            'TicketN N° $nroTicket ASIGNADO - Categoría: $categoryName - Subcategoría: $subcategoryName';
        body = '''
Se ha asignado a Keypress el Ticket N° $nroTicket para su resolución<br>
Haga clic aquí --> <a href="https://gaos2.keypress.com.ar/TicketsWeb" style="color: blue;">Ir al ticket</a>
''';
        break;

      //En curso
      case 3:
        to = emailUserTicket;
        cc = emailsAdmin;
        subject =
            'TicketN N° $nroTicket EN CURSO - Categoría: $categoryName - Subcategoría: $subcategoryName';
        body = '''
La resolución del Ticket N° $nroTicket se encuentra en curso.<br>
En breve se comunicará su resolución.<br>
Haga clic aquí --> <a href="https://gaos2.keypress.com.ar/TicketsWeb" style="color: blue;">Ir al ticket</a>
''';
        break;

      //Resuelto
      case 4:
        to = emailUserTicket;
        cc = emailsAdmin;
        subject =
            'TicketN N° $nroTicket RESUELTO - Categoría: $categoryName - Subcategoría: $subcategoryName';
        body = '''
El Ticket N° $nroTicket ha sido resuelto<br>
Haga clic aquí --> <a href="https://gaos2.keypress.com.ar/TicketsWeb" style="color: blue;">Ir al ticket</a>
''';
        break;

      //Derivado
      case 5:
        to = emailUserSelected;
        cc = emailUserTicket;
        subject =
            'TicketN N° $nroTicket DERIVADO - Categoría: $categoryName - Subcategoría: $subcategoryName';
        body = '''
El Ticket N° $nroTicket ha sido derivado a $emailUserSelected para su revisión.<br>
Haga clic aquí --> <a href="https://gaos2.keypress.com.ar/TicketsWeb" style="color: blue;">Ir al ticket</a>
''';
        break;

      //Autorizar
      case 7:
        to = emailUserSelected;
        cc = emailUserTicket;
        subject =
            'TicketN N° $nroTicket PARA AUTORIZAR - Categoría: $categoryName - Subcategoría: $subcategoryName';
        body = '''
El Ticket N° $nroTicket ha sido derivado a $emailUserSelected para su autorización.<br>
Haga clic aquí --> <a href="https://gaos2.keypress.com.ar/TicketsWeb" style="color: blue;">Ir al ticket</a>
''';
        break;
    }

    Map<String, dynamic> request = {
      'to': to,
      'cc': cc,
      'subject': subject,
      'body': body,
    };

    try {
      await ApiHelper.sendMail(request);
    } catch (e) {
      return null;
    }
  }

  //************************************************************************************************
  //--------------------------------------------------------------------
  Future<void> _getCategories() async {
    Response response = await ApiHelper.getCategoriesCombo();

    if (!response.isSuccess) {
      NotificationsService.showSnackbarError('Error al cargar las Categorías');
      return;
    }

    setState(() {
      _categories = response.result;
    });

    await _getSubcategories(ticketCab!.categoryId);
  }

//---------------------------------------------------------------------------
  Widget _showCategory() {
    return Container(
      child: _categories.isEmpty
          ? const Text('Cargando Categorías...')
          : DropdownButtonFormField(
              dropdownColor: Colors.grey,
              isExpanded: true,
              isDense: true,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              items: _getComboCategories(),
              value: categoryId,
              onChanged: (option) async {
                await _getSubcategories(option!);

                categoryId = option;
                subcategoryId = 0;

                setState(() {});
              },
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
                prefixIcon: const Icon(Icons.category, color: Colors.white),
                isDense: true,
                labelStyle: const TextStyle(color: Colors.white),
                labelText: 'Categoría',
                filled: true,
                fillColor: Colors.grey,
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
          'Error al cargar las Subcategorías');
      return;
    }

    setState(() {
      _subcategories = response.result;
    });
  }

  //---------------------------------------------------------------------------
  Widget _showSubcategory() {
    return Container(
      child: _subcategories.isEmpty
          ? const Text('Cargando Subcategorías...')
          : DropdownButtonFormField(
              validator: (value) {
                if (value == 0) {
                  return 'Seleccione una Subcategoría...';
                }
                return null;
              },
              dropdownColor: Colors.grey,
              isExpanded: true,
              isDense: true,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              items: _getComboSubcategories(),
              value: subcategoryId,
              onChanged: (option) {
                subcategoryId = option!;
                setState(() {});
              },
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
                prefixIcon:
                    const Icon(Icons.category_outlined, color: Colors.white),
                labelStyle: const TextStyle(color: Colors.white),
                isDense: true,
                hintText: 'Seleccione una Subcategoría...',
                labelText: 'Subcategoría',
                filled: true,
                fillColor: Colors.grey,
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
}

//-------------------------------------------------------------
class CustomChip extends StatelessWidget {
  final String estado;
  const CustomChip({
    super.key,
    required this.estado,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
          side: const BorderSide(
            color: Colors.black,
            width: 0.5,
          ),
        ),
        label: Text(estado.toUpperCase(),
            style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.bold)),
        backgroundColor: estado == 'Enviado'
            ? colorEnviado
            : estado == 'Devuelto'
                ? colorDevuelto
                : estado == 'Asignado'
                    ? colorAsignado
                    : (estado.toLowerCase() == 'encurso' ||
                            estado.toLowerCase() == 'en curso')
                        ? colorEnCurso
                        : (estado.toLowerCase() == 'derivado')
                            ? colorDerivado
                            : (estado.toLowerCase() == 'cerrado')
                                ? colorCerrado
                                : (estado.toLowerCase() == 'autorizar')
                                    ? colorAutorizar
                                    : (estado.toLowerCase() == 'autorizado')
                                        ? colorAutorizado
                                        : colorRechazado);
  }
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
                  // Text(ticketFormProvider.name,
                  //     style: const TextStyle(fontWeight: FontWeight.bold))
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
