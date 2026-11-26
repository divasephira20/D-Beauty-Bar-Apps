import 'package:flutter/material.dart';

class ServiceItem {
  final String id;
  final String name;
  final String category; // 'hair', 'nails', 'makeup', 'facial', 'lash', 'waxing'
  final String categoryLabel;
  final int price;
  final int durationMinutes;
  final String description;
  final String colorTheme; // 'pink', 'mint', 'yellow'
  final IconData icon;

  const ServiceItem({
    required this.id,
    required this.name,
    required this.category,
    required this.categoryLabel,
    required this.price,
    required this.durationMinutes,
    required this.description,
    required this.colorTheme,
    required this.icon,
  });

  String get formattedPrice {
    final str = price.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }
    return 'Rp ${buffer.toString().split('').reversed.join('')}';
  }

  String get shortPrice {
    return 'Rp ${(price / 1000).toInt()}k';
  }
}

class ServiceCatalog {
  static const List<ServiceItem> items = [
    ServiceItem(
      id: 'blowdry',
      name: 'Signature Blowdry & Style',
      category: 'hair',
      categoryLabel: 'Hair Styling',
      price: 135000,
      durationMinutes: 45,
      description: 'Hair wash rose water & styling glamor.',
      colorTheme: 'pink',
      icon: Icons.air_rounded,
    ),
    ServiceItem(
      id: 'korean-glass-hair',
      name: 'Korean Glass Hair',
      category: 'hair',
      categoryLabel: 'Hair Treatment',
      price: 380000,
      durationMinutes: 90,
      description: 'Keratin gloss kilau maksimal rambut halus.',
      colorTheme: 'yellow',
      icon: Icons.face_retouching_natural_rounded,
    ),
    ServiceItem(
      id: 'gel-polish',
      name: 'Gel Polish Classic',
      category: 'nails',
      categoryLabel: 'Nail Art',
      price: 150000,
      durationMinutes: 60,
      description: 'Manicure bersih & warna awet 4 minggu.',
      colorTheme: 'mint',
      icon: Icons.brush_rounded,
    ),
    ServiceItem(
      id: 'blush-velvet-nail',
      name: 'Blush Velvet Nail Art',
      category: 'nails',
      categoryLabel: 'Trending Nail',
      price: 250000,
      durationMinutes: 90,
      description: 'Gradasi nude blush shimmer & foil aksen.',
      colorTheme: 'pink',
      icon: Icons.auto_awesome_rounded,
    ),
    ServiceItem(
      id: 'natural-glow',
      name: 'Natural Glow Daily Look',
      category: 'makeup',
      categoryLabel: 'Makeup Look',
      price: 220000,
      durationMinutes: 45,
      description: 'Riasan dewy natural tahan seharian.',
      colorTheme: 'yellow',
      icon: Icons.palette_rounded,
    ),
    ServiceItem(
      id: 'glamour-makeup',
      name: 'Glamour Event Make-up',
      category: 'makeup',
      categoryLabel: 'Event & Party',
      price: 450000,
      durationMinutes: 75,
      description: 'HD makeup smokey & bulu mata premium.',
      colorTheme: 'pink',
      icon: Icons.auto_fix_high_rounded,
    ),
    ServiceItem(
      id: 'rose-quartz-facial',
      name: 'Rose Quartz Hydrating Facial',
      category: 'facial',
      categoryLabel: 'Facial Spa',
      price: 275000,
      durationMinutes: 60,
      description: 'Limfatik massage & rose organic serum.',
      colorTheme: 'mint',
      icon: Icons.spa_rounded,
    ),
    ServiceItem(
      id: 'soft-volume-lash',
      name: 'Soft Volume Japanese Lash',
      category: 'lash',
      categoryLabel: 'Eyelash',
      price: 320000,
      durationMinutes: 90,
      description: 'Serat ultra lembut Jepang, ringan & lentik.',
      colorTheme: 'pink',
      icon: Icons.visibility_rounded,
    ),
    ServiceItem(
      id: 'underarm-wax',
      name: 'Underarm Sugar Waxing Gentle',
      category: 'waxing',
      categoryLabel: 'Gentle Wax',
      price: 95000,
      durationMinutes: 30,
      description: 'Gula organik lembut & lidah buaya dingin.',
      colorTheme: 'yellow',
      icon: Icons.clean_hands_rounded,
    ),
  ];
}
