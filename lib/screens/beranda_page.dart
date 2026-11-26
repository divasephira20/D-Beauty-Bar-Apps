import 'package:flutter/material.dart';
import '../theme/pastel_theme.dart';
import '../models/booking.dart';
import '../database/db_helper.dart';

class BerandaPage extends StatefulWidget {
  final Function(int tabIndex) onNavigateTab;
  final Function({String? preselectedService, String? preselectedBranch}) onOpenBookingForm;

  const BerandaPage({
    super.key,
    required this.onNavigateTab,
    required this.onOpenBookingForm,
  });

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  Booking? _latestBooking;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLatestBooking();
  }

  Future<void> _loadLatestBooking() async {
    try {
      final b = await DatabaseHelper.instance.getLatestActiveBooking();
      if (mounted) {
        setState(() {
          _latestBooking = b;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopHeader(),
              const SizedBox(height: 18),
              _buildEditorialGreeting(),
              const SizedBox(height: 20),
              _buildHeroPromoCard(),
              const SizedBox(height: 24),
              _buildQuickMenu(),
              const SizedBox(height: 24),
              _buildScheduledAppointmentSection(),
              const SizedBox(height: 20),
              _buildStylistHighlight(),
              const SizedBox(height: 20),
              _buildGuaranteeBanner(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: PastelTheme.borderSoft),
                  boxShadow: PastelTheme.softShadow,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const Icon(
                      Icons.spa_rounded,
                      color: PastelTheme.pastelPinkText,
                      size: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "D'Beauty Bar Bandung",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: PastelTheme.brandDark,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Dago • Braga • Riau",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: PastelTheme.subtleGray,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Notification Button with red dot
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: PastelTheme.borderSoft),
                boxShadow: PastelTheme.softShadow,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.notifications_outlined,
                    size: 20,
                    color: PastelTheme.brandDark,
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Profile Avatar
            Container(
              width: 40,
              height: 40,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: PastelTheme.borderSoft),
              ),
              child: const CircleAvatar(
                backgroundColor: PastelTheme.pastelPink,
                child: Icon(
                  Icons.person_rounded,
                  color: PastelTheme.brandDark,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEditorialGreeting() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: PastelTheme.pastelPink,
                  borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
                  border: Border.all(color: PastelTheme.pastelPinkBorder),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1AF43F5E),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Sampurasun, Cantik!",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: PastelTheme.pastelPinkText,
                        letterSpacing: 0.2,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text("✨", style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    color: PastelTheme.brandDark,
                    height: 1.15,
                  ),
                  children: [
                    TextSpan(
                      text: "Beauty as always\n",
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    TextSpan(
                      text: "starts from here",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                        color: PastelTheme.subtleGray,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // Quick Calendar action
        InkWell(
          onTap: () => widget.onNavigateTab(3), // Go to Booking Saya
          borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: PastelTheme.borderSoft),
              boxShadow: PastelTheme.softShadow,
            ),
            child: const Icon(
              Icons.calendar_today_rounded,
              size: 20,
              color: PastelTheme.brandDark,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroPromoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: PastelTheme.heroCardGradient,
        borderRadius: BorderRadius.circular(PastelTheme.radiusCardLg),
        border: Border.all(color: Colors.white.withOpacity(0.8)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3DF6C4CB),
            blurRadius: 28,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
                  boxShadow: PastelTheme.softShadow,
                ),
                child: const Text(
                  "PROMO BULAN INI",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: PastelTheme.brandDark,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.timer_outlined, size: 12, color: PastelTheme.subtleGray),
                    SizedBox(width: 4),
                    Text(
                      "Sisa 4 Hari",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: PastelTheme.subtleGray,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "Diskon 25% Korean Glass Hair & Gel Polish Classic",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: PastelTheme.brandDark,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Berlaku di seluruh outlet Dago, Braga, Riau, Buah Batu & Setiabudi.",
            style: TextStyle(
              fontSize: 12,
              color: PastelTheme.subtleGray,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // High-Contrast Charcoal Pill CTA
              InkWell(
                onTap: () => widget.onOpenBookingForm(preselectedService: 'Korean Glass Hair'),
                borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: PastelTheme.charcoalButtonGradient,
                    borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
                    boxShadow: PastelTheme.charcoalButtonShadow,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        size: 16,
                        color: PastelTheme.pastelYellow,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Booking Sekarang",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Circular discount tag
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.95),
                  border: Border.all(color: Colors.white),
                  boxShadow: PastelTheme.softShadow,
                ),
                alignment: Alignment.center,
                child: const Text(
                  "-25%",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: PastelTheme.brandDark,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Menu Cepat",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: PastelTheme.brandDark,
              ),
            ),
            Text(
              "3 Pilihan",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: PastelTheme.subtleGray,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // 1. Soft Blush Pink - Katalog
            Expanded(
              child: _buildQuickActionCard(
                title: "Katalog",
                subtitle: "6 Kategori",
                icon: Icons.content_cut_rounded,
                gradient: PastelTheme.pinkCardGradient,
                borderColor: PastelTheme.pastelPinkBorder,
                onTap: () => widget.onNavigateTab(2), // Tab Katalog
              ),
            ),
            const SizedBox(width: 10),
            // 2. Matcha Mint - Jadwal (Booking Saya)
            Expanded(
              child: _buildQuickActionCard(
                title: "Jadwal",
                subtitle: "Booking Saya",
                icon: Icons.event_available_rounded,
                gradient: PastelTheme.mintCardGradient,
                borderColor: PastelTheme.pastelMintBorder,
                onTap: () => widget.onNavigateTab(3), // Tab Booking Saya
              ),
            ),
            const SizedBox(width: 10),
            // 3. Butter Yellow - Outlet & Peta
            Expanded(
              child: _buildQuickActionCard(
                title: "Outlet",
                subtitle: "5 Lokasi",
                icon: Icons.near_me_rounded,
                gradient: PastelTheme.yellowCardGradient,
                borderColor: PastelTheme.pastelYellowBorder,
                onTap: () => widget.onNavigateTab(1), // Tab Outlet
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required LinearGradient gradient,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(PastelTheme.radiusCard),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(PastelTheme.radiusCard),
          border: Border.all(color: borderColor),
          boxShadow: PastelTheme.softShadow,
        ),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: PastelTheme.softShadow,
              ),
              child: Icon(icon, color: PastelTheme.brandDark, size: 20),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: PastelTheme.brandDark,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: PastelTheme.subtleGray,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduledAppointmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  const Flexible(
                    child: Text(
                      "Janji Temu Terjadwal",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: PastelTheme.brandDark,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () => widget.onNavigateTab(3),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Lihat Semua",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: PastelTheme.brandDark,
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(Icons.arrow_forward_rounded, size: 14, color: PastelTheme.brandDark),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(color: PastelTheme.brandDark, strokeWidth: 2),
            ),
          )
        else if (_latestBooking != null)
          InkWell(
            onTap: () => widget.onNavigateTab(3),
            borderRadius: BorderRadius.circular(PastelTheme.radiusCard),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(PastelTheme.radiusCard),
                border: Border.all(color: PastelTheme.borderSoft),
                boxShadow: PastelTheme.softShadow,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: PastelTheme.pastelPink,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.face_retouching_natural_rounded,
                      color: PastelTheme.brandDark,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _latestBooking!.serviceName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: PastelTheme.brandDark,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: PastelTheme.pastelMint,
                                borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
                              ),
                              child: const Text(
                                "TERKONFIRMASI",
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: PastelTheme.pastelMintText,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.schedule_rounded, size: 14, color: PastelTheme.subtleGray),
                            const SizedBox(width: 4),
                            Text(
                              "${_latestBooking!.bookingDate} • ${_latestBooking!.bookingTime}",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: PastelTheme.brandDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded, size: 14, color: PastelTheme.subtleGray),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                _latestBooking!.branchName,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  color: PastelTheme.subtleGray,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: PastelTheme.background,
                      border: Border.all(color: PastelTheme.borderSoft),
                    ),
                    child: const Icon(Icons.chevron_right_rounded, size: 18, color: PastelTheme.brandDark),
                  ),
                ],
              ),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(PastelTheme.radiusCard),
              border: Border.all(color: PastelTheme.borderSoft),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_month_rounded, color: PastelTheme.subtleGray),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Belum ada janji temu aktif. Booking treatment sekarang!",
                    style: TextStyle(fontSize: 12, color: PastelTheme.subtleGray),
                  ),
                ),
                TextButton(
                  onPressed: () => widget.onOpenBookingForm(),
                  child: const Text("Booking", style: TextStyle(fontWeight: FontWeight.bold, color: PastelTheme.brandDark)),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildStylistHighlight() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(PastelTheme.radiusCard),
        border: Border.all(color: PastelTheme.borderSoft),
        boxShadow: PastelTheme.softShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: PastelTheme.pastelPink,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.person_pin_rounded,
                    color: PastelTheme.brandDark,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "STYLIST PILIHAN",
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: PastelTheme.subtleGray,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Teh Kinanti A.",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: PastelTheme.brandDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "Senior Hair & Treatment Specialist",
                        style: TextStyle(
                          fontSize: 11,
                          color: PastelTheme.pastelPinkText,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => widget.onOpenBookingForm(),
            borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: PastelTheme.background,
                borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
                border: Border.all(color: PastelTheme.borderSoft),
              ),
              child: const Text(
                "Pilih",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: PastelTheme.brandDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuaranteeBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(PastelTheme.radiusSubcard),
        border: Border.all(color: PastelTheme.borderSoft),
      ),
      child: const Row(
        children: [
          Icon(Icons.verified_user_rounded, color: PastelTheme.brandDark, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Reservasi dilindungi garansi tepat waktu. Bebas pembatalan hingga 2 jam sebelum sesi.",
              style: TextStyle(
                fontSize: 11,
                color: PastelTheme.subtleGray,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
