class Booking {
  final int? id;
  final String clientName;
  final String serviceName;
  final int servicePrice;
  final String branchName;
  final String bookingDate; // e.g. "2025-06-25"
  final String bookingTime; // e.g. "14:30 WIB"
  final String stylistName;
  final String? notes;
  final String status; // 'aktif', 'selesai', 'dibatalkan'
  final String syncStatus; // 'LOCAL', 'SYNCED'
  final String? userLocation;
  final String createdAt;

  Booking({
    this.id,
    required this.clientName,
    required this.serviceName,
    required this.servicePrice,
    required this.branchName,
    required this.bookingDate,
    required this.bookingTime,
    required this.stylistName,
    this.notes,
    this.status = 'aktif',
    this.syncStatus = 'LOCAL',
    this.userLocation,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'client_name': clientName,
      'service_name': serviceName,
      'service_price': servicePrice,
      'branch_name': branchName,
      'booking_date': bookingDate,
      'booking_time': bookingTime,
      'stylist_name': stylistName,
      'notes': notes,
      'status': status,
      'sync_status': syncStatus,
      'user_location': userLocation,
      'created_at': createdAt,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'] as int?,
      clientName: map['client_name'] as String? ?? 'Pelanggan',
      serviceName: map['service_name'] as String? ?? 'Treatment',
      servicePrice: (map['service_price'] as num?)?.toInt() ?? 0,
      branchName: map['branch_name'] as String? ?? "D'Beauty Bar Dago",
      bookingDate: map['booking_date'] as String? ?? '',
      bookingTime: map['booking_time'] as String? ?? '',
      stylistName: map['stylist_name'] as String? ?? 'Teh Kinanti A.',
      notes: map['notes'] as String?,
      status: map['status'] as String? ?? 'aktif',
      syncStatus: map['sync_status'] as String? ?? 'LOCAL',
      userLocation: map['user_location'] as String?,
      createdAt: map['created_at'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  Booking copyWith({
    int? id,
    String? clientName,
    String? serviceName,
    int? servicePrice,
    String? branchName,
    String? bookingDate,
    String? bookingTime,
    String? stylistName,
    String? notes,
    String? status,
    String? syncStatus,
    String? userLocation,
    String? createdAt,
  }) {
    return Booking(
      id: id ?? this.id,
      clientName: clientName ?? this.clientName,
      serviceName: serviceName ?? this.serviceName,
      servicePrice: servicePrice ?? this.servicePrice,
      branchName: branchName ?? this.branchName,
      bookingDate: bookingDate ?? this.bookingDate,
      bookingTime: bookingTime ?? this.bookingTime,
      stylistName: stylistName ?? this.stylistName,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      syncStatus: syncStatus ?? this.syncStatus,
      userLocation: userLocation ?? this.userLocation,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
