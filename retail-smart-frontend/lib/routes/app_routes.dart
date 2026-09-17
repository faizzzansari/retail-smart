import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/billing_screen/billing_screen.dart';
import '../presentation/invoice_screen/invoice_screen.dart';
import '../presentation/report_screen/report_screen.dart';
import '../presentation/auth/login_screen.dart';
import '../presentation/auth/signup_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String home = '/home';
  static const String addProduct = '/add-product-screen';
  static const String splash = '/splash-screen';
  static const String billing = '/billing-screen';
  static const String productList = '/product-list-screen';
  static const String invoice = '/invoice-screen';
  static const String report = '/report-screen';
  static const String login = '/login-screen';
  static const String signup = '/signup-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    signup: (context) => const SignupScreen(),
    splash: (context) => const SplashScreen(),
    billing: (context) => const BillingScreen(),
    invoice: (context) => const InvoiceScreen(),
    report: (context) => const ReportScreen(),
    // TODO: Add your other routes here
  };
}
