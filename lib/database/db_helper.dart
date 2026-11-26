import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../models/booking.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('beauty_bar.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // Platform-specific SQLite Factory initialization
    if (kIsWeb) {
      // User specified sqflite_common_ffi_web
      databaseFactory = databaseFactoryFfiWeb;
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    String path;
    if (kIsWeb) {
      path = filePath;
    } else {
      final dbPath = await getDatabasesPath();
      path = p.join(dbPath, filePath);
    }

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE bookings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        client_name TEXT NOT NULL,
        service_name TEXT NOT NULL,
        service_price INTEGER NOT NULL,
        branch_name TEXT NOT NULL,
        booking_date TEXT NOT NULL,
        booking_time TEXT NOT NULL,
        stylist_name TEXT NOT NULL,
        notes TEXT,
        status TEXT NOT NULL,
        sync_status TEXT NOT NULL,
        user_location TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // Seed initial dummy bookings matching the reference design
    await _seedInitialData(db);
  }

  Future<void> _seedInitialData(Database db) async {
    final initialList = [
      Booking(
        clientName: 'Nadhira Putri',
        serviceName: 'Signature Blowdry & Style',
        servicePrice: 135000,
        branchName: "D'Beauty Bar Dago (Jl. Ir. H. Juanda No. 112)",
        bookingDate: '2025-06-25',
        bookingTime: '14:30 WIB',
        stylistName: 'Teh Kinanti A.',
        notes: 'Mohon hair stylist spesialis blow bervolume',
        status: 'aktif',
        syncStatus: 'LOCAL',
        userLocation: 'Jl. Dipati Ukur No. 35, Coblong, Kota Bandung',
        createdAt: '2025-06-20T10:00:00Z',
      ),
      Booking(
        clientName: 'Siti Rahmawati',
        serviceName: 'Korean Glass Hair Treatment',
        servicePrice: 380000,
        branchName: "D'Beauty Bar Riau Aesthetic",
        bookingDate: '2025-06-28',
        bookingTime: '10:00 WIB',
        stylistName: 'Teh Kinanti A.',
        notes: 'Kulit kepala agak sensitif',
        status: 'aktif',
        syncStatus: 'LOCAL',
        userLocation: 'Coblong, Kota Bandung',
        createdAt: '2025-06-21T11:30:00Z',
      ),
      Booking(
        clientName: 'Clara Salsabila',
        serviceName: 'Gel Polish Classic',
        servicePrice: 150000,
        branchName: "D'Beauty Bar Braga Heritage",
        bookingDate: '2025-06-18',
        bookingTime: '15:00 WIB',
        stylistName: 'Teh Fani',
        notes: 'Warna nude pink pastel glitter',
        status: 'selesai',
        syncStatus: 'SYNCED',
        userLocation: 'Sumur Bandung, Kota Bandung',
        createdAt: '2025-06-15T09:00:00Z',
      ),
    ];

    for (final b in initialList) {
      await db.insert('bookings', b.toMap());
    }
  }

  // --- CRUD Operations ---

  Future<int> insertBooking(Booking booking) async {
    final db = await database;
    return await db.insert('bookings', booking.toMap());
  }

  Future<List<Booking>> getAllBookings({String? status}) async {
    final db = await database;
    List<Map<String, dynamic>> maps;
    if (status != null && status != 'semua') {
      maps = await db.query(
        'bookings',
        where: 'status = ?',
        whereArgs: [status.toLowerCase()],
        orderBy: 'id DESC',
      );
    } else {
      maps = await db.query('bookings', orderBy: 'id DESC');
    }
    return maps.map((map) => Booking.fromMap(map)).toList();
  }

  Future<Booking?> getLatestActiveBooking() async {
    final db = await database;
    final maps = await db.query(
      'bookings',
      where: 'status = ?',
      whereArgs: ['aktif'],
      orderBy: 'id DESC',
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return Booking.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateBookingStatus(int id, String status) async {
    final db = await database;
    return await db.update(
      'bookings',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteBooking(int id) async {
    final db = await database;
    return await db.delete(
      'bookings',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getBookingCount({String? status}) async {
    final db = await database;
    if (status != null && status != 'semua') {
      final res = await db.rawQuery(
        'SELECT COUNT(*) as count FROM bookings WHERE status = ?',
        [status.toLowerCase()],
      );
      return Sqflite.firstIntValue(res) ?? 0;
    } else {
      final res = await db.rawQuery('SELECT COUNT(*) as count FROM bookings');
      return Sqflite.firstIntValue(res) ?? 0;
    }
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
