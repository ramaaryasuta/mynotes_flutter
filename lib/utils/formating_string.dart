import 'package:flutter/material.dart';
import 'package:mynotes/utils/language_helper.dart';

String formatedDate(String date, BuildContext context) {
  final DateTime dt = DateTime.parse(date);
  final now = DateTime.now();

  if (dt.day == now.day && dt.month == now.month && dt.year == now.year) {
    return '${S.of(context)!.today}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(0, '0')}';
  }

  return '${dt.day}/${dt.month}/${dt.year}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(0, '0')}';
}
