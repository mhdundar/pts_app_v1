// lib/screens/users/widgets/user_detail_card.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pts_app_v1/constants/order_statuses.dart';
import 'package:pts_app_v1/models/user.dart';

class UserDetailCard extends StatelessWidget {
  final User user;

  const UserDetailCard({super.key, required this.user});

  Color _getAvatarColor(String name) {
    final hash = name.codeUnits.fold(0, (p, c) => p + c);
    final colors = [
      Colors.deepPurple,
      Colors.teal,
      Colors.indigo,
      Colors.cyan,
      Colors.pinkAccent,
      Colors.amber,
    ];
    return colors[hash % colors.length];
  }

  Color _getRoleColor(String role) {
    final roleMap = {
      'admin': Colors.redAccent,
      'manager': Colors.orangeAccent,
      'employee': Colors.blueAccent,
      'operator': Colors.teal,
    };
    return roleMap[role.toLowerCase()] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: _getAvatarColor(user.name),
                child: Text(
                  user.name[0].toUpperCase(),
                  style: const TextStyle(fontSize: 26, color: Colors.white),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "${user.name} ${user.surname}",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                user.username,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _getRoleColor(user.userRole.name),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  user.userRole.label,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    user.isOnline ? Icons.circle : Icons.circle_outlined,
                    size: 14,
                    color: user.isOnline ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    user.isOnline ? "Online" : "Offline",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: user.isOnline ? Colors.green : Colors.grey,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
