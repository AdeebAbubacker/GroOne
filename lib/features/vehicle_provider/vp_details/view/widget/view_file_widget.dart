import 'package:flutter/material.dart';
import 'package:gro_one_app/dependency_injection/locator.dart';
import 'package:gro_one_app/features/vehicle_provider/vp_details/cubit/load_details_cubit.dart';
import 'package:gro_one_app/l10n/extensions/app_localizations_extensions.dart';
import 'package:gro_one_app/utils/app_application_bar.dart';
import 'package:gro_one_app/utils/common_widgets.dart';
import 'package:gro_one_app/utils/constant_variables.dart';
import 'package:gro_one_app/utils/extensions/int_extensions.dart';
import 'package:gro_one_app/utils/extensions/widget_extensions.dart';

class ViewFileWidget extends StatefulWidget {
  final List<String> image;
  const ViewFileWidget({super.key, required this.image});

  @override
  State<ViewFileWidget> createState() => _ViewFileWidgetState();
}

class _ViewFileWidgetState extends State<ViewFileWidget> {

  final cubit=locator<LoadDetailsCubit>();
  final ValueNotifier<List<String>> imageListNotifier=ValueNotifier([]);



  _fetchAllImages()async{
    if(widget.image.isNotEmpty){
      List<String> filePath=[];
      for(var item in widget.image){
        final documentResponse= await cubit.fetchDocumentById(item);
        if((documentResponse?.filePath??"").isNotEmpty){
          filePath.add(documentResponse?.filePath??"");
        }
      }
      imageListNotifier.value=filePath;
    }
  }

  @override
  void initState() {
    _fetchAllImages();
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: context.appText.file, isCrossLeadingIcon: true),
      body: ValueListenableBuilder(
        valueListenable: imageListNotifier,
        builder: (context, value, child)  {
          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: commonSafeAreaPadding, vertical: 20),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: value.length,
            itemBuilder: (context, index) {
              return  commonCacheNetworkImage(
                height: 200,
                width: double.infinity,
                path: value[index],
                errorImage: Icons.image_not_supported,
              );
            },
            separatorBuilder: (context, index) => 15.height,
          ).withScroll();
        }
      ),
    );
  }
}
