import 'package:flutter/material.dart';


class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // const SizedBox(
            //   height: 100,
            //   width: 100,
            //   child: Image(
            //     image: AssetImage('assets/logo.png'),
            //   ),
            // ),
            const SizedBox(height: 30.0),
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 20.0),
            // Text(
            //   "Preparing the data ...",
            //   style: TextStyle(
            //     color: Theme.of(context).colorScheme.primary,
            //     fontSize: 16,
            //   ),
            // ),
            // Text(
            //   "Please wait for a moment ...",
            //   style: TextStyle(
            //     color: Theme.of(context).colorScheme.primary,
            //     fontSize: 14,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
