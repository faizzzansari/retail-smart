import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';

/// Splash Screen - App initialization and branding display
///
/// Provides branded app initialization experience while loading core inventory data
/// and determining user navigation path. Performs critical startup tasks including
/// database verification, permission checks, and data synchronization.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final bool _isInitializing = true;
  String _statusMessage = 'Loading inventory...';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  /// Setup fade-in animation for logo and tagline
  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  /// Initialize app with critical startup tasks
  Future<void> _initializeApp() async {
    try {
      // Hide system status bar for full-screen experience
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

      // Simulate database integrity verification
      await Future.delayed(const Duration(milliseconds: 800));
      _updateStatus('Verifying database...');

      // Simulate checking cloud synchronization status
      await Future.delayed(const Duration(milliseconds: 600));
      _updateStatus('Checking sync status...');

      // Simulate loading user preferences
      await Future.delayed(const Duration(milliseconds: 500));
      _updateStatus('Loading preferences...');

      // Simulate initializing camera permissions for barcode scanning
      await Future.delayed(const Duration(milliseconds: 600));
      _updateStatus('Preparing scanner...');

      // Complete initialization
      await Future.delayed(const Duration(milliseconds: 500));

      // Navigate to ProductListScreen as main dashboard
      if (mounted) {
        await Navigator.of(
          context,
          rootNavigator: true,
        ).pushReplacementNamed('/login-screen');
      }
    } catch (e) {
      // Handle initialization errors gracefully
      if (mounted) {
        _showErrorDialog('Initialization failed. Please restart the app.');
      }
    } finally {
      // Restore system UI
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
    }
  }

  /// Update status message during initialization
  void _updateStatus(String message) {
    if (mounted) {
      setState(() {
        _statusMessage = message;
      });
    }
  }

  /// Show error dialog for initialization failures
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Initialization Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _initializeApp();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo
                Container(
                  width: 45.w,
                  height: 45.w,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'inventory_2',
                      size: 25.w,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),

                SizedBox(height: 4.h),

                // App Name
                Text(
                  'RetailSmart',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: theme.colorScheme.surface,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),

                SizedBox(height: 1.h),

                // Tagline
                Text(
                  'Smart Inventory Management',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.surface.withValues(alpha: 0.9),
                    letterSpacing: 0.5,
                  ),
                ),

                SizedBox(height: 8.h),

                // Loading Indicator
                SizedBox(
                  width: 8.w,
                  height: 8.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.surface,
                    ),
                  ),
                ),

                SizedBox(height: 2.h),

                // Status Message
                Text(
                  _statusMessage,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.surface.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
