import 'package:flutter/material.dart';
import '../theme/pastel_theme.dart';
import '../models/outlet_item.dart';
import '../services/location_service.dart';

class OutletPetaPage extends StatefulWidget {
  final Function(int tabIndex) onNavigateTab;
  final Function({String? preselectedService, String? preselectedBranch}) onOpenBookingForm;

  const OutletPetaPage({
    super.key,
    required this.onNavigateTab,
    required this.onOpenBookingForm,
  });

  @override
  State<OutletPetaPage> createState() => _OutletPetaPageState();
}

class _OutletPetaPageState extends State<OutletPetaPage> {
  String _selectedOutletId = 'dago';
  final LocationService _locService = LocationService.instance;

  @override
  void initState() {
    super.initState();
    _locService.addListener(_onLocationUpdate);
  }

  @override
  void dispose() {
    _locService.removeListener(_onLocationUpdate);
    super.dispose();
  }

  void _onLocationUpdate() {
    if (mounted) setState(() {});
  }

  Future<void> _syncGps() async {
    final success = await _locService.syncLocation();
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? "Lokasi berhasil disinkronkan: ${_locService.district}"
              : "Lokasi GPS Bandung aktif: ${_locService.district}",
          style: const TextStyle(fontSize: 12),
        ),
        backgroundColor: PastelTheme.brandDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(PastelTheme.radiusPill)),
        duration: const Duration(seconds: 2),
      ),
    );
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
              _buildCurrentLocationBanner(),
              const SizedBox(height: 16),
              _buildInteractiveMap(),
              const SizedBox(height: 20),
              _buildOutletsSection(),
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
                  errorBuilder: (_, _, _) => const Icon(Icons.spa_rounded, color: PastelTheme.pastelPinkText),
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "D'Beauty Bar",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: PastelTheme.brandDark),
                ),
                Text(
                  "Bandung • Outlet & Peta",
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: PastelTheme.subtleGray),
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
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.notifications_outlined, size: 20, color: PastelTheme.brandDark),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 7,
                      height: 7,
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
                child: Icon(Icons.person_rounded, color: PastelTheme.brandDark, size: 20),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCurrentLocationBanner() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  "LOKASI KAMU SAAT INI",
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: PastelTheme.subtleGray, letterSpacing: 0.5),
                ),
              ],
            ),
            InkWell(
              onTap: _locService.isSyncing ? null : _syncGps,
              borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
                  border: Border.all(color: PastelTheme.borderSoft),
                  boxShadow: PastelTheme.softShadow,
                ),
                child: Row(
                  children: [
                    _locService.isSyncing
                        ? const SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(strokeWidth: 1.5, color: PastelTheme.brandDark),
                          )
                        : const Icon(Icons.sync_rounded, size: 14, color: PastelTheme.brandDark),
                    const SizedBox(width: 5),
                    Text(
                      _locService.isSyncing ? "Menyinkronkan..." : "Sinkronkan GPS",
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: PastelTheme.brandDark),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(PastelTheme.radiusCard),
            border: Border.all(color: PastelTheme.borderSoft),
            boxShadow: PastelTheme.softShadow,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: PastelTheme.pastelPink,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.location_on_rounded, color: PastelTheme.pastelPinkText, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            _locService.district,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: PastelTheme.brandDark),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5EE),
                            borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
                          ),
                          child: Text(
                            "±${_locService.accuracyMeters.toInt()}m",
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF059669)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _locService.address,
                      style: const TextStyle(fontSize: 11.5, color: PastelTheme.subtleGray),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Koordinat: ${_locService.coordinateString}",
                      style: const TextStyle(fontSize: 9.5, color: PastelTheme.mutedText),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInteractiveMap() {
    return Container(
      width: double.infinity,
      height: 280,
      decoration: BoxDecoration(
        color: const Color(0xFFFDFBF9),
        borderRadius: BorderRadius.circular(PastelTheme.radiusCardLg),
        border: Border.all(color: PastelTheme.borderSoft),
        boxShadow: PastelTheme.softShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(PastelTheme.radiusCardLg),
        child: Stack(
          children: [
            // Custom Artistic Map Canvas
            CustomPaint(
              size: const Size(double.infinity, 280),
              painter: BandungMapPainter(),
            ),
            // User Location Marker ("Kamu Di Sini")
            Positioned(
              left: 170,
              top: 95,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: PastelTheme.brandDark,
                      borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
                      boxShadow: PastelTheme.softShadow,
                    ),
                    child: const Text(
                      "Kamu Di Sini",
                      style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: PastelTheme.brandDark,
                      shape: BoxShape.circle,
                      boxShadow: PastelTheme.softShadow,
                    ),
                    child: const Icon(Icons.person_pin_rounded, color: Colors.white, size: 16),
                  ),
                ],
              ),
            ),
            // Pin 1: Dago
            _buildMapPin(
              outletId: 'dago',
              label: "1 • Dago",
              number: "1",
              left: 200,
              top: 40,
              bgColor: PastelTheme.pastelPink,
              textColor: PastelTheme.pastelPinkText,
            ),
            // Pin 2: Riau
            _buildMapPin(
              outletId: 'riau',
              label: "2 • Riau",
              number: "2",
              left: 240,
              top: 145,
              bgColor: PastelTheme.pastelMint,
              textColor: PastelTheme.pastelMintText,
            ),
            // Pin 3: Braga
            _buildMapPin(
              outletId: 'braga',
              label: "3 • Braga",
              number: "3",
              left: 110,
              top: 180,
              bgColor: PastelTheme.pastelYellow,
              textColor: PastelTheme.pastelYellowText,
            ),
            // Pin 4: Setiabudi
            _buildMapPin(
              outletId: 'setiabudi',
              label: "4 • Setiabudi",
              number: "4",
              left: 70,
              top: 45,
              bgColor: PastelTheme.pastelPink,
              textColor: PastelTheme.pastelPinkText,
            ),
            // Pin 5: Buah Batu
            _buildMapPin(
              outletId: 'buah-batu',
              label: "5 • Buah Batu",
              number: "5",
              left: 220,
              top: 215,
              bgColor: PastelTheme.pastelMint,
              textColor: PastelTheme.pastelMintText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapPin({
    required String outletId,
    required String label,
    required String number,
    required double left,
    required double top,
    required Color bgColor,
    required Color textColor,
  }) {
    final isSelected = _selectedOutletId == outletId;

    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedOutletId = outletId;
          });
        },
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
                border: Border.all(color: isSelected ? PastelTheme.brandDark : bgColor, width: isSelected ? 1.5 : 1),
                boxShadow: PastelTheme.softShadow,
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Container(
              width: isSelected ? 34 : 28,
              height: isSelected ? 34 : 28,
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: const [
                  BoxShadow(color: Color(0x33000000), blurRadius: 8, offset: Offset(0, 2)),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                number,
                style: TextStyle(
                  fontSize: isSelected ? 13 : 11,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutletsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Semua Outlet Bandung",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: PastelTheme.brandDark),
            ),
            Text(
              "${OutletData.outlets.length} Lokasi",
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: PastelTheme.subtleGray),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...OutletData.outlets.map((outlet) => _buildOutletCard(outlet)),
      ],
    );
  }

  Widget _buildOutletCard(OutletItem outlet) {
    final isSelected = _selectedOutletId == outlet.id;

    // Synchronized dynamic distance from user location
    final dynamicDistance = _locService.getFormattedDistance(outlet.latitude, outlet.longitude);
    final distanceKm = _locService.calculateDistanceKm(outlet.latitude, outlet.longitude);
    final isClosest = distanceKm < 1.0;

    LinearGradient cardGrad;
    Color borderColor;

    if (outlet.colorTheme == 'pink') {
      cardGrad = PastelTheme.pinkCardGradient;
      borderColor = PastelTheme.pastelPinkBorder;
    } else if (outlet.colorTheme == 'mint') {
      cardGrad = PastelTheme.mintCardGradient;
      borderColor = PastelTheme.pastelMintBorder;
    } else {
      cardGrad = PastelTheme.yellowCardGradient;
      borderColor = PastelTheme.pastelYellowBorder;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: cardGrad,
        borderRadius: BorderRadius.circular(PastelTheme.radiusCard),
        border: Border.all(
          color: isSelected ? PastelTheme.brandDark : borderColor,
          width: isSelected ? 1.8 : 1,
        ),
        boxShadow: PastelTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "${outlet.pinNumber}",
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: PastelTheme.brandDark),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        outlet.name,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: PastelTheme.brandDark),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
                  boxShadow: PastelTheme.softShadow,
                ),
                child: Text(
                  isClosest ? "Terdekat • $dynamicDistance" : dynamicDistance,
                  style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: PastelTheme.brandDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            outlet.address,
            style: const TextStyle(fontSize: 12, color: PastelTheme.subtleGray, height: 1.3),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time_rounded, size: 13, color: PastelTheme.subtleGray),
              const SizedBox(width: 5),
              Text(
                "Jam Buka: ${outlet.openHours}",
                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: PastelTheme.brandDark),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Facilities tags
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: outlet.facilities.map((f) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
                ),
                child: Text(
                  f,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: PastelTheme.brandDark),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          // Booking action
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onOpenBookingForm(preselectedBranch: outlet.name);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: PastelTheme.brandDark,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(PastelTheme.radiusPill)),
                elevation: 2,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Booking di Outlet Ini", style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward_rounded, size: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BandungMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Parks & Lakes
    final greenPaint = Paint()
      ..color = const Color(0xFFEBF6F0)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width * 0.15, size.height * 0.7), 40, greenPaint);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.2), 35, greenPaint);

    final pinkPaint = Paint()
      ..color = const Color(0xFFFDEAEB)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.25), 30, pinkPaint);

    // Main Roads
    final roadBase = Paint()
      ..color = const Color(0xFFEDE8E3)
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final roadWhite = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Pasupati Flyover (Horizontal)
    final pathPasupati = Path()
      ..moveTo(0, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.48, size.width, size.height * 0.52);

    canvas.drawPath(pathPasupati, roadBase);
    canvas.drawPath(pathPasupati, roadWhite);

    // Dago Spine (North-South)
    final pathDago = Path()
      ..moveTo(size.width * 0.55, 0)
      ..lineTo(size.width * 0.52, size.height);

    canvas.drawPath(pathDago, roadBase);
    canvas.drawPath(pathDago, roadWhite);

    // Setiabudi Diagonal
    final pathSetiabudi = Path()
      ..moveTo(size.width * 0.2, 0)
      ..lineTo(size.width * 0.48, size.height * 0.5);

    canvas.drawPath(pathSetiabudi, roadBase);
    canvas.drawPath(pathSetiabudi, roadWhite);

    // Braga & Buah Batu
    final pathSouth = Path()
      ..moveTo(size.width * 0.5, size.height * 0.5)
      ..lineTo(size.width * 0.75, size.height);

    canvas.drawPath(pathSouth, roadBase);
    canvas.drawPath(pathSouth, roadWhite);

    // Landmark text labels
    _drawLabel(canvas, "DAGO", Offset(size.width * 0.58, 20));
    _drawLabel(canvas, "PASUPATI", Offset(size.width * 0.35, size.height * 0.44));
    _drawLabel(canvas, "GEDUNG SATE", Offset(size.width * 0.6, size.height * 0.58));
    _drawLabel(canvas, "BRAGA", Offset(size.width * 0.25, size.height * 0.8));
    _drawLabel(canvas, "BUAH BATU", Offset(size.width * 0.65, size.height * 0.88));
  }

  void _drawLabel(Canvas canvas, String text, Offset offset) {
    const textStyle = TextStyle(
      color: Color(0xFFA1A1AA),
      fontSize: 8.5,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
    );
    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
