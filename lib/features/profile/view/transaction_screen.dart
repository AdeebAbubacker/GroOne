import 'package:flutter/material.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_colors.dart';
import 'package:gro_one_app/utils/app_image.dart';
import 'package:gro_one_app/utils/app_search_bar.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/extension_functions.dart';

import '../../../../utils/app_application_bar.dart';
import '../../../../utils/app_text_style.dart';
import '../../../../utils/extra_utils.dart';

class LpTransaction extends StatefulWidget {
  const LpTransaction({super.key});

  @override
  State<LpTransaction> createState() => _LpTransactionState();
}

class _LpTransactionState extends State<LpTransaction> {

  final searchController = TextEditingController();
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title:  context.appText.transactions, scrolledUnderElevation: 0.0),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: commonSafeAreaPadding),
        child: Column(
          spacing: 20,
          children: [

            // Tabs
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                tabWidget(
                  text: context.appText.all,
                  onTap: () {
                    selectedIndex = 0;
                    setState(() {});
                  },
                  selected: selectedIndex == 0 ? true : false,
                ),
                tabWidget(
                  text: context.appText.pending,
                  onTap: () {
                    selectedIndex = 1;
                    setState(() {});
                  },
                  selected: selectedIndex == 1 ? true : false,
                ),
                tabWidget(
                  text: context.appText.completed,
                  onTap: () {
                    selectedIndex = 2;
                    setState(() {});
                  },
                  selected: selectedIndex == 2 ? true : false,
                ),
              ],
            ),

            // Search Bar
            AppSearchBar(
              searchController: searchController,
              onChanged: (text) {
                debounce(() {

                });
              },
            ),


            selectedIndex == 0
                ? allWidget()
                : selectedIndex == 1
                ? Center(child: Text("Pending"))
                : Center(child: Text("Completed")),
          ],
        ),
      ),
    );
  }

  allWidget() {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: 24,
        itemBuilder: (context, index) {
          return ListTile(
            tileColor: AppColors.white,
            leading: Image.asset(
              !index.isEven
                  ? AppImage.png.pendingTransaction
                  : AppImage.png.completedTransaction,
              height: 30,
              width: 30,
            ),
            title: Text("₹820", style: AppTextStyle.textBlackDetailColor16w500),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "GD12456 • Pune to Chennai",
                  style: AppTextStyle.textGreyDetailColor12w400,
                ),
                Text(
                  "22 Apr 2025, 3:45 PM",
                  style: AppTextStyle.textGreyDetailColor12w400.copyWith(
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            trailing: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color:
                    index.isEven ? AppColors.boxGreen : AppColors.appRedColor,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text(
                context.appText.pending,
                style: AppTextStyle.whiteColor14w400.copyWith(
                  color: index.isEven ? AppColors.textGreen : AppColors.textRed,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
