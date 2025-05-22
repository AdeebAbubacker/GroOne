import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_button.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_text_field.dart';
import 'package:gro_one_app/utils/app_text_style.dart';

class LpSelectPickPointScreen extends StatefulWidget {
  const LpSelectPickPointScreen({super.key});

  @override
  State<LpSelectPickPointScreen> createState() =>
      _LpSelectPickPointScreenState();
}

class _LpSelectPickPointScreenState extends State<LpSelectPickPointScreen> {
  TextEditingController address = TextEditingController(
    text: "Coca Cola Bottling Plant, Nemam, Vellavedu, Tamil Nadu 600124",
  );
  bool locationDone = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title:
            locationDone ? "Select Pick Point Location" : "Select Destination",
      ),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              height: 600.h,
              width: double.infinity,
              color: AppColors.boxGreen,
              child: Center(child: Text("map View")),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 340.h,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),

              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Location", style: AppTextStyle.textBlackColor16w400),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.disableColor),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade200,
                      ),
                      child: Text(
                        "Hobli Ramnagar, Bidadi, KarnatakaKarnatakaKarnatakaKarnataka",
                        style: AppTextStyle.textBlackColor14w400.copyWith(
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: address,
                      labelText: "Address",
                      labelTextStyle: AppTextStyle.textBlackColor16w400,
                      maxLines: 3,
                    ),

                    const SizedBox(height: 20),
                    AppButton(
                      title: locationDone?"Set Pickup Location":"Continue",
                      onPressed: () {
                        if (locationDone == false) {
                          context.pop();
                        } else {
                          locationDone = false;
                          setState(() {});
                        }

                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
