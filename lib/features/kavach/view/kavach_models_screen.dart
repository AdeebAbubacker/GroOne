import 'package:flutter/material.dart';
import 'package:gro_one_app/features/kavach/view/widgets/kavach_models_list_body.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/app_text_style.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';

class KavachModelsScreen extends StatefulWidget {
  const KavachModelsScreen({super.key});

  @override
  State<KavachModelsScreen> createState() => _KavachModelsScreenState();
}

class _KavachModelsScreenState extends State<KavachModelsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: context.appText.kavachModels),
      body: buildBodyWidget(),
    );
  }

  Widget buildBodyWidget(){
    return SafeArea(
      minimum: EdgeInsets.all(commonSafeAreaPadding),
      child: Column(
        children: [
          // Title
          Text(context.appText.kavachModels, style: AppTextStyle.body2),

          // List
          ListView.separated(
            itemCount: 5,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => 20.height,
            itemBuilder: (context, index){
              return KavachModelsListBody();
            },
          ),

          20.height
        ],
      ),
    );
  }

}
