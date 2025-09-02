import 'package:flutter/material.dart';

class AppKeys {
  static ValueKey txt(String name) => ValueKey('txt_$name'); // for textField
  static ValueKey btn(String name) => ValueKey('btn_$name'); // for button
  static ValueKey link(String name) => ValueKey('link_$name'); // for link
  static ValueKey chk(String name) => ValueKey('chk_$name'); // for checkbox
  static ValueKey ddl(String name) => ValueKey('ddl_$name'); // for dropdown
  static ValueKey lst(String name) => ValueKey('lst_$name'); // for list
  static ValueKey tile(String name) => ValueKey('tile_$name'); // for list
  static ValueKey rdo(String name) => ValueKey('rdo_$name'); // for radio
  static ValueKey swt(String name) => ValueKey('swt_$name'); // for switches
  static ValueKey cnt(String name) => ValueKey('cnt_$name'); // for counters
}
