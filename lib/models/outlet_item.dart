class OutletItem {
  final int pinNumber;
  final String id;
  final String name;
  final String subtitle;
  final String address;
  final double distanceKm;
  final String distanceText;
  final String openHours;
  final List<String> facilities;
  final String colorTheme; // 'pink', 'mint', 'yellow'
  final double latitude;
  final double longitude;

  const OutletItem({
    required this.pinNumber,
    required this.id,
    required this.name,
    required this.subtitle,
    required this.address,
    required this.distanceKm,
    required this.distanceText,
    required this.openHours,
    required this.facilities,
    required this.colorTheme,
    required this.latitude,
    required this.longitude,
  });
}

class OutletData {
  static const List<OutletItem> outlets = [
    OutletItem(
      pinNumber: 1,
      id: 'dago',
      name: "D'Beauty Bar Dago",
      subtitle: "Dago Sanctuary (Terdekat)",
      address: "Jl. Ir. H. Juanda No. 112, Coblong, Kota Bandung",
      distanceKm: 0.85,
      distanceText: "850 m",
      openHours: "09:00 - 20:00 WIB",
      facilities: ["Valet Parking", "Artisan Tea Bar", "Private VIP Room", "Wi-Fi"],
      colorTheme: 'pink',
      latitude: -6.8925,
      longitude: 107.6105,
    ),
    OutletItem(
      pinNumber: 2,
      id: 'riau',
      name: "D'Beauty Bar Riau Aesthetic",
      subtitle: "LLRE Martadinata Concept Store",
      address: "Jl. LLRE Martadinata No. 68, Citarum, Kota Bandung",
      distanceKm: 2.4,
      distanceText: "2.4 km",
      openHours: "09:00 - 21:00 WIB",
      facilities: ["Nail Art Studio", "Cold Pressed Juice", "Lounge", "Wi-Fi"],
      colorTheme: 'mint',
      latitude: -6.9080,
      longitude: 107.6185,
    ),
    OutletItem(
      pinNumber: 3,
      id: 'braga',
      name: "D'Beauty Bar Braga Heritage",
      subtitle: "Vintage Glamour Corner",
      address: "Jl. Braga No. 45, Sumur Bandung, Kota Bandung",
      distanceKm: 3.8,
      distanceText: "3.8 km",
      openHours: "10:00 - 21:00 WIB",
      facilities: ["Hair Spa Bar", "Photo Spot", "Artisan Coffee", "Wi-Fi"],
      colorTheme: 'yellow',
      latitude: -6.9172,
      longitude: 107.6095,
    ),
    OutletItem(
      pinNumber: 4,
      id: 'setiabudi',
      name: "D'Beauty Bar Setiabudi Hills",
      subtitle: "Breeze & Organic Spa",
      address: "Jl. Dr. Setiabudi No. 88, Sukasari, Kota Bandung",
      distanceKm: 4.5,
      distanceText: "4.5 km",
      openHours: "09:00 - 20:00 WIB",
      facilities: ["Rooftop Garden", "Organic Waxing", "Private Suite", "Wi-Fi"],
      colorTheme: 'pink',
      latitude: -6.8720,
      longitude: 107.5950,
    ),
    OutletItem(
      pinNumber: 5,
      id: 'buah-batu',
      name: "D'Beauty Bar Buah Batu",
      subtitle: "South Bandung Glam Bar",
      address: "Jl. Buah Batu No. 142, Lengkong, Kota Bandung",
      distanceKm: 5.1,
      distanceText: "5.1 km",
      openHours: "09:00 - 20:00 WIB",
      facilities: ["Lash Extension Hub", "Free Parking", "Pastel Lounge", "Wi-Fi"],
      colorTheme: 'mint',
      latitude: -6.9360,
      longitude: 107.6250,
    ),
  ];
}
