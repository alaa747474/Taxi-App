import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uber_clone/core/constants/app_routes_name.dart';
import 'package:uber_clone/core/widgets/custom_app_bar.dart';
import 'package:uber_clone/core/widgets/custom_button.dart';
import 'package:uber_clone/core/widgets/custom_card.dart';
import 'package:uber_clone/features/map/presentation/widgets/intro_card.dart';
import 'package:uber_clone/features/map/presentation/widgets/saved_place_button.dart';
import 'package:uber_clone/features/map/presentation/widgets/map_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Stack(
          clipBehavior: Clip.none,
          children: [CustomAppBar(), IntroCard()],
        ),
        SizedBox(
          height: 80.h,
        ),
        const SavedPlaceButton(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: const Text('Around you'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: CustomCard(
            horizontal: 0,
            child: Stack(
              children: [
                const MapView(),
                InkWell(
                  child: const SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.mapScreen),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 30.h),
          child: CustomButton(
              onPressed: (){},
              text: 'Book a ride now !'),
        ),
      ],
    ));
  }
}
