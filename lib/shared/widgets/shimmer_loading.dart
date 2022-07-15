import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../helpers.dart';
import '../resources/color_manager.dart';

class ShimmerHomeLoading extends StatelessWidget {
  const ShimmerHomeLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 10),
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.withOpacity(0.25),
          highlightColor: Colors.white.withOpacity(0.6),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: kWidth * 0.04, vertical: kHeight * 0.01),
            child: Container(
              height: kHeight * 0.03,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey.withOpacity(0.9),
              ),
            ),
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey.withOpacity(0.25),
          highlightColor: Colors.white.withOpacity(0.6),
          period: const Duration(seconds: 2),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: kHeight * 0.23,
              width: kWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.withOpacity(0.9),
              ),
            ),
          ),
        ),
        kVSeparator(factor: 0.03),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: kWidth * 0.03),
          child: SizedBox(
            height: kHeight * 0.1,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Shimmer.fromColors(
                baseColor: Colors.grey.withOpacity(0.25),
                highlightColor: Colors.white.withOpacity(0.6),
                period: const Duration(seconds: 2),
                child: Column(
                  children: [
                    Container(
                      width: kHeight * 0.08,
                      height: kHeight * 0.08,
                      margin: EdgeInsets.only(right: kWidth * 0.06),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: kWidth * 0.15,
                      height: kHeight * 0.01,
                      margin: EdgeInsets.only(right: kWidth * 0.06),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.9),
                        shape: BoxShape.rectangle,
                      ),
                    ),
                  ],
                ),
              ),
              itemCount: 6,
            ),
          ),
        ),
        kVSeparator(factor: 0.01),
        kDivider(factor: 0.02, opacity: 0.6),
        kVSeparator(factor: 0.08),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: kWidth * 0.03),
          child: SizedBox(
            height: kHeight * 0.1,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Shimmer.fromColors(
                baseColor: Colors.grey.withOpacity(0.25),
                highlightColor: Colors.white.withOpacity(0.6),
                period: const Duration(seconds: 2),
                child: Column(
                  children: [
                    Container(
                      width: kHeight * 0.08,
                      height: kHeight * 0.08,
                      margin: EdgeInsets.only(right: kWidth * 0.06),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: kWidth * 0.15,
                      height: kHeight * 0.01,
                      margin: EdgeInsets.only(right: kWidth * 0.06),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.9),
                        shape: BoxShape.rectangle,
                      ),
                    ),
                  ],
                ),
              ),
              itemCount: 6,
            ),
          ),
        ),
        kVSeparator(factor: 0.025),
        kDivider(factor: 0.02, opacity: 0.6),
        kVSeparator(factor: 0.05),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: kWidth * 0.03),
          child: SizedBox(
            height: kHeight * .32,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Shimmer.fromColors(
                baseColor: Colors.grey.withOpacity(0.25),
                highlightColor: Colors.white.withOpacity(0.6),
                period: const Duration(seconds: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: kWidth * 0.3,
                      height: kHeight * 0.2,
                      margin: EdgeInsets.only(right: kWidth * 0.06),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.9),
                        shape: BoxShape.rectangle,
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: kWidth * 0.3,
                      height: kHeight * 0.02,
                      margin: EdgeInsets.only(right: kWidth * 0.06),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.9),
                        shape: BoxShape.rectangle,
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: kWidth * 0.3,
                      height: kHeight * 0.02,
                      margin: EdgeInsets.only(right: kWidth * 0.06),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.9),
                        shape: BoxShape.rectangle,
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: kWidth * 0.3,
                      height: kHeight * 0.02,
                      margin: EdgeInsets.only(right: kWidth * 0.06),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.9),
                        shape: BoxShape.rectangle,
                      ),
                    ),
                  ],
                ),
              ),
              itemCount: 10,
            ),
          ),
        ),
        kVSeparator(),
        kDivider(factor: 0.02),
        kVSeparator(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: kWidth * 0.03),
          child: SizedBox(
            height: kHeight * .32,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Shimmer.fromColors(
                baseColor: Colors.grey.withOpacity(0.25),
                highlightColor: Colors.white.withOpacity(0.6),
                period: const Duration(seconds: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: kWidth * 0.3,
                      height: kHeight * 0.2,
                      margin: EdgeInsets.only(right: kWidth * 0.06),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.9),
                        shape: BoxShape.rectangle,
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: kWidth * 0.3,
                      height: kHeight * 0.02,
                      margin: EdgeInsets.only(right: kWidth * 0.06),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.9),
                        shape: BoxShape.rectangle,
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: kWidth * 0.3,
                      height: kHeight * 0.02,
                      margin: EdgeInsets.only(right: kWidth * 0.06),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.9),
                        shape: BoxShape.rectangle,
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: kWidth * 0.3,
                      height: kHeight * 0.02,
                      margin: EdgeInsets.only(right: kWidth * 0.06),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.9),
                        shape: BoxShape.rectangle,
                      ),
                    ),
                  ],
                ),
              ),
              itemCount: 10,
            ),
          ),
        ),
        kVSeparator(factor: 0.03),
      ],
    );
  }
}

