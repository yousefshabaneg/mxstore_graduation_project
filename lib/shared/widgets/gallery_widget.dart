import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../constants.dart';
import '../helpers.dart';
import '../resources/color_manager.dart';

class GalleryWidget extends StatefulWidget {
  GalleryWidget({required this.urlImages, required this.name, this.index = 0})
      : pageController = PageController(initialPage: index);
  final List<String> urlImages;
  final String name;
  final int index;
  final PageController pageController;

  void changeIndex(index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pageController.hasClients) {
        pageController.animateToPage(index,
            duration: Duration(milliseconds: 1), curve: Curves.easeOutSine);
        imageControllers[imageControllers.length - 1].animateToPage(index,
            duration: Duration(milliseconds: 1), curve: Curves.easeOutSine);
      }
    });
  }

  @override
  State<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  late int index = widget.index;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          padding: EdgeInsets.all(0),
          icon: Icon(
            Icons.clear,
            color: ColorManager.subtitle,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(this.widget.name, style: kTheme.textTheme.subtitle1!),
        elevation: 1,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            PhotoViewGallery.builder(
              pageController: widget.pageController,
              itemCount: widget.urlImages.length,
              backgroundDecoration: BoxDecoration(color: Colors.transparent),
              builder: (context, index) {
                final urlImage = widget.urlImages[index];
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(urlImage),
                  initialScale: 0.5,
                  maxScale: PhotoViewComputedScale.contained,
                );
              },
              onPageChanged: (index) {
                widget.changeIndex(index);
                setState(() => this.index = index);
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${index + 1} of ${widget.urlImages.length}",
                    style: kTheme.textTheme.bodyText1!.copyWith(fontSize: 14),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...List.generate(widget.urlImages.length,
                            (index) => buildSmallPreview(index))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSmallPreview(int index) {
    return InkWell(
      onTap: () => this.widget.changeIndex(index),
      child: Container(
        height: kHeight * 0.1,
        width: kHeight * 0.1,
        padding: EdgeInsets.all(kHeight * 0.01),
        margin: EdgeInsets.all(kHeight * 0.01),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color:
                index == this.index ? ColorManager.primary : ColorManager.gray,
          ),
        ),
        child: Image.network(widget.urlImages[index]),
      ),
    );
  }
}
