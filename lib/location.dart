import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'controllers/metro_controller.dart';

final Map<String, Map<String, double>> stationCoordinates = {
  "Helwan": {"lat": 29.8489, "lng": 31.3342},
  "Ain Helwan": {"lat": 29.8624, "lng": 31.3283},
  "Helwan University": {"lat": 29.8687, "lng": 31.3214},
  "Wadi Hof": {"lat": 29.8787, "lng": 31.3146},
  "Hadayek Helwan": {"lat": 29.8974, "lng": 31.3042},
  "El-Maasara": {"lat": 29.9077, "lng": 31.2985},
  "Tora El-Asmant": {"lat": 29.9254, "lng": 31.2882},
  "Kozzika": {"lat": 29.9366, "lng": 31.2831},
  "Tora El-Balad": {"lat": 29.9482, "lng": 31.2774},
  "Sakanat El-Maadi": {"lat": 29.9547, "lng": 31.2644},
  "Maadi": {"lat": 29.9583, "lng": 31.2583},
  "Hadayek El-Maadi": {"lat": 29.9708, "lng": 31.2504},
  "Dar El-Salam": {"lat": 29.9822, "lng": 31.2422},
  "El-Zahraa": {"lat": 29.9947, "lng": 31.2339},
  "Mar Girgis": {"lat": 30.0062, "lng": 31.2301},
  "El-Malek El-Saleh": {"lat": 30.0168, "lng": 31.2307},
  "Al-Sayeda Zeinab": {"lat": 30.0298, "lng": 31.2356},
  "Saad Zaghloul": {"lat": 30.0369, "lng": 31.2378},
  "Sadat": {"lat": 30.0444, "lng": 31.2357},
  "Nasser": {"lat": 30.0531, "lng": 31.2396},
  "Orabi": {"lat": 30.0573, "lng": 31.2435},
  "Al-Shohadaa": {"lat": 30.0617, "lng": 31.2464},
  "Ghamra": {"lat": 30.0682, "lng": 31.2673},
  "El-Demerdash": {"lat": 30.0768, "lng": 31.2775},
  "Manshiet El-Sadr": {"lat": 30.0827, "lng": 31.2858},
  "Kobri El-Qobba": {"lat": 30.0877, "lng": 31.2933},
  "Hammamat El-Qobba": {"lat": 30.0933, "lng": 31.2974},
  "Saray El-Qobba": {"lat": 30.0991, "lng": 31.3033},
  "Hadayeq El-Zaitoun": {"lat": 30.1066, "lng": 31.3117},
  "Helmeyet El-Zaitoun": {"lat": 30.1147, "lng": 31.3158},
  "El-Matareyya": {"lat": 30.1215, "lng": 31.3129},
  "Ain Shams": {"lat": 30.1306, "lng": 31.3142},
  "Ezbet El-Nakhl": {"lat": 30.1417, "lng": 31.3250},
  "El-Marg": {"lat": 30.1517, "lng": 31.3364},
  "New El-Marg": {"lat": 30.1614, "lng": 31.3382},
  "Shoubra El-Kheima": {"lat": 30.1228, "lng": 31.2442},
  "Kolleyyet El-Zeraa": {"lat": 30.1139, "lng": 31.2483},
  "Mezallat": {"lat": 30.1039, "lng": 31.2458},
  "Khalafawy": {"lat": 30.0967, "lng": 31.2447},
  "St. Teresa": {"lat": 30.0883, "lng": 31.2450},
  "Rod El-Farag": {"lat": 30.0808, "lng": 31.2456},
  "Masarra": {"lat": 30.0714, "lng": 31.2458},
  "Attaba": {"lat": 30.0525, "lng": 31.2472},
  "Mohamed Naguib": {"lat": 30.0456, "lng": 31.2447},
  "Opera": {"lat": 30.0422, "lng": 31.2253},
  "Dokki": {"lat": 30.0383, "lng": 31.2117},
  "Bohooth": {"lat": 30.0358, "lng": 31.2000},
  "Cairo University": {"lat": 30.0258, "lng": 31.2078},
  "Faisal": {"lat": 30.0175, "lng": 31.2056},
  "Giza": {"lat": 30.0106, "lng": 31.2072},
  "Omm El-Misryeen": {"lat": 30.0039, "lng": 31.2081},
  "Sakiat Mekki": {"lat": 29.9953, "lng": 31.2089},
  "El-Mounib": {"lat": 29.9814, "lng": 31.2128},
  "Adly Mansour": {"lat": 30.1472, "lng": 31.4239},
  "El-Haykstep": {"lat": 30.1389, "lng": 31.3986},
  "Omar Ibn El-Khattab": {"lat": 30.1344, "lng": 31.3850},
  "Qobaa": {"lat": 30.1294, "lng": 31.3711},
  "Hesham Barakat": {"lat": 30.1233, "lng": 31.3578},
  "El-Nozha": {"lat": 30.1167, "lng": 31.3467},
  "El-Shams Club": {"lat": 30.1186, "lng": 31.3400},
  "Alf Maskan": {"lat": 30.1169, "lng": 31.3325},
  "Heliopolis": {"lat": 30.1092, "lng": 31.3303},
  "Haroun": {"lat": 30.1022, "lng": 31.3283},
  "Al-Ahram": {"lat": 30.0917, "lng": 31.3242},
  "Koleyet El-Banat": {"lat": 30.0828, "lng": 31.3297},
  "Stadium": {"lat": 30.0722, "lng": 31.3194},
  "Fair Zone": {"lat": 30.0739, "lng": 31.3014},
  "Abbassia": {"lat": 30.0664, "lng": 31.2828},
  "Abdou Pasha": {"lat": 30.0633, "lng": 31.2728},
  "El-Geish": {"lat": 30.0617, "lng": 31.2661},
  "Bab El-Shaaria": {"lat": 30.0536, "lng": 31.2583},
  "Maspero": {"lat": 30.0556, "lng": 31.2333},
  "Safaa Hegazy": {"lat": 30.0608, "lng": 31.2228},
  "Kit Kat": {"lat": 30.0617, "lng": 31.2136},
  "Sudan": {"lat": 30.0667, "lng": 31.2050},
  "Imbaba": {"lat": 30.0744, "lng": 31.2075},
  "El-Bohy": {"lat": 30.0811, "lng": 31.2086},
  "Al-Qawmia": {"lat": 30.0886, "lng": 31.2089},
  "Ring Road": {"lat": 30.0967, "lng": 31.2044},
  "Al-Tawfikia": {"lat": 30.0550, "lng": 31.2069},
  "Wadi El-Nile": {"lat": 30.0478, "lng": 31.2058},
  "Gameat El-Dowal": {"lat": 30.0408, "lng": 31.2039},
  "Bulak El-Dakrour": {"lat": 30.0331, "lng": 31.2017},
};

