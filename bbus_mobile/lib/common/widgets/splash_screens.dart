import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bbus_mobile/config/injector/injector.dart';
import 'package:bbus_mobile/common/cubit/current_user/current_user_cubit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo
                Image.asset(
                  'assets/logos/logo.png',
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 24),
                // App Name
                const SizedBox(height: 16),
                // Loading indicator
                const CircularProgressIndicator(),
              ],
            ),
          ),
          // Branding
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Image.asset(
                  'assets/logos/branding-large.png',
                  width: 140,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Powered by BBus System',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
