import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Input extends StatelessWidget {
  const Input(
      {Key? key,
      this.labelText,
      this.validator,
      this.onSave,
      this.inputFormatters,
      this.initialValue,
      this.focusNode,
      this.onFieldSubmitted,
      this.enable = true,
      this.obscureText = false,
      this.textInputAction = TextInputAction.next,
      this.textInputType,
      this.onChanged,
      this.multiline = false,
      this.color,
      this.backgroundColor,
      this.controller})
      : super(key: key);

  final String? labelText;
  final String? Function(String? value)? validator;
  final String? Function(String?)? onSave;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;
  final bool? enable;
  final bool obscureText;
  final FocusNode? focusNode;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction textInputAction;
  final TextInputType? textInputType;
  final Function? onChanged;
  final bool multiline;
  final TextEditingController? controller;
  final Color? color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlignVertical: TextAlignVertical.top,
      enabled: enable,
      controller: controller,
      initialValue: initialValue,
      keyboardType: textInputType,
      minLines: multiline ? 5 : null,
      maxLines: null,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      style: TextStyle(color: Colors.white, fontSize: 18),
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: labelText,
        labelStyle: TextStyle(
            overflow: TextOverflow.ellipsis,
            color: focusNode!.hasFocus ? Colors.white : color,
            fontWeight: FontWeight.bold),
        filled: true,
        fillColor: backgroundColor,
        contentPadding: const EdgeInsets.only(
          left: 18,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(0.0),
        ),
      ),
      validator: validator,
      onSaved: onSave,
      textInputAction: textInputAction,
      cursorColor: color,
      onChanged: onChanged as void Function(String)?,
    );
  }
}
