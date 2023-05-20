import 'package:flutter/material.dart';
import '../constants/constants.dart';

class ModalsDropDownWidget extends StatefulWidget {
  const ModalsDropDownWidget({super.key});

  @override
  State<ModalsDropDownWidget> createState() => _ModalsDropDownWidgetState();
}

class _ModalsDropDownWidgetState extends State<ModalsDropDownWidget> {
  String currentModal = "Modal1";
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      dropdownColor: scaffoldBackgroundColor,
      iconEnabledColor: Colors.white,
      items: getModelsItem,
      value: currentModal,
      onChanged: (value) {
        setState(() {
          currentModal = value.toString();
        });
      },
    );
  }
}
