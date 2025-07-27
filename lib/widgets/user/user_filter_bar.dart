// lib/screens/users/widgets/user_filter_bar.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final String selectedRole;
  final Function(String) onRoleChanged;

  const UserFilterBar({
    super.key,
    required this.searchController,
    required this.selectedRole,
    required this.onRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final roles = ["Tümü", "Admin", "Manager", "Employee", "Operator"];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: "Kullanıcı ara...",
              hintStyle: GoogleFonts.poppins(color: Colors.white70),
              prefixIcon: const Icon(Icons.search, color: Colors.white),
              filled: true,
              fillColor: Colors.white12,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: roles.map((role) {
                final isSelected = role == selectedRole;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      role,
                      style: GoogleFonts.poppins(
                        color: isSelected ? Colors.white : Colors.white70,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: Colors.blueAccent,
                    backgroundColor: Colors.white24,
                    onSelected: (_) => onRoleChanged(role),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
