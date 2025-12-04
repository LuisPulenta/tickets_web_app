import 'package:flutter/material.dart';

import '../../helpers/colors.dart';
import '../labels/custom_labels.dart';

class WindowModal extends StatefulWidget {
  final String title;
  final Widget widget;
  const WindowModal({super.key, required this.title, required this.widget});

  @override
  State<WindowModal> createState() => _WindowModalState();
}

class _WindowModalState extends State<WindowModal> {
  //---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: buildBoxDecoration(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(0),
                child: Text(widget.title, style: CustomLabels.smalltitle),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
          const Divider(color: Colors.grey),
          widget.widget,
        ],
      ),
    );
  }

  //---------------------------------------------------------------------------
  BoxDecoration buildBoxDecoration() => BoxDecoration(
        color: fondoClaro,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: Colors.black)],
      );
}
