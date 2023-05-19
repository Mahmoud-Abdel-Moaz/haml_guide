import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../../config/common_components.dart';
import '../../models/source_model.dart';

class ResourceItemView extends StatelessWidget {
  final SourceModel resource;

  const ResourceItemView({Key? key, required this.resource}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchUrlFun(resource.link),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r), color: Colors.white),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Text(
              resource.title,
              style:  TextStyle(
                fontSize: 16.0.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textScaleFactor: 1,
            )),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 10.r,
            ),
            SizedBox(
              width: 6.w,
            ),
          ],
        ),
      ),
    );
  }
}
