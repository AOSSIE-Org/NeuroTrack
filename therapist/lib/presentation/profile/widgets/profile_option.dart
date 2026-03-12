import 'package:flutter/material.dart';

class ProfileOption extends StatelessWidget {
  final String title;
  final bool isLogout;
  final VoidCallback? onTap;

  const ProfileOption({
    super.key,
    required this.title,
    this.isLogout = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: isLogout ? const Color(0xFFEF4444) : Colors.black,
              fontWeight: isLogout ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: isLogout ? const Color(0xFFEF4444) : Colors.black87,
          ),
          onTap: onTap ?? () {},
        ),
        const Divider(height: 1, thickness: 1, indent: 0, endIndent: 0),
      ],
    );
  }
}