class ShimmerGridViewLoading extends StatelessWidget {
  const ShimmerGridViewLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: GridView.builder(
        shrinkWrap: true,
        primary: false,
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
          childAspectRatio: 0.6,
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) => Column(
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey.withOpacity(0.2),
              highlightColor: Colors.white.withOpacity(0.6),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: kHeight * 0.26,
                  width: kWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey.withOpacity(0.7),
                  ),
                ),
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey.withOpacity(0.25),
              highlightColor: Colors.white.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: kHeight * 0.03,
                  width: kWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey.withOpacity(0.7),
                  ),
                ),
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey.withOpacity(0.25),
              highlightColor: Colors.white.withOpacity(0.6),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: kHeight * 0.03,
                  width: kWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey.withOpacity(0.7),
                  ),
                ),
              ),
            ),
          ],
        ),
        itemCount: 4,
      ),
    );
  }
}

class ShimmerGridItemLoading extends StatelessWidget {
  const ShimmerGridItemLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.withOpacity(0.2),
          highlightColor: Colors.white.withOpacity(0.6),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: kHeight * 0.22,
              width: kWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey.withOpacity(0.7),
              ),
            ),
          ),
        ),
        kVSeparator(factor: 0.01),
        Shimmer.fromColors(
          baseColor: Colors.grey.withOpacity(0.25),
          highlightColor: Colors.white.withOpacity(0.3),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: kHeight * 0.04,
              width: kWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey.withOpacity(0.7),
              ),
            ),
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey.withOpacity(0.25),
          highlightColor: Colors.white.withOpacity(0.6),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
            child: Container(
              height: kHeight * 0.03,
              width: kWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey.withOpacity(0.7),
              ),
            ),
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey.withOpacity(0.25),
          highlightColor: Colors.white.withOpacity(0.6),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
            child: Container(
              height: kHeight * 0.03,
              width: kWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey.withOpacity(0.7),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ShimmerListProducts extends StatelessWidget {
  const ShimmerListProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      width: kWidth * 0.3,
      decoration: new BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(color: ColorManager.gray, width: 0.2),
      ),
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.2),
            highlightColor: Colors.white.withOpacity(0.6),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                height: kHeight * 0.18,
                width: kWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: Colors.grey.withOpacity(0.7),
                ),
              ),
            ),
          ),
          kVSeparator(factor: 0.01),
          Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.25),
            highlightColor: Colors.white.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                height: kHeight * 0.03,
                width: kWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: Colors.grey.withOpacity(0.7),
                ),
              ),
            ),
          ),
          kVSeparator(factor: 0.01),
          Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.25),
            highlightColor: Colors.white.withOpacity(0.6),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                height: kHeight * 0.02,
                width: kWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: Colors.grey.withOpacity(0.7),
                ),
              ),
            ),
          ),
          Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.25),
            highlightColor: Colors.white.withOpacity(0.6),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                height: kHeight * 0.02,
                width: kWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: Colors.grey.withOpacity(0.7),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
