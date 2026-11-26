import 'package:flutter/material.dart';
import '../theme/pastel_theme.dart';
import '../models/service_item.dart';

class KatalogPage extends StatefulWidget {
  final Function(int tabIndex) onNavigateTab;
  final Function({String? preselectedService, String? preselectedBranch}) onOpenBookingForm;

  const KatalogPage({
    super.key,
    required this.onNavigateTab,
    required this.onOpenBookingForm,
  });

  @override
  State<KatalogPage> createState() => _KatalogPageState();
}

class _KatalogPageState extends State<KatalogPage> {
  String _activeCategory = 'all';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _wishlist = {};

  final List<Map<String, String>> _categories = [
    {'id': 'all', 'label': 'Semua'},
    {'id': 'hair', 'label': 'Hair'},
    {'id': 'nails', 'label': 'Nails'},
    {'id': 'makeup', 'label': 'Makeup'},
    {'id': 'facial', 'label': 'Facial'},
    {'id': 'lash', 'label': 'Lash'},
    {'id': 'waxing', 'label': 'Waxing'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ServiceItem> get _filteredItems {
    return ServiceCatalog.items.where((item) {
      final matchesCat = _activeCategory == 'all' || item.category == _activeCategory;
      final query = _searchQuery.trim().toLowerCase();
      final matchesQuery = query.isEmpty ||
          item.name.toLowerCase().contains(query) ||
          item.description.toLowerCase().contains(query) ||
          item.categoryLabel.toLowerCase().contains(query);
      return matchesCat && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredItems;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopHeader(),
              const SizedBox(height: 14),
              _buildEditorialHeadline(),
              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 14),
              _buildCategoryCarousel(),
              const SizedBox(height: 16),
              _buildPromoSanctuaryPass(),
              const SizedBox(height: 18),
              if (items.isEmpty)
                _buildEmptyState()
              else
                _buildServiceGrid(items),
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
              onTap: () => widget.onNavigateTab(0),
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
            const SizedBox(width: 10),
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
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "D'Beauty Bar Bandung",
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: PastelTheme.brandDark,
                  ),
                ),
                Text(
                  "Katalog & Perawatan",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: PastelTheme.subtleGray,
                  ),
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
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: PastelTheme.borderSoft),
                boxShadow: PastelTheme.softShadow,
              ),
              child: const Icon(Icons.favorite_border_rounded, size: 20, color: PastelTheme.brandDark),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEditorialHeadline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "D'Beauty Bar\nalways for you",
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w800,
            color: PastelTheme.brandDark,
            height: 1.15,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Pilih treatment estetika favoritmu di Bandung",
          style: TextStyle(
            fontSize: 13,
            color: PastelTheme.subtleGray,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
        border: Border.all(color: PastelTheme.borderSoft),
        boxShadow: PastelTheme.softShadow,
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (val) {
          setState(() {
            _searchQuery = val;
          });
        },
        style: const TextStyle(fontSize: 13, color: PastelTheme.brandDark),
        decoration: InputDecoration(
          hintText: "Cari hair, lash, nail, facial...",
          hintStyle: const TextStyle(fontSize: 13, color: PastelTheme.mutedText),
          prefixIcon: const Icon(Icons.search_rounded, size: 20, color: PastelTheme.subtleGray),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded, size: 16, color: PastelTheme.subtleGray),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildCategoryCarousel() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _categories.map((cat) {
          final isSelected = _activeCategory == cat['id'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                setState(() {
                  _activeCategory = cat['id']!;
                });
              },
              borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                decoration: BoxDecoration(
                  gradient: isSelected ? PastelTheme.charcoalButtonGradient : null,
                  color: isSelected ? null : Colors.white,
                  borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
                  border: isSelected ? null : Border.all(color: PastelTheme.borderSoft),
                  boxShadow: isSelected ? PastelTheme.charcoalButtonShadow : PastelTheme.softShadow,
                ),
                child: Text(
                  cat['label']!,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected ? Colors.white : PastelTheme.brandDark,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPromoSanctuaryPass() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: PastelTheme.pinkCardGradient,
        borderRadius: BorderRadius.circular(PastelTheme.radiusCard),
        border: Border.all(color: PastelTheme.pastelPinkBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3DFCECEE),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF43F5E),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "SELF-CARE SANCTUARY PASS",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: PastelTheme.brandDark,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  "Diskon 15% untuk kombinasi Hair & Nail Art pilihan",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: PastelTheme.subtleGray,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: () => widget.onOpenBookingForm(),
            borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
                border: Border.all(color: Colors.white),
                boxShadow: PastelTheme.softShadow,
              ),
              child: const Row(
                children: [
                  Text(
                    "Klaim",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: PastelTheme.brandDark,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, size: 14, color: PastelTheme.brandDark),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceGrid(List<ServiceItem> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 14,
        childAspectRatio: 0.65,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildServiceCard(item);
      },
    );
  }

  Widget _buildServiceCard(ServiceItem item) {
    LinearGradient bgGradient;
    Color borderColor;
    Color tagColor;

    if (item.colorTheme == 'pink') {
      bgGradient = PastelTheme.pinkCardGradient;
      borderColor = PastelTheme.pastelPinkBorder;
      tagColor = PastelTheme.pastelPinkText;
    } else if (item.colorTheme == 'mint') {
      bgGradient = PastelTheme.mintCardGradient;
      borderColor = PastelTheme.pastelMintBorder;
      tagColor = PastelTheme.pastelMintText;
    } else {
      bgGradient = PastelTheme.yellowCardGradient;
      borderColor = PastelTheme.pastelYellowBorder;
      tagColor = PastelTheme.pastelYellowText;
    }

    final isFav = _wishlist.contains(item.id);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: bgGradient,
        borderRadius: BorderRadius.circular(PastelTheme.radiusCard),
        border: Border.all(color: borderColor),
        boxShadow: PastelTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Visual Area with Duration badge & Wishlist button
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(PastelTheme.radiusSubcard),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    item.icon,
                    size: 44,
                    color: tagColor,
                  ),
                  // Wishlist heart
                  Positioned(
                    top: 8,
                    right: 8,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (isFav) {
                            _wishlist.remove(item.id);
                          } else {
                            _wishlist.add(item.id);
                          }
                        });
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.9),
                          boxShadow: PastelTheme.softShadow,
                        ),
                        child: Icon(
                          isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          size: 16,
                          color: isFav ? Colors.redAccent : PastelTheme.brandDark,
                        ),
                      ),
                    ),
                  ),
                  // Duration chip
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.schedule_rounded, size: 10, color: PastelTheme.brandDark),
                          const SizedBox(width: 3),
                          Text(
                            "${item.durationMinutes}m",
                            style: const TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: PastelTheme.brandDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Info Area
          Text(
            item.categoryLabel.toUpperCase(),
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              color: tagColor,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            item.name,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: PastelTheme.brandDark,
              height: 1.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            item.description,
            style: const TextStyle(
              fontSize: 10.5,
              color: PastelTheme.subtleGray,
              height: 1.25,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          // Bottom price row + Add CTA
          Container(
            padding: const EdgeInsets.only(top: 8),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0x12000000))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Mulai dari",
                      style: TextStyle(fontSize: 8.5, color: PastelTheme.mutedText),
                    ),
                    Text(
                      item.shortPrice,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: PastelTheme.brandDark,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    widget.onOpenBookingForm(preselectedService: item.name);
                  },
                  borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: PastelTheme.brandDark,
                      boxShadow: PastelTheme.softShadow,
                    ),
                    child: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
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
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: PastelTheme.borderSoft),
            ),
            child: const Icon(Icons.search_off_rounded, size: 28, color: PastelTheme.subtleGray),
          ),
          const SizedBox(height: 14),
          const Text(
            "Treatment Tidak Ditemukan",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: PastelTheme.brandDark,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Coba gunakan nama treatment lain atau pilih kategori di atas.",
            style: TextStyle(fontSize: 12, color: PastelTheme.subtleGray),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _searchController.clear();
                _searchQuery = '';
                _activeCategory = 'all';
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: PastelTheme.brandDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(PastelTheme.radiusPill),
              ),
            ),
            child: const Text("Tampilkan Semua", style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
