import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Customer information section with quick-add buttons
class CustomerSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final Function(Map<String, dynamic>) onQuickAdd;

  final List<dynamic> frequentCustomers;
  final bool isLoading;

  const CustomerSection({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.onQuickAdd,
    required this.frequentCustomers,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Customer Details',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _showFrequentCustomers(context),
                  icon: CustomIconWidget(
                    iconName: 'person_add',
                    color: theme.colorScheme.primary,
                    size: 18,
                  ),
                  label: const Text('Quick Add'),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Customer Name',
                hintText: 'Enter customer name',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: 'Enter phone number',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email (Optional)',
                hintText: 'Enter email address',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFrequentCustomers(BuildContext context) {
    final theme = Theme.of(context);
    final TextEditingController searchController = TextEditingController();
    List<dynamic> filteredCustomers = List.from(frequentCustomers);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            void filterCustomers(String query) {
              setModalState(() {
                if (query.isEmpty) {
                  filteredCustomers = List.from(frequentCustomers);
                } else {
                  filteredCustomers = frequentCustomers.where((customer) {
                    final name = (customer['name'] ?? '')
                        .toString()
                        .toLowerCase();
                    final phone = (customer['phone'] ?? '')
                        .toString()
                        .toLowerCase();
                    final q = query.toLowerCase();
                    return name.contains(q) || phone.contains(q);
                  }).toList();
                }
              });
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: EdgeInsets.all(4.w),
                height: 70.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Frequent Customers',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),

                    /// 🔍 Search Field
                    TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search customer...',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: filterCustomers,
                    ),

                    SizedBox(height: 2.h),

                    /// 🔄 Loading
                    if (isLoading)
                      const Expanded(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    /// ❌ No Customers
                    else if (filteredCustomers.isEmpty)
                      const Expanded(
                        child: Center(child: Text('No customers found')),
                      )
                    /// 📋 Customer List
                    else
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredCustomers.length,
                          itemBuilder: (context, index) {
                            final customer = filteredCustomers[index];

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    theme.colorScheme.primaryContainer,
                                child: Text(
                                  (customer['name'] ?? 'C')
                                      .toString()
                                      .substring(0, 1)
                                      .toUpperCase(),
                                  style: TextStyle(
                                    color: theme.colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              title: Text(customer['name'] ?? ''),
                              subtitle: Text(customer['phone'] ?? ''),
                              onTap: () {
                                onQuickAdd(customer);
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
