import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:haml_guide/config/api_providers.dart';
import 'package:haml_guide/config/app_colors.dart';
import 'package:haml_guide/config/common_components.dart';
import 'package:haml_guide/screens/widgets/drawer_screen_widgets/favourite_screen_widgets.dart';
import 'package:riverpod_context/riverpod_context.dart';

import '../../models/source_model.dart';
import 'resource_item_view.dart';

class SourcesScreen extends StatefulWidget {
  const SourcesScreen({Key? key}) : super(key: key);

  @override
  State<SourcesScreen> createState() => _SourcesScreenState();
}

class _SourcesScreenState extends State<SourcesScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Future<void> _fetchAllNames;
  late BannerAd _myBanner;

  Future<void> getAllNames() async {
    _fetchAllNames = context
        .read(ApiProviders.namesScreenProvidersApis)
        .getNames(context: context);

    return await _fetchAllNames;
  }

  @override
  void initState() {
    _myBanner = CommonComponents.getBannerAds();
    _myBanner.load();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _myBanner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<SourceModel> sources = [
      SourceModel('VeryWellFamily', 'https://www.verywellfamily.com/'),
      SourceModel('NHS', 'https://www.nhs.uk/'),
      SourceModel('Raising Children', 'https://raisingchildren.net.au/'),
      SourceModel('Healthline', 'https://www.healthline.com'),
      SourceModel('Mawdoo3', 'https://mawdoo3.com'),
      SourceModel('Hamil Guide', 'http://hamilguide.com'),
    ];
    return Scaffold(
      appBar: CommonComponents.commonAppBar(
        title: Text(
          "المصادر",
          style: TextStyle(
            fontSize: 16.0.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0.h),
        child: Column(
          children: [
            SizedBox(height: 10.0.h),
            CommonComponents.showBannerAds(_myBanner),
            SizedBox(height: 10.0.h),
            Expanded(
              child: ListView.separated(
                itemBuilder: (c, i) => ResourceItemView(resource: sources[i],),
                separatorBuilder: (c, i) => SizedBox(height: 16.0.h),
                itemCount: sources.length,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
              ),
            )
          ],
        ),
      ),
    );
  }
}
