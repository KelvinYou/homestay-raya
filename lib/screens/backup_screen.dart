import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:homestay_raya/utils/app_theme.dart';
import 'package:homestay_raya/widgets/loading_indicator.dart';
import 'package:homestay_raya/widgets/primary_app_bar.dart';

class BackUpScreen extends StatefulWidget {
  const BackUpScreen({super.key});

  @override
  State<BackUpScreen> createState() => _BackUpScreenState();
}

class _BackUpScreenState extends State<BackUpScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
          title: "Coming Soon"
      ),
      body: isLoading ? const LoadingIndicator() : Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Login"),
            ],
          ),
        ),
      ),
    );
  }

}