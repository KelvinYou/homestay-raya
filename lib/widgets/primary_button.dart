import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String childText;
  final VoidCallback onPressed;
  final bool inverseColor;
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.childText,
    this.inverseColor = false,
  });
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      splashColor: Colors.black12,
      padding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Ink(
        width: double.infinity,
        decoration: BoxDecoration(
            color: inverseColor ?
            Theme.of(context).colorScheme.background
                : Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary,
              width: 2.0,
            )
        ),
        child: Container(
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 25.0),
          constraints: const BoxConstraints(
              maxWidth: 200.0,
              minHeight: 40.0
          ),
          alignment: Alignment.center,
          child: Text(
            childText,
            style: TextStyle(
              fontSize: 16.0,
              color: inverseColor ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        ),
      ),
    );
  }
}