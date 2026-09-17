import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../services/api_service.dart';

import './widgets/date_range_selector_widget.dart';
import './widgets/metrics_card_widget.dart';
import './widgets/product_performance_widget.dart';
import './widgets/sales_chart_widget.dart';
import './widgets/stock_alerts_widget.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String _selectedPeriod = 'Daily';
  DateTime _lastUpdated = DateTime.now();

  Map<String, dynamic>? _reportData;
  bool _isLoading = false;

  DateTime? _customStart;
  DateTime? _customEnd;

  @override
  void initState() {
    super.initState();
    _loadReports(period: "daily");
  }

  Future<void> _loadReports({
    String? period,
    String? startDate,
    String? endDate,
  }) async {
    setState(() => _isLoading = true);

    try {
      final data = await ApiService.getReports(
        period: period,
        startDate: startDate,
        endDate: endDate,
      );

      setState(() {
        _reportData = data;
        _lastUpdated = DateTime.now();
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to load reports")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final metrics = _reportData?["metrics"] ?? {};
    final salesTrend = _reportData?["sales_trend"] ?? [];
    final topProducts = _reportData?["top_products"] ?? [];
    final lowStock = _reportData?["low_stock"] ?? [];

    return Column(
      children: [
        CustomAppBar(
          title: 'Business Reports',
          actions: [
            IconButton(
              onPressed: _showExportOptions,
              icon: CustomIconWidget(
                iconName: 'file_download',
                size: 24,
                color: theme.colorScheme.onSurface,
              ),
            ),
            IconButton(
              onPressed: _showFilterOptions,
              icon: CustomIconWidget(
                iconName: 'filter_list',
                size: 24,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DateRangeSelectorWidget(
                    selectedPeriod: _selectedPeriod,
                    onPeriodChanged: _handlePeriodChange,
                    onCustomRangePressed: _showCustomRangePicker,
                  ),
                  SizedBox(height: 2.h),

                  /// ================== KEY METRICS ==================
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      'Key Metrics',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 2.h,
                      crossAxisSpacing: 3.w,
                      childAspectRatio: 1.3,
                      children: [
                        MetricsCardWidget(
                          label: 'Total Sales',
                          value: "₹${(metrics["total_sales"] ?? 0).toString()}",
                          percentageChange: "",
                          isPositive: true,
                          icon: Icons.attach_money,
                        ),
                        MetricsCardWidget(
                          label: 'Transactions',
                          value: "${metrics["transactions"] ?? 0}",
                          percentageChange: "",
                          isPositive: true,
                          icon: Icons.receipt_long,
                        ),
                        MetricsCardWidget(
                          label: 'Avg. Order Value',
                          value:
                              "₹${(metrics["average_order_value"] ?? 0).toString()}",
                          percentageChange: "",
                          isPositive: true,
                          icon: Icons.shopping_cart,
                        ),
                        MetricsCardWidget(
                          label: 'Profit Margin',
                          value: "${metrics["profit_margin"] ?? 0}%",
                          percentageChange: "",
                          isPositive: true,
                          icon: Icons.trending_up,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 2.h),

                  /// ================== SALES CHART ==================
                  SalesChartWidget(
                    salesData: (salesTrend is List ? salesTrend : [])
                        .map(
                          (e) => {
                            "label": e["date"] ?? "",
                            "value": (e["total"] is num)
                                ? (e["total"] as num).toDouble()
                                : 0.0,
                          },
                        )
                        .toList(),
                    period: _selectedPeriod,
                  ),

                  SizedBox(height: 2.h),

                  /// ================== TOP PRODUCTS ==================
                  ProductPerformanceWidget(
                    topProducts: (topProducts is List ? topProducts : [])
                        .map(
                          (e) => {
                            "name": e["name"] ?? "",
                            "quantity": e["quantity"] ?? 0,
                            "revenue": "₹${e["revenue"] ?? 0}",
                            "contribution": e["contribution"] ?? 0,
                            "image": e["image_url"],
                            "semanticLabel": e["name"] ?? "",
                          },
                        )
                        .toList(),
                  ),

                  SizedBox(height: 2.h),

                  /// ================== LOW STOCK ==================
                  StockAlertsWidget(
                    lowStockItems: (lowStock is List ? lowStock : [])
                        .map(
                          (e) => {
                            "name": e["name"] ?? "",
                            "stock": e["stock"] ?? 0,
                          },
                        )
                        .toList(),
                    onRestockPressed: _navigateToAddProduct,
                  ),

                  SizedBox(height: 2.h),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      'Last updated: ${_formatLastUpdated()}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handlePeriodChange(String period) {
    setState(() => _selectedPeriod = period);

    if (period == "Daily") {
      _loadReports(period: "daily");
    } else if (period == "Weekly") {
      _loadReports(period: "weekly");
    } else if (period == "Monthly") {
      _loadReports(period: "monthly");
    }
  }

  Future<void> _showCustomRangePicker() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      _customStart = picked.start;
      _customEnd = picked.end;

      setState(() => _selectedPeriod = "Custom");

      _loadReports(
        startDate: picked.start.toIso8601String().split("T").first,
        endDate: picked.end.toIso8601String().split("T").first,
      );
    }
  }

  Future<void> _refreshData() async {
    if (_selectedPeriod == "Daily") {
      await _loadReports(period: "daily");
    } else if (_selectedPeriod == "Weekly") {
      await _loadReports(period: "weekly");
    } else if (_selectedPeriod == "Monthly") {
      await _loadReports(period: "monthly");
    } else if (_selectedPeriod == "Custom" &&
        _customStart != null &&
        _customEnd != null) {
      await _loadReports(
        startDate: _customStart!.toIso8601String().split("T").first,
        endDate: _customEnd!.toIso8601String().split("T").first,
      );
    }
  }

  void _navigateToAddProduct() {
    Navigator.of(context, rootNavigator: true).pushNamed('/add-product-screen');
  }

  void _showExportOptions() {}
  void _showFilterOptions() {}

  String _formatLastUpdated() {
    final now = DateTime.now();
    final difference = now.difference(_lastUpdated);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes} minutes ago';
    if (difference.inHours < 24) return '${difference.inHours} hours ago';
    return '${difference.inDays} days ago';
  }
}
