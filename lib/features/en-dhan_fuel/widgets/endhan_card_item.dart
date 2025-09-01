import 'package:flutter/material.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';

class EndhanCardItem extends StatefulWidget {
  final Map<String, dynamic> card;
  const EndhanCardItem({super.key, required this.card});

  @override
  State<EndhanCardItem> createState() => _EndhanCardItemState();
}

class _EndhanCardItemState extends State<EndhanCardItem> {
  bool _obscureCardNumber = true;

  String getMaskedCardNumber(String cardNumber) {
    if (cardNumber.length <= 4) return cardNumber;
    final visible = cardNumber.substring(cardNumber.length - 4);
    final masked = 'X' * (cardNumber.length - 4);
    // Optionally format as **** **** 1234
    return masked + visible;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: commonContainerDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        shadow: true
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Align(
            alignment: Alignment.centerRight,
            child: Text(
              context.appText.digitalCard,
              style: AppTextStyle.body4.copyWith(
                color: AppColors.greyTextColor,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),

          10.height,

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  widget.card['image'],
                  width: 70,
                  height: 44,
                  fit: BoxFit.cover,
                ),
              ),

              12.width,

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _obscureCardNumber
                            ? getMaskedCardNumber(widget.card['cardNumber'] ?? '')
                            : (widget.card['cardNumber'] ?? ''),
                        style: AppTextStyle.body.copyWith(fontWeight: FontWeight.w600),
                      ),
                    
                      IconButton(
                        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                        icon: Icon(_obscureCardNumber ? Icons.visibility_off : Icons.visibility, size: 20),
                        tooltip: _obscureCardNumber ? context.appText.showCardNumber : context.appText.hideCardNumber,
                        onPressed: () {
                          setState(() {
                            _obscureCardNumber = !_obscureCardNumber;
                          });
                        },
                        padding: EdgeInsets.zero,
                       // constraints: BoxConstraints(),
                      ),
                    ],
                  ),
                  //2.height,
                  Text(
                    widget.card['vehicleNumber'],
                    style: AppTextStyle.body3.copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              ).expand(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: commonContainerDecoration(
                      color: AppColors.boxGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.card['status'],
                      style: AppTextStyle.body3.copyWith(
                        color: AppColors.textGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),


          12.height,
          Divider(),
           Row(
            children: [
              /// TODO: Add amount and date time later
              // Text(
              //   card['amount'],
              //   style: AppTextStyle.h5.copyWith(
              //     color: AppColors.primaryColor,
              //     fontWeight: FontWeight.w700,
              //   ),
              // ),
             // 4.width,
              // Icon(Icons.refresh, color: AppColors.textBlackColor, size: 18),
              // const Spacer(),
              Text(
                context.appText.mobNum,
                style: AppTextStyle.body3.copyWith(color: AppColors.greyTextColor),
              ),

              
               Text(
                 widget.card['mobile'] != "" && widget.card['mobile'] != null ? widget.card['mobile']: context.appText.na,
                style: AppTextStyle.body3.copyWith(
                  color: AppColors.primaryTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          8.height,
          // Text(
          //   card['dateTime'],
          //   style: AppTextStyle.body3.copyWith(color: AppColors.greyTextColor),
          // ),
        ],
      ).paddingAll(12.0),
    );
  }
}
