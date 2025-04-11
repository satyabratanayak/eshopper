import 'package:eshopper/features/admin/models/sales.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CategoryProductsChart extends StatelessWidget {
  final List<Sales> salesData;

  const CategoryProductsChart({Key? key, required this.salesData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _getMaxY(),
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < salesData.length) {
                  return Text(
                    salesData[index].label,
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const Text('');
              },
            ),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: salesData.asMap().entries.map((entry) {
          int index = entry.key;
          Sales sale = entry.value;
          return BarChartGroupData(x: index, barRods: [
            BarChartRodData(toY: sale.earning.toDouble(), width: 16),
          ]);
        }).toList(),
      ),
    );
  }

  double _getMaxY() {
    if (salesData.isEmpty) return 10;
    return salesData
            .map((s) => s.earning)
            .reduce((a, b) => a > b ? a : b)
            .toDouble() +
        10;
  }
}
