// lib/screens/users/user_list_screen.dart

import 'package:flutter/material.dart';
import 'package:pts_app_v1/constants/order_statuses.dart';
import 'package:pts_app_v1/models/user.dart';
import 'package:pts_app_v1/screens/users/user_create_screen.dart';
import 'package:pts_app_v1/screens/users/user_details_screen.dart';
import 'package:pts_app_v1/services/user_service.dart';
import 'package:pts_app_v1/widgets/user/user_filter_bar.dart';
import 'package:pts_app_v1/widgets/user/user_list_card.dart';
import 'package:pts_app_v1/widgets/common/app_scaffold.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final List<User> _users = [];
  List<User> _filteredUsers = [];
  final Set<String> _selectedUserIds = {};
  bool _loading = true;
  final TextEditingController _searchCtrl = TextEditingController();
  String _selectedRoleFilter = "Tümü";

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _searchCtrl.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    setState(() => _loading = true);
    try {
      final result = await UserService.getAll();
      setState(() {
        _users.clear();
        _users.addAll(result);
        _filteredUsers = List.from(_users);
        _selectedUserIds.clear();
      });
    } catch (e) {
      debugPrint("Kullanıcılar alınamadı: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  void _onSearchChanged() {
    final query = _searchCtrl.text.trim().toLowerCase();
    setState(() {
      _filteredUsers = _users.where((u) {
        final matchesQuery = query.isEmpty ||
            u.name.toLowerCase().contains(query) ||
            u.surname.toLowerCase().contains(query) ||
            u.username.toLowerCase().contains(query);
        final matchesRole = _selectedRoleFilter == "Tümü" ||
            u.userRole.label == _selectedRoleFilter;
        return matchesQuery && matchesRole;
      }).toList();
    });
  }

  Future<void> _deleteUser(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Silme Onayı"),
        content: const Text("Bu kullanıcıyı silmek istediğinize emin misiniz?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("İptal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Sil"),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        await UserService.delete(id);
        await _loadUsers();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kullanıcı silinemedi: $e')),
        );
      }
    }
  }

  Future<void> _deleteSelectedUsers() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Toplu Silme Onayı"),
        content: Text(
            "${_selectedUserIds.length} kullanıcı silinecek. Emin misiniz?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("İptal")),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Sil")),
        ],
      ),
    );

    if (confirmed == true) {
      for (var id in _selectedUserIds) {
        try {
          await UserService.delete(id);
        } catch (e) {
          debugPrint("Kullanıcı silinemedi: $id");
        }
      }
      await _loadUsers();
    }
  }

  void _openUserDetail(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => UserDetailScreen(user: user)),
    );
  }

  void _openUserCreate() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const UserCreateScreen()),
    ).then((_) => _loadUsers());
  }

  void _openUserEdit(User userToEdit) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => UserCreateScreen(
                userToEdit: userToEdit,
              )),
    ).then((_) => _loadUsers());
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      floatingActionButton: _selectedUserIds.isEmpty
          ? FloatingActionButton.extended(
              onPressed: _openUserCreate,
              icon: const Icon(Icons.add),
              label: const Text("Kullanıcı Ekle"),
            )
          : FloatingActionButton.extended(
              onPressed: _deleteSelectedUsers,
              icon: const Icon(Icons.delete),
              backgroundColor: Colors.red,
              label: Text("${_selectedUserIds.length} Sil"),
            ),
      body: _loading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white))
              : Column(
                  children: [
                    UserFilterBar(
                      searchController: _searchCtrl,
                      selectedRole: _selectedRoleFilter,
                      onRoleChanged: (value) {
                        _selectedRoleFilter = value;
                        _onSearchChanged();
                      },
                    ),
                    Expanded(
                      child: _filteredUsers.isEmpty
                          ? Center(
                              child: Text(
                                "Kullanıcı bulunamadı.",
                                style: TextStyle(color: Colors.white70),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _loadUsers,
                              child: ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: _filteredUsers.length,
                                itemBuilder: (context, index) {
                                  final user = _filteredUsers[index];
                                  final isSelected =
                                      _selectedUserIds.contains(user.id);
                                  return UserListCard(
                                    user: user,
                                    isSelected: isSelected,
                                    onTap: () => _openUserDetail(user),
                                    onLongPress: () {
                                      setState(() {
                                        isSelected
                                            ? _selectedUserIds.remove(user.id)
                                            : _selectedUserIds.add(user.id!);
                                      });
                                    },
                                    onDelete: () => _deleteUser(user.id!),
                                    onDetail: () => _openUserDetail(user),
                                    onEdit: () => _openUserEdit(user),
                                  );
                                },
                              ),
                            ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
