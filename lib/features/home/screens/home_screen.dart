import 'package:eshopper/common/widgets/custom_appbar.dart';
import 'package:eshopper/features/home/widgets/address_box.dart';
import 'package:eshopper/features/home/widgets/carousel_image.dart';
import 'package:eshopper/features/home/widgets/deal_of_day.dart';
import 'package:eshopper/features/home/widgets/top_categories.dart';
import 'package:eshopper/features/search/screens/search_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            AddressBox(),
            SizedBox(height: 10),
            TopCategories(),
            SizedBox(height: 10),
            CarouselImage(),
            DealOfDay(),
          ],
        ),
      ),
    );
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }
}
