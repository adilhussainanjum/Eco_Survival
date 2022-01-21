import 'package:bmind/src/constants/app_color.dart';
import 'package:flutter/material.dart';

Widget myDropDown(
    String hint, List<String> mylist, String chosenValueDrop, Function setstate,
    {Color iconColor}) {
  return Container(
    margin: const EdgeInsets.only(top: 5),
    child: Container(
      child: DropdownButtonFormField<String>(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        // validator: FieldValidator.validateDropDown,
        // iconDisabledColor: iconColor ?? AppColor.primaryColor,
        // iconEnabledColor: iconColor ?? AppColor.primaryColor,
        iconSize: 30,
        value: chosenValueDrop,
        isExpanded: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none,
          hintText: hint,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColor.fadeColor,
              width: 1.0,
            ),
          ),
          contentPadding: const EdgeInsets.fromLTRB(15, 0, 4, 0),
        ),
        style: const TextStyle(color: Colors.white),
        items: mylist.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(color: Colors.black),
            ),
          );
        }).toList(),
        onChanged: (value) {
          chosenValueDrop = value;
          setstate();
        },
      ),
    ),
  );
}
