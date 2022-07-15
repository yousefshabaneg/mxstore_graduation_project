import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';
import '../resources/color_manager.dart';

class AppFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType type;
  final TextInputAction inputAction;
  final Iterable<String>? autoFill;
  final String hint;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool isPassword;
  final FocusNode? focusNode;
  final bool enabled;
  final double padding;
  final VoidCallback? onPressed;
  final ValueChanged<String>? onSubmit;
  final String? Function(String?)? validate;
  final ValueChanged<String>? onChanged;
  const AppFormField({
    required this.hint,
    required this.type,
    this.inputAction = TextInputAction.done,
    required this.controller,
    this.prefixIcon,
    this.isPassword = false,
    this.enabled = true,
    this.suffixIcon,
    this.autoFill,
    this.onChanged,
    this.focusNode,
    this.padding = 5,
    this.onPressed,
    this.onSubmit,
    this.validate,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: ColorManager.dark,
      enabled: enabled,
      controller: controller,
      keyboardType: type,
      autofillHints: autoFill,
      obscureText: isPassword,
      textInputAction: inputAction,
      focusNode: focusNode,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: padding),
        isDense: true,
        hintText: hint,
        hintStyle:
            kTheme.textTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold),
        prefixIconConstraints: BoxConstraints(),
        suffixIconConstraints: BoxConstraints(),
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: FaIcon(
                  prefixIcon,
                  size: 24,
                  color: ColorManager.primary,
                ),
              )
            : null,
        suffix: suffixIcon != null
            ? CircleAvatar(
                radius: 15,
                backgroundColor: ColorManager.primary.withOpacity(0.2),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon:
                      FaIcon(suffixIcon, size: 15, color: ColorManager.primary),
                  onPressed: onPressed,
                ),
              )
            : null,
      ),
      style: TextStyle(
        color: ColorManager.dark,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      onFieldSubmitted: onSubmit,
      validator: validate,
      onChanged: onChanged,
    );
  }
}
