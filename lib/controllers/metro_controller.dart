import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../merto/line.dart';

class StationStep {
  final String name;
  final String lineName;
  final Color lineColor;
  final bool isTransfer;
  final String? transferNotice;

  StationStep({
    required this.name,
    required this.lineName,
    required this.lineColor,
    this.isTransfer = false,
    this.transferNotice,
  });
}

class MetroController extends GetxController {
  final TextEditingController startController = TextEditingController();
  final TextEditingController endController = TextEditingController();

  final RxInt time = 0.obs;
  final RxInt numberOfStations = 0.obs;
  final RxInt price = 0.obs;
  final RxList<StationStep> route = <StationStep>[].obs;
  final RxBool hasCalculated = false.obs;

  late final List<DropdownMenuEntry<String>> dropdownEntries;

  static const Color line1Color = Color(0xFFE53935); // Red
  static const Color line2Color = Color(0xFFFB8C00); // Orange
  static const Color line3Color = Color(0xFF43A047); // Green

  @override
  void onInit() {
    super.onInit();
    // Pre-cache dropdown menu items for ultra-fast UI rendering
    dropdownEntries = allStations
        .map((station) => DropdownMenuEntry<String>(
              value: station,
              label: station,
            ))
        .toList();
  }

  void setStartStation(String station) {
    startController.text = station;
    update();
    if (startController.text.isNotEmpty && endController.text.isNotEmpty) {
      calculateRoute();
    }
  }

  void setEndStation(String station) {
    endController.text = station;
    update();
    if (startController.text.isNotEmpty && endController.text.isNotEmpty) {
      calculateRoute();
    }
  }

  void swapStations() {
    final temp = startController.text;
    startController.text = endController.text;
    endController.text = temp;
    update();

    if (startController.text.isNotEmpty && endController.text.isNotEmpty) {
      calculateRoute();
    }
  }

  void clearSelections() {
    startController.clear();
    endController.clear();
    time.value = 0;
    numberOfStations.value = 0;
    price.value = 0;
    route.clear();
    hasCalculated.value = false;
  }

