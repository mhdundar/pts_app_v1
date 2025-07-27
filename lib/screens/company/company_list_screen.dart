import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pts_app_v1/models/company.dart';
import 'package:pts_app_v1/screens/company/company_create_screen.dart';
import 'package:pts_app_v1/screens/company/company_details_screen.dart';
import 'package:pts_app_v1/services/company_service.dart';

class CompanyListScreen extends StatefulWidget {
  const CompanyListScreen({super.key});

  @override
  State<CompanyListScreen> createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen> {
  List<Company> _companies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCompanies();
  }

  Future<void> _fetchCompanies() async {
    setState(() => _isLoading = true);
    try {
      _companies = await CompanyService.getAll();
    } catch (e) {
      debugPrint("Hata: $e");
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CompanyCreateScreen()),
          );
          _fetchCompanies();
        },
        icon: const Icon(Icons.add),
        label: const Text("Yeni Firma"),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : RefreshIndicator(
                    onRefresh: _fetchCompanies,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _companies.length,
                      itemBuilder: (context, index) {
                        final company = _companies[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.07),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white24),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                title: Text(
                                  company.companyName,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 6),
                                    Text(
                                      "Kod: ${company.companyCode}",
                                      style: const TextStyle(
                                          color: Colors.white70),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Lisans: ${company.lsd.toLocal().toString().split(" ")[0]} - ${company.led.toLocal().toString().split(" ")[0]}",
                                      style: const TextStyle(
                                          color: Colors.white70),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      company.isActive
                                          ? "🟢 Aktif"
                                          : "⚪️ Pasif",
                                      style: const TextStyle(
                                          color: Colors.white70),
                                    ),
                                  ],
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CompanyDetailScreen(
                                      company: company,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
