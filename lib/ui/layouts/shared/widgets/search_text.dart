import 'package:flutter/material.dart';
import 'package:tickets_web_app/ui/inputs/custom_inputs.dart';

class SearchText extends StatelessWidget {
  final Function onSubmitted;
  const SearchText({Key? key, required this.onSubmitted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: buildBoxDecoration(),
      child: TextField(
        decoration: CustomInput.searchInputDecoration(
            hint: "Buscar...", icon: Icons.search_outlined),
        onSubmitted: onSubmitted(),
      ),
    );
  }

  BoxDecoration buildBoxDecoration() => BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.withOpacity(0.2),
      );
}
