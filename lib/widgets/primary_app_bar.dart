import 'package:flutter/material.dart';

class PrimaryAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final IconData? rightButton;
  final VoidCallback? function;
  const PrimaryAppBar({
    Key? key,
    required this.title,
    this.rightButton,
    this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return AppBar(
      iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
      ),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevation: 0,
      actions: <Widget>[
        rightButton != null && function != null ?
        Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: function,
              child: Icon( rightButton ),
            )
        ) : const SizedBox(),
      ],
    );

  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
