import 'package:amazon_clone/constants/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget costomFormField({
  required TextEditingController Controller,
  required TextInputType type,
  BuildContext? context,
  Function? onsubmit(String v)?,
  Function? onchanged(String v)?,
  VoidCallback? suffixpressed,
  VoidCallback? ontap,
  TextStyle? style,
  required String? validator(String? v)?,
  String? label,
  String? hintText,
  IconData? prefix,
  IconData? suffix,
  bool ispass = false,
  Color? color,
  Color? iconColor,
  Color? hoverColor,
  Color? fillColor,
  Color? prefixIconColor,
  Color? focusColor,
  Color? cursorColor,
  int? maxLines =1,
}) =>
    TextFormField(
      controller: Controller,
      keyboardType: type,
      onFieldSubmitted: onsubmit,
      onTap: ontap,
      style: style,
      obscureText: ispass,
      onChanged: onchanged,
      validator: validator,
      cursorColor: cursorColor,
      // style:Theme.of(context!).textTheme.bodyText2 ,
     maxLines: maxLines,
      decoration: InputDecoration(
          labelText: label,
          iconColor: iconColor,
          hintText: hintText,
          hoverColor: hoverColor,
          focusColor: focusColor,
          fillColor: fillColor,
          prefixIconColor: prefixIconColor,
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black38),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black38),
          ),
          prefixIcon: Icon(
            prefix,
          ),
          suffixIcon: IconButton(
            onPressed: suffixpressed,
            icon: Icon(
              suffix,
            ),
          )),
    );
Widget defaultTextButton({
  required void Function()? onPress(),
  required String text,
  Color? color,
}) =>
    ElevatedButton(
      onPressed: onPress,
      // ignore: sort_child_properties_last
      child: Text(
        text,
        style: TextStyle(color: color==null?Colors.white:Colors.black),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        primary: color,
      ),
    );
void ShowToast({required String text, required ToastStates state}) =>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: ChooseToastColor(state),
        textColor: Colors.white,
        fontSize: 16.0);

enum ToastStates { SUCCESS, ERROR, WARNING }

// ignore: non_constant_identifier_names
Color ChooseToastColor(ToastStates? states) {
  Color color = Colors.grey;
  switch (states!) {
    case (ToastStates.SUCCESS):
      color = Colors.green;
      break;
    case (ToastStates.ERROR):
      color = Colors.red;
      break;
    case (ToastStates.WARNING):
      color = Colors.yellow;
      break;
  }
  return color;
}

Widget appBarBlue({String? name}) => Container(
      decoration: const BoxDecoration(
        gradient: GlobalVariables.appBarGradient,
      ),
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
              text: "Hello, ",
              style: const TextStyle(fontSize: 22, color: Colors.black),
              children: [
                TextSpan(
                  text: "$name",
                  style: const TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        ],
      ),
    );