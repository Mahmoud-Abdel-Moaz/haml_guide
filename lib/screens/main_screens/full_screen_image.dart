import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/cache_helper.dart';
import '../../models/moctatafat_image.dart';


class FullScreenImageScreen extends StatefulWidget {
  //final String ImageUrl;
  final List<MoctatafatImage> images;
  final int index;
  const FullScreenImageScreen({Key? key,  required this.index, required this.images}) : super(key: key);

  @override
  State<FullScreenImageScreen> createState() => _FullScreenImageScreenState();
}

class _FullScreenImageScreenState extends State<FullScreenImageScreen> {

  int currentIndex=0;
  late PageController _pageController = PageController(
    viewportFraction: 1.0,
    initialPage: widget.index,
  );

  @override
  void initState() {
    CacheHelper.saveData(key: 'start_index', value: 2);

    currentIndex=widget.index;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent,elevation: 0,
     title: GestureDetector(onTap: ()=>Navigator.of(context).pop(),child: Icon(Icons.arrow_back_ios,color: Colors.white,size: 20.r,),),
          automaticallyImplyLeading: false,
        ),
      body:  PageView.builder(
        onPageChanged: (index) {
          setState(() {
            currentIndex=index;
          });
        },
        itemBuilder: (context, index) => Padding(
          padding:  EdgeInsets.symmetric(horizontal: 8.0.w,vertical: 8.h),
          child: Hero(
            tag: index,
            child: InteractiveViewer(
              panEnabled: true, // Set it to false
              boundaryMargin: EdgeInsets.all(100),
              minScale: 0.5,
              maxScale: 2,
              child: CachedNetworkImage(
                imageUrl: widget.images[index].file??'',width: double.infinity,height:double.infinity,
                alignment: Alignment.center,/*fit: BoxFit.fill,*/
                errorWidget: (context, url, error) => Image.asset('assets/images/default_image.png',width: double.infinity,height:double.infinity,alignment: Alignment.center,/*fit: BoxFit.fill,*/),
              ),
              /*Image.network(widget.images[index].path??'',
             //   fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
              ),*/
            ),
          ),
        ),
        itemCount: widget.images.length,
        controller: _pageController,
      )



    );;
  }
}
