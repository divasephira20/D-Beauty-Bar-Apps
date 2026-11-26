import 'package:flutter/material.dart';
import '../theme/pastel_theme.dart';
import 'beranda_page.dart';
import 'outlet_peta_page.dart';
import 'katalog_page.dart';
import 'daftar_booking_page.dart';
import 'formulir_booking_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  bool _isBookingFormOpen = false;
  String? _preselectedService;
  String? _preselectedBranch;

  void _onNavigateTab(int index) {
    setState(() {
      _currentIndex = index;
      _isBookingFormOpen = false;
    });
  }

  void _openBookingForm({String? preselectedService, String? preselectedBranch}) {
    setState(() {
      _preselectedService = preselectedService;
      _preselectedBranch = preselectedBranch;
      _isBookingFormOpen = true;
    });
  }

  void _closeBookingForm() {
    setState(() {
      _isBookingFormOpen = false;
    });
  }

  void _onBookingSuccess() {
    setState(() {
      _isBookingFormOpen = false;
      _currentIndex = 3; // Navigate to Daftar Booking Saya
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: PastelTheme.screenGradient,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                // Main Views IndexedStack
                IndexedStack(
                  index: _currentIndex,
                  children: [
                    BerandaPage(
                      onNavigateTab: _onNavigateTab,
                      onOpenBookingForm: _openBookingForm,
                    ),
                    OutletPetaPage(
                      onNavigateTab: _onNavigateTab,
                      onOpenBookingForm: _openBookingForm,
                    ),
                    KatalogPage(
                      onNavigateTab: _onNavigateTab,
                      onOpenBookingForm: _openBookingForm,
                    ),
                    DaftarBookingPage(
                      onNewBooking: () => _openBookingForm(),
                      onBack: () => _onNavigateTab(0),
                    ),
                  ],
                ),

                // Formulir Booking Slide-in Overlay
                if (_isBookingFormOpen)
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: PastelTheme.screenGradient,
                      ),
                      child: FormulirBookingPage(
                        initialService: _preselectedService,
                        initialBranch: _preselectedBranch,
                        onBookingSuccess: _onBookingSuccess,
                        onBack: _closeBookingForm,
                      ),
                    ),
                  ),

                // Floating Capsule Navigation Dock (hidden when checkout form is active)
                if (!_isBookingFormOpen)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 24,
                    child: _buildFloatingCapsuleDock(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingCapsuleDock() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.96),
          borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
          border: Border.all(color: Colors.black.withOpacity(0.06)),
          boxShadow: PastelTheme.dockShadow,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDockIcon(0, Icons.home_rounded),
            const SizedBox(width: 14),
            _buildDockIcon(1, Icons.near_me_rounded),
            const SizedBox(width: 14),
            _buildDockIcon(2, Icons.grid_view_rounded),
            const SizedBox(width: 14),
            _buildDockIcon(3, Icons.calendar_today_rounded),
          ],
        ),
      ),
    );
  }

  Widget _buildDockIcon(int index, IconData icon) {
    final isSelected = _currentIndex == index;

    if (isSelected) {
      return Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: PastelTheme.brandDark,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      );
    }

    return InkWell(
      onTap: () => _onNavigateTab(index),
      borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        child: Icon(icon, color: PastelTheme.subtleGray, size: 22),
      ),
    );
  }
}
