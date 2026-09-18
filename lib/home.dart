import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/metro_controller.dart';
import 'location.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final MetroController controller = Get.put(MetroController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Text(
                  'Cairo ',
                  style: TextStyle(fontSize: 35, color: Colors.white),
                ),
                Text(
                  'Metro',
                  style: TextStyle(
                    fontSize: 35,
                    color: Color.fromARGB(255, 255, 17, 0),
                  ),
                ),
              ],
            ),
            const CircleAvatar(
              radius: 28,
              backgroundImage: AssetImage('images/logo_metro.png'),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            const Text(
              'From',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            GetBuilder<MetroController>(
              builder: (ctrl) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownMenu<String>(
                        key: ValueKey('start_${ctrl.startController.text}'),
                        controller: ctrl.startController,
                        requestFocusOnTap: true,
                        expandedInsets: EdgeInsets.zero,
                        menuHeight: 200,
                        enableFilter: true,
                        enableSearch: true,
                        hintText: 'Start Station',
                        dropdownMenuEntries: ctrl.dropdownEntries,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => openStationLocation(ctrl.startController.text),
                      icon: const Icon(Icons.location_on, color: Colors.red),
                      tooltip: 'Open in Maps',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'To',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            GetBuilder<MetroController>(
              builder: (ctrl) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownMenu<String>(
                        key: ValueKey('end_${ctrl.endController.text}'),
                        controller: ctrl.endController,
                        requestFocusOnTap: true,
                        expandedInsets: EdgeInsets.zero,
                        menuHeight: 200,
                        enableFilter: true,
                        enableSearch: true,
                        hintText: 'End Station',
                        dropdownMenuEntries: ctrl.dropdownEntries,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => openStationLocation(ctrl.endController.text),
                      icon: const Icon(Icons.location_on, color: Colors.red),
                      tooltip: 'Open in Maps',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: () => controller.calculateRoute(),
              label: const Text(
                'Show Route',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              icon: const Icon(Icons.subway, color: Colors.white),
            ),

            const SizedBox(height: 20),

            Obx(
              () => Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.timer_outlined, color: Colors.grey),
                            const SizedBox(width: 5),
                            Text(
                              '${controller.time.value} mins',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.subway_outlined, color: Colors.grey),
                            const SizedBox(width: 5),
                            Text(
                              '${controller.numberOfStations.value} stations',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 25, thickness: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Ticket Price:',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Text(
                          '${controller.price.value} EGP',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 25, thickness: 1),
                    Text(
                      controller.route.isEmpty
                          ? 'Route: Select stations'
                          : 'Route: ${controller.route.map((s) => s.name).join(" -> ")}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            onPressed: () => findNearestStation(context, controller),
            icon: const Icon(Icons.my_location, color: Colors.white, size: 22),
            label: const Text(
              'Find Nearest Station 📍',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}