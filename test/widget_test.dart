import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:beauty_bar/main.dart';
import 'package:beauty_bar/database/db_helper.dart';
import 'package:beauty_bar/models/booking.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('DatabaseHelper SQLite CRUD test', () async {
    final dbHelper = DatabaseHelper.instance;

    // Verify initial seed bookings exist
    final bookings = await dbHelper.getAllBookings();
    expect(bookings.isNotEmpty, true);

    // Create / Insert
    final newBooking = Booking(
      clientName: 'Diva Sephira',
      serviceName: 'Korean Glass Hair',
      servicePrice: 380000,
      branchName: "D'Beauty Bar Dago",
      bookingDate: '2026-12-01',
      bookingTime: '11:00 WIB',
      stylistName: 'Teh Kinanti A.',
      notes: 'Test note',
      status: 'aktif',
      syncStatus: 'LOCAL',
      createdAt: DateTime.now().toIso8601String(),
    );

    final insertedId = await dbHelper.insertBooking(newBooking);
    expect(insertedId > 0, true);

    // Read by status
    final activeBookings = await dbHelper.getAllBookings(status: 'aktif');
    expect(activeBookings.any((b) => b.id == insertedId), true);

    // Update status
    await dbHelper.updateBookingStatus(insertedId, 'selesai');
    final completedBookings = await dbHelper.getAllBookings(status: 'selesai');
    expect(completedBookings.any((b) => b.id == insertedId), true);

    // Delete
    final deleteCount = await dbHelper.deleteBooking(insertedId);
    expect(deleteCount, 1);

    final afterDelete = await dbHelper.getAllBookings();
    expect(afterDelete.any((b) => b.id == insertedId), false);
  });

  testWidgets('BeautyBarApp loads and displays main header and greeting', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const BeautyBarApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text("D'Beauty Bar Bandung"), findsWidgets);
    expect(find.text("Sampurasun, Cantik!"), findsOneWidget);
    expect(find.text("Menu Cepat"), findsOneWidget);
    expect(find.text("Katalog"), findsOneWidget);

    // Let sqflite's 10s internal lock detection timer elapse cleanly
    await tester.pump(const Duration(seconds: 11));
  });
}
