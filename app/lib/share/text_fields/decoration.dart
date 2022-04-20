import 'package:flutter/material.dart';

InputDecoration commonInputDecoration(String text) {
  return InputDecoration(
      labelText: text,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      isDense: true,
      filled: true,
      fillColor: const Color(0xfff0f2f6));
}
