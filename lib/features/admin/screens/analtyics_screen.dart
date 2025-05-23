import 'package:eshopper/common/widgets/loader.dart';
import 'package:eshopper/constants/string_constants.dart';
import 'package:eshopper/features/account/services/account_services.dart';
import 'package:eshopper/features/account/widgets/account_button.dart';
import 'package:eshopper/features/admin/models/sales.dart';
import 'package:eshopper/features/admin/services/admin_services.dart';
import 'package:eshopper/features/admin/widgets/category_products_chart.dart';
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AdminServices adminServices = AdminServices();
  int? totalSales;
  List<Sales>? earnings;

  @override
  Widget build(BuildContext context) {
    return earnings == null || totalSales == null
        ? const Loader()
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  '₹$totalSales',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 250,
                  child: CategoryProductsChart(salesData: earnings ?? []),
                ),
                Spacer(),
                Row(
                  children: [
                    AccountButton(
                      text: StringConstants.logOut,
                      onTap: () => AccountServices().logOut(context),
                    ),
                    AccountButton(
                      text: StringConstants.applyForBuyer,
                      onTap: () => AccountServices().goToBuyer(context),
                    ),
                  ],
                ),
              ],
            ),
          );
  }

  getEarnings() async {
    var earningData = await adminServices.getEarnings(context);
    totalSales = earningData['totalEarnings'];
    earnings = earningData['sales'];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getEarnings();
  }
}
