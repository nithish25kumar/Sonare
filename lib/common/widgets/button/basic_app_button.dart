import 'package:flutter/material.dart';

class BasicAppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double? height;
  final Color? backgroundColor;

  const BasicAppButton({
    required this.onPressed,
    required this.title,
    this.height,
    this.backgroundColor,
    super.key,
  });

  Color _getContrastColor(Color bg) {
    return bg.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final Color bg = backgroundColor ?? Theme.of(context).primaryColor;
    final Color textColor = _getContrastColor(bg);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        minimumSize: Size.fromHeight(height ?? 80),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
