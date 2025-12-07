import 'dart:io';
import 'package:flutter/material.dart';

/// A reusable avatar component that handles different image sources
class Avatar extends StatelessWidget {
  final String? photoUrl;
  final double size;
  final VoidCallback? onTap;

  const Avatar({
    super.key,
    this.photoUrl,
    this.size = 120,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[200],
          border: Border.all(color: Colors.grey[300]!, width: 2),
        ),
        child: _buildAvatarContent(),
      ),
    );
  }

  Widget _buildAvatarContent() {
    if (photoUrl == null || photoUrl!.isEmpty) {
      // No photo provided, show add photo icon
      return Icon(
        Icons.add_a_photo,
        size: size * 0.33, // 40 for 120 size
        color: Colors.grey[600],
      );
    }

    // Check if URL starts with http
    if (photoUrl!.startsWith('http')) {
      // Use network image
      return ClipOval(
        child: Image.network(
          photoUrl!,
          fit: BoxFit.cover,
          width: size,
          height: size,
          errorBuilder: (context, error, stackTrace) {
            // Show placeholder if network image fails to load
            return Icon(
              Icons.person,
              size: size * 0.5,
              color: Colors.grey[600],
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
        ),
      );
    } else {
      // Use file image
      return ClipOval(
        child: Image.file(
          File(photoUrl!),
          fit: BoxFit.cover,
          width: size,
          height: size,
          errorBuilder: (context, error, stackTrace) {
            // Show placeholder if file image fails to load
            return Icon(
              Icons.person,
              size: size * 0.5,
              color: Colors.grey[600],
            );
          },
        ),
      );
    }
  }
}
