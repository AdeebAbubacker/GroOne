import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

class ProductCounter extends StatelessWidget {
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  const ProductCounter({super.key, required this.count, required this.onIncrement, required this.onDecrement,});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildActionButton(CupertinoIcons.minus, onDecrement),
         10.width,
        Text("$count", style: AppTextStyle.h5),
        10.width,
        _buildActionButton(CupertinoIcons.add, onIncrement),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 15),
      ),
    );
  }
}
