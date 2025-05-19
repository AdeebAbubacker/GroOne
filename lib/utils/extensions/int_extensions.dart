import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// int Extensions
extension IntExtensions on int? {

  /// Leaves given height of space
  Widget get height => SizedBox(height: this?.toDouble().h);

  /// Leaves given width of space
  Widget get width => SizedBox(width: this?.toDouble().w);

  /// Returns Size
  Size get size => Size(this!.toDouble(), this!.toDouble());
}