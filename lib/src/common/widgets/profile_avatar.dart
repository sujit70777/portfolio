import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, required this.size});

  final double size;

  static const _assetPath = 'assets/images/profile.jpg';

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).colorScheme.tertiary;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: accentColor.withAlpha(90), width: 3),
        boxShadow: [
          BoxShadow(
            color: accentColor.withAlpha(60),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          _assetPath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            debugPrint(
              'ProfileAvatar: no image found at "$_assetPath" — showing a '
              'placeholder. Add your photo at that path to replace it.',
            );
            return ColoredBox(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Icon(
                Icons.person_rounded,
                size: size * 0.55,
                color: accentColor,
              ),
            );
          },
        ),
      ),
    );
  }
}
