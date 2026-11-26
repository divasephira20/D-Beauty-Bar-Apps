import 'package:flutter/material.dart';
import '../theme/pastel_theme.dart';
import '../models/booking.dart';
import '../database/db_helper.dart';

class DaftarBookingPage extends StatefulWidget {
  final VoidCallback onNewBooking;
  final VoidCallback onBack;

  const DaftarBookingPage({
    super.key,
    required this.onNewBooking,
    required this.onBack,
  });

  @override
  State<DaftarBookingPage> createState() => _DaftarBookingPageState();
}

class _DaftarBookingPageState extends State<DaftarBookingPage> {
  String _activeFilter = 'semua';
  List<Booking> _bookings = [];
  bool _isLoading = true;
  int _totalCount = 0;
  int _activeCount = 0;
  int _doneCount = 0;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    setState(() => _isLoading = true);
    try {
      final all = await DatabaseHelper.instance.getAllBookings();
      final filtered = await DatabaseHelper.instance.getAllBookings(status: _activeFilter);

      final total = all.length;
      final active = all.where((b) => b.status == 'aktif').length;
      final done = all.where((b) => b.status == 'selesai').length;

      if (mounted) {
        setState(() {
          _bookings = filtered;
          _totalCount = total;
          _activeCount = active;
          _doneCount = done;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _toggleStatus(Booking b) async {
    final newStatus = b.status == 'aktif' ? 'selesai' : 'aktif';
    await DatabaseHelper.instance.updateBookingStatus(b.id!, newStatus);
    _loadBookings();
  }

  Future<void> _deleteBooking(Booking b) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(PastelTheme.radiusCard)),
        title: const Text("Batalkan Reservasi?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Text("Apakah Anda yakin ingin membatalkan booking '${b.serviceName}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Kembali", style: TextStyle(color: PastelTheme.subtleGray)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(PastelTheme.radiusPill)),
            ),
            child: const Text("Batalkan"),
          ),
        ],
      ),
    );

    if (confirmed == true && b.id != null) {
      await DatabaseHelper.instance.deleteBooking(b.id!);
      _loadBookings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopHeader(),
              const SizedBox(height: 16),
              _buildEditorialHeader(),
              const SizedBox(height: 16),
              _buildFilterTabs(),
              const SizedBox(height: 18),
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(color: PastelTheme.brandDark, strokeWidth: 2),
                  ),
                )
              else if (_bookings.isEmpty)
                _buildEmptyState()
              else
                _buildBookingsList(),
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
        Row(
          children: [
            InkWell(
              onTap: widget.onBack,
              borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: PastelTheme.borderSoft),
                  boxShadow: PastelTheme.softShadow,
                ),
                child: const Icon(Icons.arrow_back_rounded, size: 20, color: PastelTheme.brandDark),
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "D'Beauty Bar",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: PastelTheme.brandDark),
                ),
                Text(
                  "Bandung • Reservasi",
                  style: TextStyle(fontSize: 11, color: PastelTheme.subtleGray, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: PastelTheme.borderSoft),
                boxShadow: PastelTheme.softShadow,
              ),
              child: const Icon(Icons.favorite_rounded, size: 20, color: PastelTheme.pastelPinkText),
            ),
            const SizedBox(width: 8),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: PastelTheme.borderSoft),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const Icon(
                    Icons.spa_rounded,
                    color: PastelTheme.pastelPinkText,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEditorialHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
                border: Border.all(color: PastelTheme.borderSoft),
                boxShadow: PastelTheme.softShadow,
              ),
              child: const Row(
                children: [
                  Icon(Icons.auto_awesome_rounded, size: 14, color: Colors.pinkAccent),
                  SizedBox(width: 4),
                  Text(
                    "BEAUTY BAR SCHEDULE",
                    style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: PastelTheme.brandDark, letterSpacing: 0.5),
                  ),
                ],
              ),
            ),
            // SQLite Aktif Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
                boxShadow: PastelTheme.softShadow,
              ),
              child: Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    "SQLite Aktif",
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: PastelTheme.brandDark),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          "Daftar Booking Saya - D'Beauty Bar",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: PastelTheme.brandDark, height: 1.2),
        ),
        const SizedBox(height: 4),
        const Text(
          "Jadwal relaksasi & perawatan diri Anda di Bandung.",
          style: TextStyle(fontSize: 12.5, color: PastelTheme.subtleGray),
        ),
      ],
    );
  }

  Widget _buildFilterTabs() {
    return Row(
      children: [
        _buildFilterChip("semua", "Semua ($_totalCount)", Icons.all_inclusive_rounded),
        const SizedBox(width: 8),
        _buildFilterChip("aktif", "Aktif ($_activeCount)", Icons.schedule_rounded),
        const SizedBox(width: 8),
        _buildFilterChip("selesai", "Selesai ($_doneCount)", Icons.task_alt_rounded),
      ],
    );
  }

  Widget _buildFilterChip(String key, String label, IconData icon) {
    final isSelected = _activeFilter == key;
    return InkWell(
      onTap: () {
        setState(() {
          _activeFilter = key;
        });
        _loadBookings();
      },
      borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected ? PastelTheme.charcoalButtonGradient : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
          border: isSelected ? null : Border.all(color: PastelTheme.borderSoft),
          boxShadow: isSelected ? PastelTheme.charcoalButtonShadow : PastelTheme.softShadow,
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: isSelected ? Colors.white : PastelTheme.subtleGray),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? Colors.white : PastelTheme.subtleGray,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsList() {
    return Column(
      children: _bookings.map((booking) => _buildBookingCard(booking)).toList(),
    );
  }

  Widget _buildBookingCard(Booking b) {
    LinearGradient cardGrad;
    Color borderColor;
    Color iconColor;
    String statusBadge;

    if (b.status == 'selesai') {
      cardGrad = PastelTheme.yellowCardGradient;
      borderColor = PastelTheme.pastelYellowBorder;
      iconColor = PastelTheme.pastelYellowText;
      statusBadge = "Selesai";
    } else if (b.serviceName.toLowerCase().contains('hair') || b.serviceName.toLowerCase().contains('treatment')) {
      cardGrad = PastelTheme.mintCardGradient;
      borderColor = PastelTheme.pastelMintBorder;
      iconColor = PastelTheme.pastelMintText;
      statusBadge = "Treatment";
    } else {
      cardGrad = PastelTheme.pinkCardGradient;
      borderColor = PastelTheme.pastelPinkBorder;
      iconColor = PastelTheme.pastelPinkText;
      statusBadge = "Segera";
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: cardGrad,
        borderRadius: BorderRadius.circular(PastelTheme.radiusCard),
        border: Border.all(color: borderColor),
        boxShadow: PastelTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Badges & Delete Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
                      boxShadow: PastelTheme.softShadow,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          b.syncStatus == 'LOCAL' ? Icons.cloud_off_rounded : Icons.cloud_done_rounded,
                          size: 11,
                          color: b.syncStatus == 'LOCAL' ? const Color(0xFFF43F5E) : Colors.teal,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          b.syncStatus,
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: PastelTheme.brandDark),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
                      boxShadow: PastelTheme.softShadow,
                    ),
                    child: Text(
                      statusBadge,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: b.status == 'selesai' ? const Color(0xFFD97706) : iconColor,
                      ),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => _deleteBooking(b),
                borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: PastelTheme.softShadow,
                  ),
                  child: const Icon(Icons.close_rounded, size: 16, color: PastelTheme.subtleGray),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Main Info with Icon
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: PastelTheme.softShadow,
                ),
                child: Icon(Icons.spa_rounded, color: iconColor, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      b.serviceName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: PastelTheme.brandDark,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.person_outline_rounded, size: 13, color: PastelTheme.subtleGray),
                        const SizedBox(width: 4),
                        Text(
                          "Atas nama: ${b.clientName}",
                          style: const TextStyle(fontSize: 11.5, color: PastelTheme.subtleGray),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Details Sub-pill (Date, Time, Branch)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(PastelTheme.radiusSubcard),
              border: Border.all(color: Colors.white),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 13, color: iconColor),
                    const SizedBox(width: 6),
                    Text(b.bookingDate, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: PastelTheme.brandDark)),
                    const SizedBox(width: 8),
                    const Text("•", style: TextStyle(color: PastelTheme.subtleGray)),
                    const SizedBox(width: 8),
                    Icon(Icons.schedule_rounded, size: 13, color: iconColor),
                    const SizedBox(width: 4),
                    Text(b.bookingTime, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: PastelTheme.brandDark)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.storefront_rounded, size: 14, color: iconColor),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        b.branchName,
                        style: const TextStyle(fontSize: 11.5, color: PastelTheme.brandDark, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (b.userLocation != null && b.userLocation!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.near_me_rounded, size: 12, color: iconColor.withOpacity(0.8)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "GPS: ${b.userLocation}",
                          style: const TextStyle(fontSize: 10, color: PastelTheme.subtleGray),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          // Notes quote tag
          if (b.notes != null && b.notes!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.65),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.format_quote_rounded, size: 14, color: iconColor),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '"${b.notes}"',
                      style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: PastelTheme.brandDark),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          // Action Buttons: Selesai toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Rp ${(b.servicePrice / 1000).toInt()}.000",
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: PastelTheme.brandDark),
              ),
              const Spacer(),
              InkWell(
                onTap: () => _toggleStatus(b),
                borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: b.status == 'selesai' ? Colors.white : PastelTheme.brandDark,
                    borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
                    border: b.status == 'selesai' ? Border.all(color: PastelTheme.borderSoft) : null,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        b.status == 'selesai' ? Icons.restart_alt_rounded : Icons.check_circle_outline_rounded,
                        size: 13,
                        color: b.status == 'selesai' ? PastelTheme.brandDark : Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        b.status == 'selesai' ? "Buka Kembali" : "Tandai Selesai",
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: b.status == 'selesai' ? PastelTheme.brandDark : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: PastelTheme.borderSoft),
            ),
            child: const Icon(Icons.event_busy_rounded, size: 28, color: PastelTheme.subtleGray),
          ),
          const SizedBox(height: 14),
          const Text(
            "Tidak Ada Booking di Kategori Ini",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: PastelTheme.brandDark),
          ),
          const SizedBox(height: 6),
          const Text(
            "Pilih treatment favorit dan jadwalkan sesi kecantikan Anda.",
            style: TextStyle(fontSize: 12, color: PastelTheme.subtleGray),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: widget.onNewBooking,
            style: ElevatedButton.styleFrom(
              backgroundColor: PastelTheme.brandDark,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(PastelTheme.radiusPill)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text("Booking Sekarang", style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
