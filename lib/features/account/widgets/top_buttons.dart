import 'package:eshopper/constants/string_constants.dart';
import 'package:eshopper/features/account/services/account_services.dart';
import 'package:eshopper/features/account/widgets/account_button.dart';
import 'package:flutter/material.dart';

class TopButtons extends StatelessWidget {
  const TopButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AccountButton(
              text: StringConstants.yourOrders,
              onTap: () {},
            ),
            AccountButton(
              text: StringConstants.applyForSeller,
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            AccountButton(
              text: StringConstants.logOut,
              onTap: () => AccountServices().logOut(context),
            ),
            AccountButton(
              text: StringConstants.wishlist,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}