Future<void> openStationLocation(String stationName) async {
  if (stationName.isEmpty) {
    Get.snackbar(
      'Error',
      'Please select a station first',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
    return;
  }

  final query = Uri.encodeComponent('$stationName Metro Station Cairo');
  final Uri mapsUri = Uri.parse(
    'https://www.google.com/maps/search/?api=1&query=$query',
  );

  try {
    if (await canLaunchUrl(mapsUri)) {
      await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Error',
        'Could not open Google Maps',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  } catch (e) {
    Get.snackbar(
      'Error',
      'An error occurred while opening Maps',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

Future<void> findNearestStation(BuildContext context, MetroController controller) async {
  bool serviceEnabled;
  LocationPermission permission;

  try {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        'Location Disabled',
        'Please turn on GPS/Location on your device.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          'Permission Denied',
          'Location permission is required to find nearest station.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'Permission Denied',
        'Location permissions are permanently denied. Please enable in Settings.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (!context.mounted) return;

    // Show loading dialog AFTER permissions are granted
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const Center(
        child: Card(
          margin: EdgeInsets.all(32),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Colors.red),
                SizedBox(height: 16),
                Text(
                  'Finding nearest metro station...',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        timeLimit: Duration(seconds: 10),
      ),
    );

    // Close loading dialog
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }

    String nearestStation = '';
    double minDistance = double.infinity;

    stationCoordinates.forEach((station, coords) {
      double dist = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        coords['lat']!,
        coords['lng']!,
      );
      if (dist < minDistance) {
        minDistance = dist;
        nearestStation = station;
      }
    });

    if (nearestStation.isNotEmpty) {
      double distanceKm = minDistance / 1000.0;
      String distanceStr = distanceKm < 1
          ? '${minDistance.toStringAsFixed(0)} meters'
          : '${distanceKm.toStringAsFixed(2)} km';

      Get.bottomSheet(
        Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Icon(Icons.near_me_rounded, color: Colors.red, size: 48),
              const SizedBox(height: 12),
              const Text(
                'Nearest Metro Station Found!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                nearestStation,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Distance: $distanceStr',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        controller.setStartStation(nearestStation);
                        Get.back();
                        Get.snackbar(
                          'Start Station Set',
                          '$nearestStation set as Start Station',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      },
                      icon: const Icon(Icons.trip_origin, size: 18),
                      label: const Text('Set Start'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        controller.setEndStation(nearestStation);
                        Get.back();
                        Get.snackbar(
                          'End Station Set',
                          '$nearestStation set as End Station',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      },
                      icon: const Icon(Icons.location_on, size: 18),
                      label: const Text('Set End'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: () {
                  Get.back();
                  openStationLocation(nearestStation);
                },
                icon: const Icon(Icons.map_outlined, color: Colors.blue),
                label: const Text(
                  'Open in Maps',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
        isDismissible: true,
      );
    }
  } catch (e) {
    if (context.mounted && Navigator.canPop(context)) {
      Navigator.of(context, rootNavigator: true).pop();
    }
    Get.snackbar(
      'Error',
      'Could not determine location: $e',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
  }
}