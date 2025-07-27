import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pts_app_v1/screens/company/company_list_screen.dart';
import 'package:pts_app_v1/screens/customer/customer_list_screen.dart';
import 'package:pts_app_v1/screens/dashboard/dashboard_screen.dart';
import 'package:pts_app_v1/screens/orders/order_list_screen.dart';
import 'package:pts_app_v1/screens/users/user_list_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    OrderListScreen(),
    CustomerListScreen(),
    UserListScreen(),
    CompanyListScreen(),
  ];

  final List<String> _titles = const [
    "Dashboard",
    "Siparişler",
    "Müşteriler",
    "Kullanıcılar",
    "Şirketler",
  ];

  final List<IconData> _icons = const [
    Icons.dashboard,
    Icons.inventory_2,
    Icons.people,
    Icons.person,
    Icons.business,
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFF203A43),
      appBar: AppBar(
        backgroundColor: const Color(0xFF203A43),
        elevation: 0,
        centerTitle: true,
        title: Text(
          _titles[_selectedIndex],
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              // Profil, ayarlar, çıkış gibi işlevler eklenebilir
            },
            icon: const Icon(Icons.person, color: Colors.white),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.black26, // İnce alt çizgi efekti
            height: 1,
          ),
        ),
      ),
      drawer: isWide ? null : _buildDrawer(),
      body: Row(
        children: [
          if (isWide) _buildNavigationRail(),
          Expanded(child: _screens[_selectedIndex]),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF203A43),
      elevation: 0,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF203A43),
            ),
            child: Text(
              'PTS App',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          ...List.generate(
            _titles.length,
            (index) => ListTile(
              leading: Icon(_icons[index], color: Colors.white),
              title: Text(
                _titles[index],
                style: const TextStyle(color: Colors.white),
              ),
              selected: _selectedIndex == index,
              selectedTileColor: Colors.black26,
              onTap: () {
                setState(() => _selectedIndex = index);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationRail() {
    return NavigationRail(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) => setState(() => _selectedIndex = index),
      backgroundColor: const Color(0xFF203A43),
      labelType: NavigationRailLabelType.all, // Her zaman yazı + ikon
      selectedIconTheme: const IconThemeData(color: Colors.white),
      selectedLabelTextStyle: const TextStyle(color: Colors.white),
      unselectedIconTheme: const IconThemeData(color: Colors.white54),
      unselectedLabelTextStyle: const TextStyle(color: Colors.white54),
      leading: const SizedBox(height: kToolbarHeight), // AppBar hizası
      destinations: List.generate(
        _titles.length,
        (index) => NavigationRailDestination(
          icon: Icon(_icons[index]),
          label: Text(_titles[index]),
        ),
      ),
    );
  }
}