  void calculateRoute() {
    final start = startController.text.trim();
    final end = endController.text.trim();

    if (start.isEmpty || end.isEmpty) {
      Get.snackbar(
        'Notice',
        'Please select both start and end stations',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(15),
        borderRadius: 10,
      );
      return;
    }

    if (start == end) {
      Get.snackbar(
        'Notice',
        'Start and End station are the same!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(15),
        borderRadius: 10,
      );
      time.value = 0;
      numberOfStations.value = 0;
      price.value = 0;
      route.clear();
      hasCalculated.value = true;
      return;
    }

    final result = _findShortestRoute(start, end);
    if (result != null) {
      route.assignAll(result);
      numberOfStations.value = result.length;
      time.value = result.length * 2;
      price.value = _calculatePrice(result.length);
      hasCalculated.value = true;
    } else {
      Get.snackbar(
        'Error',
        'No route found between selected stations',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  int _calculatePrice(int stationsCount) {
    if (stationsCount <= 9) {
      return 10;
    } else if (stationsCount <= 16) {
      return 12;
    } else if (stationsCount <= 23) {
      return 15;
    } else {
      return 20;
    }
  }

  List<StationStep>? _findShortestRoute(String start, String end) {
    // Check direct line 1
    if (line1.contains(start) && line1.contains(end)) {
      return _buildDirectRoute(line1, start, end, 'Line 1', line1Color);
    }
    // Check direct line 2
    if (line2.contains(start) && line2.contains(end)) {
      return _buildDirectRoute(line2, start, end, 'Line 2', line2Color);
    }
    // Check direct line 3
    if (line3.contains(start) && line3.contains(end)) {
      return _buildDirectRoute(line3, start, end, 'Line 3', line3Color);
    }
    // Check direct line 3 branch
    if (line3CairoUniversityBranch.contains(start) &&
        line3CairoUniversityBranch.contains(end)) {
      return _buildDirectRoute(
          line3CairoUniversityBranch, start, end, 'Line 3', line3Color);
    }

    // Transfers evaluation
    final List<List<StationStep>> candidates = [];

    // Transfer Sadat (Line 1 <-> Line 2)
    if ((line1.contains(start) && line2.contains(end)) ||
        (line2.contains(start) && line1.contains(end))) {
      final route1 = line1.contains(start)
          ? _buildDirectRoute(line1, start, 'Sadat', 'Line 1', line1Color)
          : _buildDirectRoute(line2, start, 'Sadat', 'Line 2', line2Color);
      final route2 = line1.contains(end)
          ? _buildDirectRoute(line1, 'Sadat', end, 'Line 1', line1Color)
          : _buildDirectRoute(line2, 'Sadat', end, 'Line 2', line2Color);

      if (route1 != null && route2 != null) {
        candidates.add(_mergeRoutes(route1, route2, 'Transfer to ${route2.first.lineName} at Sadat'));
      }
    }

    // Transfer Nasser (Line 1 <-> Line 3)
    if ((line1.contains(start) && line3.contains(end)) ||
        (line3.contains(start) && line1.contains(end))) {
      final route1 = line1.contains(start)
          ? _buildDirectRoute(line1, start, 'Nasser', 'Line 1', line1Color)
          : _buildDirectRoute(line3, start, 'Nasser', 'Line 3', line3Color);
      final route2 = line1.contains(end)
          ? _buildDirectRoute(line1, 'Nasser', end, 'Line 1', line1Color)
          : _buildDirectRoute(line3, 'Nasser', end, 'Line 3', line3Color);

      if (route1 != null && route2 != null) {
        candidates.add(_mergeRoutes(route1, route2, 'Transfer to ${route2.first.lineName} at Nasser'));
      }
    }

    // Transfer Attaba (Line 2 <-> Line 3)
    if ((line2.contains(start) && line3.contains(end)) ||
        (line3.contains(start) && line2.contains(end))) {
      final route1 = line2.contains(start)
          ? _buildDirectRoute(line2, start, 'Attaba', 'Line 2', line2Color)
          : _buildDirectRoute(line3, start, 'Attaba', 'Line 3', line3Color);
      final route2 = line2.contains(end)
          ? _buildDirectRoute(line2, 'Attaba', end, 'Line 2', line2Color)
          : _buildDirectRoute(line3, 'Attaba', end, 'Line 3', line3Color);

      if (route1 != null && route2 != null) {
        candidates.add(_mergeRoutes(route1, route2, 'Transfer to ${route2.first.lineName} at Attaba'));
      }
    }

    // Transfer Cairo University (Line 2 <-> Line 3 Branch)
    if ((line2.contains(start) && line3CairoUniversityBranch.contains(end)) ||
        (line3CairoUniversityBranch.contains(start) && line2.contains(end))) {
      final route1 = line2.contains(start)
          ? _buildDirectRoute(line2, start, 'Cairo University', 'Line 2', line2Color)
          : _buildDirectRoute(line3CairoUniversityBranch, start, 'Cairo University', 'Line 3', line3Color);
      final route2 = line2.contains(end)
          ? _buildDirectRoute(line2, 'Cairo University', end, 'Line 2', line2Color)
          : _buildDirectRoute(line3CairoUniversityBranch, 'Cairo University', end, 'Line 3', line3Color);

      if (route1 != null && route2 != null) {
        candidates.add(_mergeRoutes(route1, route2, 'Transfer to ${route2.first.lineName} at Cairo University'));
      }
    }

    if (candidates.isNotEmpty) {
      candidates.sort((a, b) => a.length.compareTo(b.length));
      return candidates.first;
    }

    return null;
  }

  List<StationStep>? _buildDirectRoute(
      List<String> lineList, String start, String end, String lineName, Color lineColor) {
    final startIndex = lineList.indexOf(start);
    final endIndex = lineList.indexOf(end);

    if (startIndex == -1 || endIndex == -1) return null;

    final List<String> stationNames = startIndex <= endIndex
        ? lineList.sublist(startIndex, endIndex + 1)
        : lineList.sublist(endIndex, startIndex + 1).reversed.toList();

    return stationNames
        .map((name) => StationStep(
              name: name,
              lineName: lineName,
              lineColor: lineColor,
            ))
        .toList();
  }

  List<StationStep> _mergeRoutes(
      List<StationStep> route1, List<StationStep> route2, String transferNotice) {
    final List<StationStep> merged = [];
    merged.addAll(route1);

    // Update the transfer station (last item of route 1)
    if (merged.isNotEmpty) {
      final transferStation = merged.last;
      merged[merged.length - 1] = StationStep(
        name: transferStation.name,
        lineName: transferStation.lineName,
        lineColor: transferStation.lineColor,
        isTransfer: true,
        transferNotice: transferNotice,
      );
    }

    // Skip the transfer station in route 2 to avoid duplication
    if (route2.length > 1) {
      merged.addAll(route2.skip(1));
    }

    return merged;
  }

  @override
  void onClose() {
    startController.dispose();
    endController.dispose();
    super.onClose();
  }
}
