import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickets_web_app/providers/providers.dart';
import 'package:tickets_web_app/services/local_storage.dart';
import 'package:tickets_web_app/services/navigation_services.dart';
import 'package:tickets_web_app/ui/layouts/shared/widgets/loader_component.dart';

import '../../models/models.dart';

class CategoryView extends StatefulWidget {
  final String id;
  const CategoryView({Key? key, required this.id}) : super(key: key);

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  //----------------------------------------------------------------------
  Category? category;
  late List<Subcategory> subcategories;
  bool showLoader = false;
  late Token token;
  String userTypeLogged = "";

  //----------------------------------------------------------------------
  @override
  void initState() {
    showLoader = true;

    final userBody = LocalStorage.prefs.getString('userBody');
    var decodedJson = jsonDecode(userBody!);
    token = Token.fromJson(decodedJson);
    userTypeLogged = token.user.userTypeName;

    setState(() {});
    final categoriesProvider =
        Provider.of<CategoriesProvider>(context, listen: false);

    subcategories = [];

    categoriesProvider.getCategoryById(widget.id).then(
          (categoryDB) => setState(
            () {
              category = categoryDB;
              subcategories = category!.subcategories != null
                  ? category!.subcategories!
                  : [];
            },
          ),
        );
    showLoader = false;
    setState(() {});
  }

  ///----------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return showLoader
        ? const Center(child: LoaderComponent(text: 'Por favor espere...'))
        : _getContent();
  }

  //------------------------------ _getContent --------------------------
  Widget _getContent() {
    return Column(
      children: <Widget>[
        subcategories.isEmpty
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
          'No hay subcategorías en esta categoría',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  //------------------------------ _getListView ---------------------------

  Widget _getListView() {
    final userLogged =
        Provider.of<AuthProvider>(context, listen: false).user!.fullName;
    final companyLogged =
        Provider.of<AuthProvider>(context, listen: false).user!.companyName;
    final size = MediaQuery.of(context).size;

    TextStyle titleStyle = const TextStyle(
        color: Color.fromARGB(255, 3, 30, 184),
        fontSize: 12,
        fontWeight: FontWeight.bold);

    TextStyle dataStyle = const TextStyle(
      color: Colors.black,
      fontSize: 12,
    );

    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 130,
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
                            width: 300,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text('Categoría: ',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.white60,
                                              fontSize: 14)),
                                      Expanded(
                                        child: Text(category!.name,
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
                        ],
                      ),
                      Positioned(
                        top: 5,
                        right: 10,
                        child: InkWell(
                          onTap: () {
                            NavigationServices.replaceTo(
                                '/dashboard/categories');
                          },
                          child: const Text("X",
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
            Expanded(
              child: ListView(
                children: subcategories.map((e) {
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
                                            Text('Id: ', style: titleStyle),
                                            Expanded(
                                              child: Text(e.id.toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: dataStyle),
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
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                                width: 80,
                                                child: Text('Nombre: ',
                                                    style: titleStyle)),
                                            SizedBox(
                                              width: 600,
                                              child: SelectableText(e.name,
                                                  style: dataStyle),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
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
          ],
        ),
      ],
    );
  }
}
