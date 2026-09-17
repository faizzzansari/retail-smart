import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sizer/sizer.dart';

class SalesChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> salesData;
  final String period;

  const SalesChartWidget({
    super.key,
    required this.salesData,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // ✅ Strongly typed processing
    final List<Map<String, dynamic>> processedData = salesData.map((e) {
      final String label = e["label"]?.toString() ?? "";
      final double value = (e["value"] is num)
          ? (e["value"] as num).toDouble()
          : double.tryParse(e["value"]?.toString() ?? "0") ?? 0.0;

      return {"label": label, "value": value};
    }).toList();

    // ✅ Dynamic max Y
    double maxValue = 0;
    for (var e in processedData) {
      final double v = e["value"] as double;
      if (v > maxValue) maxValue = v;
    }

    final double dynamicMaxY = maxValue == 0 ? 10.0 : maxValue * 1.2;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sales Trend',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  period,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          /// Chart
          SizedBox(
            height: 30.h,
            child: processedData.isEmpty
                ? Center(
                    child: Text(
                      "No Sales Data",
                      style: theme.textTheme.bodyMedium,
                    ),
                  )
                : LineChart(
                    LineChartData(
                      minX: 0,
                      maxX: (processedData.length - 1).toDouble(),
                      minY: 0,
                      maxY: dynamicMaxY,

                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: dynamicMaxY / 5,
                      ),

                      borderData: FlBorderData(show: true),

                      titlesData: FlTitlesData(
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),

                        /// Bottom labels
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              final int index = value.toInt();
                              if (index >= 0 && index < processedData.length) {
                                final String label =
                                    processedData[index]["label"] as String;

                                return Padding(
                                  padding: EdgeInsets.only(top: 1.h),
                                  child: Text(
                                    label,
                                    style: theme.textTheme.labelSmall,
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),

                        /// Left values
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: dynamicMaxY / 5,
                            reservedSize: 45,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                "₹${value.toInt()}",
                                style: theme.textTheme.labelSmall,
                              );
                            },
                          ),
                        ),
                      ),

                      lineBarsData: [
                        LineChartBarData(
                          spots: processedData.asMap().entries.map((entry) {
                            final double yValue =
                                entry.value["value"] as double;

                            return FlSpot(entry.key.toDouble(), yValue);
                          }).toList(),
                          isCurved: true,
                          color: theme.colorScheme.primary,
                          barWidth: 3,
                          dotData: FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.1,
                            ),
                          ),
                        ),
                      ],

                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (spots) {
                            return spots.map((spot) {
                              return LineTooltipItem(
                                "₹${spot.y.toStringAsFixed(2)}",
                                theme.textTheme.labelMedium!.copyWith(
                                  color: theme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
