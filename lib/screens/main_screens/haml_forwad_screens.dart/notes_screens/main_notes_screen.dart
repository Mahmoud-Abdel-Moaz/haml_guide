import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:haml_guide/config/api_providers.dart';
import 'package:haml_guide/config/app_colors.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:haml_guide/models/haml_forward_models/haml_note_model.dart';
import 'package:haml_guide/screens/widgets/main_screens_widgets/haml_forward_screens_widgets/notes_screen_widgets.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../../../config/api_keys.dart';

class MainNotesScreen extends StatefulWidget {
  const MainNotesScreen({Key? key}) : super(key: key);

  @override
  State<MainNotesScreen> createState() => _MainNotesScreenState();
}

class _MainNotesScreenState extends State<MainNotesScreen> {
  final TextEditingController _noteTitleController = TextEditingController();
  final TextEditingController _noteDescriptionController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late Future<List<HamlNoteModel>?> _getAllHamlNotes;

  late BannerAd _myBannerMain;

  @override
  void initState() {
    _getAllHamlNotes = context
        .read(ApiProviders.hamlNoteScreenProvidersApis)
        .getAllHamlnotes(context: context);

    _myBannerMain = CommonComponents.getBannerAds();

    _myBannerMain.load();

    super.initState();
  }

  @override
  void dispose() {
    _myBannerMain.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int? deviceID =  CommonComponents.getSavedData(ApiKeys.deviceIdFromApi);

    return Scaffold(
      appBar: CommonComponents.commonAppBarForwardHaml(title: "الملاحظات"),
      body: Padding(
        padding: EdgeInsets.all(10.0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "الملاحظات",
                  style: TextStyle(
                    fontSize: 18.0.sp,
                    color: AppColors.defaultAppColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if(deviceID==null)
                  const SizedBox(),
                  if(deviceID!=null)
                  InkWell(
                  onTap: () async {
                    await NotesScreenWidgets.noteAlertWidget(
                      context: context,
                      noteTitleController: _noteTitleController,
                      noteDescriptionController: _noteDescriptionController,
                      formKey: _formKey,
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        size: 20.0.h,
                        color: AppColors.defaultAppColor,
                      ),
                      Text(
                        "اضف ملاحظة",
                        style: TextStyle(
                          fontSize: 11.0.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.defaultAppColor,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0.h),
            CommonComponents.showBannerAds(_myBannerMain),
            SizedBox(height: 20.0.h),
            if(deviceID==null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50.h,),
                  Center(
                    child: Text(
                      'لأستخدام الملاحظات يجب تجربة الحاسبة أولا',
                      style:  TextStyle(
                        fontSize: 16.0.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                      textScaleFactor: 1,
                    ),
                  )
                ],
              ),
            if(deviceID!=null)
            FutureBuilder(
                future: _getAllHamlNotes,
                builder:
                    (context, AsyncSnapshot<List<HamlNoteModel>?> snapshot) {
                  if (snapshot.data == null) {
                    return CommonComponents.loadingDataFromServer();
                  } else {
                    return NotesScreenWidgets.noteContentWidget(
                      contentList: (snapshot.data??[]),
                      appBarTitle: "الملاحظات",
                      image: "assets/images/notes.png",
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
