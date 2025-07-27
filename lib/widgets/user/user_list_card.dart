// lib/screens/users/widgets/user_list_card.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pts_app_v1/constants/order_statuses.dart';
import 'package:pts_app_v1/models/user.dart';

class UserListCard extends StatelessWidget {
  final User user;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onDelete;
  final VoidCallback onDetail;
  final VoidCallback onEdit;

  const UserListCard({
    super.key,
    required this.user,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
    required this.onDelete,
    required this.onDetail,
    required this.onEdit,
  });

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
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.red.withValues(alpha: 0.25)
                  : Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white24),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: _getAvatarColor(user.name),
                child: Text(
                  user.name[0].toUpperCase(),
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              title: Text(
                "${user.name} ${user.surname}",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    user.username,
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getRoleColor(user.userRole.name),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          user.userRole.label,
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        user.isOnline ? Icons.circle : Icons.circle_outlined,
                        size: 12,
                        color: user.isOnline ? Colors.green : Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        user.isOnline ? "Online" : "Offline",
                        style: GoogleFonts.poppins(
                          color: user.isOnline ? Colors.green : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: PopupMenuButton<String>(
                color: Colors.white,
                onSelected: (value) {
                  if (value == "detail") onDetail();
                  if (value == "delete") onDelete();
                  if (value == "edit") onEdit();
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                      value: "detail",
                      child:
                          Text("Detay", style: TextStyle(color: Colors.black))),
                  PopupMenuItem(
                      value: "delete",
                      child:
                          Text("Sil", style: TextStyle(color: Colors.black))),
                  PopupMenuItem(
                      value: "edit",
                      child: Text("Düzenle",
                          style: TextStyle(color: Colors.black))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
