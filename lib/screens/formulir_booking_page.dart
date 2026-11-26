import 'package:flutter/material.dart';
import '../theme/pastel_theme.dart';
import '../models/booking.dart';
import '../models/service_item.dart';
import '../models/outlet_item.dart';
import '../database/db_helper.dart';
import '../services/location_service.dart';

class FormulirBookingPage extends StatefulWidget {
  final String? initialService;
  final String? initialBranch;
  final VoidCallback onBookingSuccess;
  final VoidCallback onBack;

  const FormulirBookingPage({
    super.key,
    this.initialService,
    this.initialBranch,
    required this.onBookingSuccess,
    required this.onBack,
  });

  @override
  State<FormulirBookingPage> createState() => _FormulirBookingPageState();
}

class _FormulirBookingPageState extends State<FormulirBookingPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController(text: 'Nadhira Putri');
  final TextEditingController _notesController = TextEditingController();

  final LocationService _locService = LocationService.instance;

  late ServiceItem _selectedService;
  late OutletItem _selectedOutlet;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 2));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 14, minute: 30);
  String _selectedStylist = 'Teh Kinanti A.';

  final List<String> _stylists = [
    'Teh Kinanti A. (Senior Hair Specialist)',
    'Teh Fani (Nail & Art Specialist)',
    'Teh Raisa (Facial & Glow Specialist)',
  ];

  @override
  void initState() {
    super.initState();
    _locService.addListener(_onLocationUpdate);

    // Preselect service
    if (widget.initialService != null) {
      _selectedService = ServiceCatalog.items.firstWhere(
        (s) => s.name.toLowerCase().contains(widget.initialService!.toLowerCase()),
        orElse: () => ServiceCatalog.items.first,
      );
    } else {
      _selectedService = ServiceCatalog.items.first;
    }

    // Preselect outlet
    if (widget.initialBranch != null) {
      _selectedOutlet = OutletData.outlets.firstWhere(
        (o) => o.name.toLowerCase().contains(widget.initialBranch!.toLowerCase()),
        orElse: () => OutletData.outlets.first,
      );
    } else {
      _selectedOutlet = OutletData.outlets.first;
    }
  }

  @override
  void dispose() {
    _locService.removeListener(_onLocationUpdate);
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onLocationUpdate() {
    if (mounted) setState(() {});
  }

  String _formatDate(DateTime d) {
    final days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    final dayName = days[d.weekday - 1];
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} ($dayName)';
  }

  String _formatTime(TimeOfDay t) {
    final hour = t.hour.toString().padLeft(2, '0');
    final minute = t.minute.toString().padLeft(2, '0');
    return '$hour:$minute WIB';
  }

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;

    final clientName = _nameController.text.trim();
    final newBooking = Booking(
      clientName: clientName,
      serviceName: _selectedService.name,
      servicePrice: _selectedService.price,
      branchName: _selectedOutlet.name,
      bookingDate: '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
      bookingTime: _formatTime(_selectedTime),
      stylistName: _selectedStylist.split(' (').first,
      notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
      status: 'aktif',
      syncStatus: 'LOCAL',
      userLocation: '${_locService.address} (${_locService.coordinateString})',
      createdAt: DateTime.now().toIso8601String(),
    );

    // Save to SQLite database
    await DatabaseHelper.instance.insertBooking(newBooking);

    if (!mounted) return;

    // Show Success Modal Dialog matching reference design
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _buildSuccessDialog(ctx, clientName),
    );
  }

  Widget _buildSuccessDialog(BuildContext ctx, String clientName) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(PastelTheme.radiusCardLg)),
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: PastelTheme.mintCardGradient,
                boxShadow: [
                  BoxShadow(color: Color(0x2210B981), blurRadius: 16, offset: Offset(0, 4)),
                ],
              ),
              child: const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 34),
            ),
            const SizedBox(height: 16),
            const Text(
              "Janji Temu Berhasil!",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: PastelTheme.brandDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Kami menantikan kehadiran $clientName di ${_selectedOutlet.name}. Data booking tersimpan di database SQLite lokal.",
              style: const TextStyle(
                fontSize: 12.5,
                color: PastelTheme.subtleGray,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  widget.onBookingSuccess();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: PastelTheme.brandDark,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
                  ),
                ),
                child: const Text(
                  "Lihat Detail Booking",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 160),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopHeader(),
                    const SizedBox(height: 14),
                    _buildEditorialBanner(),
                    const SizedBox(height: 16),
                    _buildGpsCard(),
                    const SizedBox(height: 18),
                    _buildNameField(),
                    const SizedBox(height: 14),
                    _buildServiceSelector(),
                    const SizedBox(height: 14),
                    _buildBranchSelector(),
                    const SizedBox(height: 14),
                    _buildScheduleSelector(),
                    const SizedBox(height: 14),
                    _buildStylistCard(),
                    const SizedBox(height: 14),
                    _buildNotesField(),
                    const SizedBox(height: 16),
                    _buildGuaranteeCard(),
                  ],
                ),
              ),
            ),
            // Floating Checkout Sticky Bottom Bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildBottomCheckoutBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        const Text(
          "Booking Checkout",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: PastelTheme.brandDark,
          ),
        ),
        Container(
          width: 38,
          height: 38,
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
    );
  }

  Widget _buildEditorialBanner() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: PastelTheme.pastelPink,
            borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
            border: Border.all(color: PastelTheme.pastelPinkBorder),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.spa_rounded, size: 14, color: PastelTheme.pastelPinkText),
              SizedBox(width: 5),
              Text(
                "RESERVASI CANTIK",
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: PastelTheme.pastelPinkText,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Lengkapi Janji Temu",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: PastelTheme.brandDark,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          "Sampurasun! Siapkan waktu manjakan diri Anda di D'Beauty Bar Bandung.",
          style: TextStyle(
            fontSize: 12,
            color: PastelTheme.subtleGray,
            height: 1.35,
          ),
        ),
      ],
    );
  }

  Widget _buildGpsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: PastelTheme.mintCardGradient,
        borderRadius: BorderRadius.circular(PastelTheme.radiusCard),
        border: Border.all(color: PastelTheme.pastelMintBorder),
        boxShadow: const [
          BoxShadow(color: Color(0x1A10B981), blurRadius: 14, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.near_me_rounded, color: Color(0xFF059669), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Deteksi Lokasi Presisi",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF064E3B),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1FAE5),
                        borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _locService.isLiveGps ? "GPS Aktif" : "GPS Sinkron",
                            style: const TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF065F46),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _locService.address,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF064E3B), fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, size: 12, color: Color(0xFF059669)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        "Koordinat: ${_locService.coordinateString}",
                        style: const TextStyle(fontSize: 10, color: Color(0xFF047857), fontStyle: FontStyle.italic),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    InkWell(
                      onTap: () => _locService.syncLocation(),
                      child: const Text(
                        "Sinkronkan",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF065F46),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(PastelTheme.radiusCard),
        border: Border.all(color: PastelTheme.borderSoft),
        boxShadow: PastelTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Nama Lengkap *",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: PastelTheme.brandDark,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.check_circle_rounded, size: 13, color: Color(0xFF10B981)),
                  SizedBox(width: 3),
                  Text(
                    "Valid",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _nameController,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: PastelTheme.brandDark),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFFAF7F5),
              prefixIcon: const Icon(Icons.person_outline_rounded, size: 18, color: PastelTheme.subtleGray),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
            validator: (v) {
              if (v == null || v.trim().length < 3) {
                return 'Nama minimal 3 karakter';
              }
              return null;
            },
          ),
          const SizedBox(height: 4),
          const Text(
            "Nama pemesan untuk konfirmasi di resepsionis",
            style: TextStyle(fontSize: 10, color: PastelTheme.mutedText),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(PastelTheme.radiusCard),
        border: Border.all(color: PastelTheme.borderSoft),
        boxShadow: PastelTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Pilihan Layanan *",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: PastelTheme.brandDark),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF7F5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<ServiceItem>(
                value: _selectedService,
                isExpanded: true,
                icon: const Icon(Icons.expand_more_rounded, color: PastelTheme.subtleGray),
                items: ServiceCatalog.items.map((s) {
                  return DropdownMenuItem<ServiceItem>(
                    value: s,
                    child: Text(
                      "${s.name} (${s.formattedPrice})",
                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: PastelTheme.brandDark),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedService = val;
                    });
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.schedule_rounded, size: 12, color: PastelTheme.mutedText),
              const SizedBox(width: 4),
              Text(
                "Estimasi durasi: ${_selectedService.durationMinutes} menit relaksasi total",
                style: const TextStyle(fontSize: 11, color: PastelTheme.subtleGray),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBranchSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: PastelTheme.pinkCardGradient,
        borderRadius: BorderRadius.circular(PastelTheme.radiusCard),
        border: Border.all(color: PastelTheme.pastelPinkBorder),
        boxShadow: PastelTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Pilihan Cabang Outlet *",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: PastelTheme.brandDark),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: PastelTheme.pastelPinkBorder),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<OutletItem>(
                value: _selectedOutlet,
                isExpanded: true,
                icon: const Icon(Icons.expand_more_rounded, color: PastelTheme.pastelPinkText),
                items: OutletData.outlets.map((o) {
                  final distText = _locService.getFormattedDistance(o.latitude, o.longitude);
                  return DropdownMenuItem<OutletItem>(
                    value: o,
                    child: Text(
                      "${o.name} ($distText)",
                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: PastelTheme.brandDark),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedOutlet = val;
                    });
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Row(
            children: [
              Icon(Icons.verified_rounded, size: 13, color: PastelTheme.pastelPinkText),
              SizedBox(width: 4),
              Text(
                "Free welcome cold pressed juice & artisan tea",
                style: TextStyle(fontSize: 11, color: PastelTheme.pastelPinkText, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: PastelTheme.yellowCardGradient,
        borderRadius: BorderRadius.circular(PastelTheme.radiusCard),
        border: Border.all(color: PastelTheme.pastelYellowBorder),
        boxShadow: PastelTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Jadwal Kedatangan *",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: PastelTheme.brandDark),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              // Date Chip Button
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 90)),
                    );
                    if (picked != null) {
                      setState(() => _selectedDate = picked);
                    }
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: PastelTheme.pastelYellowBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.calendar_today_rounded, size: 14, color: PastelTheme.pastelYellowText),
                            SizedBox(width: 4),
                            Text("TANGGAL", style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: PastelTheme.subtleGray)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: PastelTheme.brandDark),
                        ),
                        Text(
                          _formatDate(_selectedDate).split(' (').last.replaceAll(')', ''),
                          style: const TextStyle(fontSize: 10, color: PastelTheme.subtleGray),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Time Chip Button
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _selectedTime,
                    );
                    if (picked != null) {
                      setState(() => _selectedTime = picked);
                    }
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: PastelTheme.pastelYellowBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.schedule_rounded, size: 14, color: PastelTheme.pastelYellowText),
                            SizedBox(width: 4),
                            Text("JAM", style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: PastelTheme.subtleGray)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatTime(_selectedTime),
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: PastelTheme.brandDark),
                        ),
                        const Text(
                          "Tersedia",
                          style: TextStyle(fontSize: 10, color: Color(0xFF10B981), fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStylistCard() {
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
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: PastelTheme.pastelPink,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.face_rounded, color: PastelTheme.brandDark, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("STYLIST TERPILIH", style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: PastelTheme.subtleGray)),
                  Text(_selectedStylist.split(' (').first, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: PastelTheme.brandDark)),
                  const Text("Senior Specialist", style: TextStyle(fontSize: 11, color: PastelTheme.pastelPinkText, fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
          PopupMenuButton<String>(
            onSelected: (val) {
              setState(() => _selectedStylist = val);
            },
            itemBuilder: (ctx) => _stylists.map((s) => PopupMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 12)))).toList(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF7F5),
                borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
                border: Border.all(color: PastelTheme.borderSoft),
              ),
              child: const Text("Ubah", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: PastelTheme.brandDark)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(PastelTheme.radiusCard),
        border: Border.all(color: PastelTheme.borderSoft),
        boxShadow: PastelTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Catatan Tambahan (Opsional)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: PastelTheme.brandDark)),
              Text("Maks. 200 karakter", style: TextStyle(fontSize: 10, color: PastelTheme.mutedText)),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _notesController,
            maxLines: 3,
            maxLength: 200,
            style: const TextStyle(fontSize: 12.5, color: PastelTheme.brandDark),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFFAF7F5),
              hintText: "Misal: request nail art glitter tambahan, atau alergi alkohol...",
              hintStyle: const TextStyle(fontSize: 12, color: PastelTheme.mutedText),
              counterText: '',
              prefixIcon: const Icon(Icons.edit_note_rounded, size: 20, color: PastelTheme.subtleGray),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuaranteeCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(PastelTheme.radiusSubcard),
        border: Border.all(color: PastelTheme.borderSoft),
      ),
      child: const Row(
        children: [
          Icon(Icons.verified_user_rounded, color: PastelTheme.brandDark, size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Reservasi dilindungi garansi tepat waktu. Bebas pembatalan hingga 2 jam sebelum sesi.",
              style: TextStyle(fontSize: 11, color: PastelTheme.subtleGray, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCheckoutBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(PastelTheme.radiusCardLg)),
        border: Border.all(color: PastelTheme.borderSoft),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 30, offset: Offset(0, -4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("TOTAL ESTIMASI", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: PastelTheme.subtleGray)),
                  Row(
                    children: [
                      Text(
                        _selectedService.formattedPrice,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: PastelTheme.brandDark),
                      ),
                      const SizedBox(width: 4),
                      const Text("Nett", style: TextStyle(fontSize: 11, color: PastelTheme.mutedText)),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: PastelTheme.pastelMint,
                      borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
                      border: Border.all(color: PastelTheme.pastelMintBorder),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.lock_outline_rounded, size: 11, color: PastelTheme.pastelMintText),
                        SizedBox(width: 3),
                        Text("Bayar di Salon", style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: PastelTheme.pastelMintText)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text("Tunai / QRIS / Kartu", style: TextStyle(fontSize: 10, color: PastelTheme.subtleGray)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _submitBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: PastelTheme.brandDark,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(PastelTheme.radiusPill)),
                elevation: 4,
                shadowColor: PastelTheme.brandDark.withOpacity(0.4),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Konfirmasi & Buat Booking", style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
