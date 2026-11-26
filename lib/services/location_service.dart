import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationService extends ChangeNotifier {
  static final LocationService instance = LocationService._internal();

  LocationService._internal();

  // Default coordinate in Bandung (Dipati Ukur / Coblong area)
  double _latitude = -6.8925;
  double _longitude = 107.6105;
  double _accuracyMeters = 8.0;
  String _address = 'Jl. Dipati Ukur No. 35, Coblong, Kota Bandung';
  String _district = 'Coblong, Kota Bandung';
  bool _isSyncing = false;
  DateTime? _lastSyncedTime = DateTime.now();
  bool _isLiveGps = false;

  double get latitude => _latitude;
  double get longitude => _longitude;
  double get accuracyMeters => _accuracyMeters;
  String get address => _address;
  String get district => _district;
  bool get isSyncing => _isSyncing;
  DateTime? get lastSyncedTime => _lastSyncedTime;
  bool get isLiveGps => _isLiveGps;

  String get coordinateString =>
      '${_latitude.toStringAsFixed(5)}, ${_longitude.toStringAsFixed(5)}';

  /// Synchronize GPS location with device or fallback gracefully
  Future<bool> syncLocation() async {
    _isSyncing = true;
    notifyListeners();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _applyPresetLocation();
        _isSyncing = false;
        notifyListeners();
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _applyPresetLocation();
          _isSyncing = false;
          notifyListeners();
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _applyPresetLocation();
        _isSyncing = false;
        notifyListeners();
        return false;
      }

      // Get real GPS position with timeout
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 6),
        ),
      );

      _latitude = position.latitude;
      _longitude = position.longitude;
      _accuracyMeters = position.accuracy;
      _lastSyncedTime = DateTime.now();
      _isLiveGps = true;

      // Approximate district based on Bandung bounds
      _updateDistrictName(_latitude, _longitude);

      _isSyncing = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Location sync fallback: $e");
      _applyPresetLocation();
      _isSyncing = false;
      notifyListeners();
      return false;
    }
  }

  void _applyPresetLocation() {
    _latitude = -6.8925;
    _longitude = 107.6105;
    _accuracyMeters = 10.0;
    _address = 'Jl. Dipati Ukur No. 35, Coblong, Kota Bandung';
    _district = 'Coblong, Kota Bandung';
    _lastSyncedTime = DateTime.now();
    _isLiveGps = false;
  }

  void _updateDistrictName(double lat, double lng) {
    if (lat > -6.88) {
      _district = 'Sukasari / Setiabudi, Bandung';
      _address = 'Jl. Dr. Setiabudi, Sukasari, Kota Bandung';
    } else if (lat < -6.92) {
      _district = 'Buah Batu / Lengkong, Bandung';
      _address = 'Jl. Buah Batu, Lengkong, Kota Bandung';
    } else if (lng < 107.612) {
      _district = 'Sumur Bandung / Braga';
      _address = 'Jl. Braga, Sumur Bandung, Kota Bandung';
    } else {
      _district = 'Coblong / Riau, Bandung';
      _address = 'Jl. Dipati Ukur No. 35, Coblong, Kota Bandung';
    }
  }

  /// Calculates dynamic distance in kilometers from user to destination
  double calculateDistanceKm(double destLat, double destLng) {
    final distanceInMeters = Geolocator.distanceBetween(
      _latitude,
      _longitude,
      destLat,
      destLng,
    );
    return distanceInMeters / 1000.0;
  }

  /// Formatted distance string (e.g. "850 m" or "2.4 km")
  String getFormattedDistance(double destLat, double destLng) {
    final km = calculateDistanceKm(destLat, destLng);
    if (km < 1.0) {
      final meters = (km * 1000).round();
      return '$meters m';
    }
    return '${km.toStringAsFixed(1)} km';
  }
}
