import 'package:eshopper/common/widgets/custom_appbar.dart';
import 'package:eshopper/features/account/widgets/orders.dart';
import 'package:eshopper/features/account/widgets/top_buttons.dart';
import 'package:eshopper/features/home/widgets/address_box.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            AddressBox(),
            SizedBox(height: 10),
            TopButtons(),
            SizedBox(height: 20),
            Orders(),
          ],
        ),
      ),
    );
  }
}
