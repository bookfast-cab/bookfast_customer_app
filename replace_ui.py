import re

with open('/Volumes/samsung-apple/Developer/bookfast/App/bookfast_customer-app/lib/ui/screens/home_map_view_screen.dart', 'r') as f:
    lines = f.readlines()

start_index = -1
end_index = -1

for i, line in enumerate(lines):
    if line.strip().startswith('Widget build(BuildContext context) {'):
        start_index = i - 1
    if line.strip().startswith('void openFareBottomSheet(BuildContext context) {'):
        end_index = i - 2
        break

if start_index != -1 and end_index != -1:
    new_content = """  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark, // Black status bar icons
      child: Container(
        color: Colors.white,
      child: SafeArea(
        left: true,
        top: true,
        right: true,
        bottom: true,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          drawer: const AppDrawer(),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, -3), // Shadow upwards
                ),
              ],
            ),
            child: BottomNavigationBar(
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.blue.shade700,
              unselectedItemColor: Colors.grey.shade600,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
              currentIndex: 0,
              onTap: (index) {
                if (index == 1) {
                  Get.to(() => const MyRidesHistoryScreen());
                } else if (index == 3) {
                  Get.to(() => const MyProfileScreen());
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.access_time),
                  label: "My Rides",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.local_offer_outlined),
                  label: "Offers",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: "Profile",
                ),
              ],
            ),
          ),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: GestureDetector(
              onTap: () => _scaffoldKey.currentState?.openDrawer(),
              child: const Icon(Icons.menu, color: Colors.black, size: 28),
            ),
            centerTitle: true,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(AppImages.icBookFastLogo1, height: 35),
              ],
            ),
            actions: [
              Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.notifications_none, color: Colors.black, size: 28),
                  Positioned(
                    right: 0,
                    top: 12,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade700,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
            ],
          ),
          body: Obx(() {
            return Column(
              children: [
                _topPromoBanner(),
                Expanded(
                  child: Stack(
                    children: [
                      // Google Map
                      Obx(() {
                        final position = _controller.currentPosition.value;
                        if (position == null) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        return GoogleMap(
                          onMapCreated: _controller.onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(position.latitude, position.longitude),
                            zoom: 12.0,
                          ),
                          markers: {
                            Marker(
                              markerId: const MarkerId('currentLocation'),
                              position: LatLng(position.latitude, position.longitude),
                            ),
                            if (_searchDropLocationController.pickLat.value != 0.0 &&
                                _searchDropLocationController.pickLng.value != 0.0)
                              Marker(
                                markerId: const MarkerId('pickLocation'),
                                position: LatLng(
                                  _searchDropLocationController.pickLat.value,
                                  _searchDropLocationController.pickLng.value,
                                ),
                                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                              ),
                            if (_controller.selectedMarker.value != null) _controller.selectedMarker.value!,
                            ..._controller.driverMarkers,
                          },
                          polylines: _controller.polyline.value != null ? {_controller.polyline.value!} : {},
                          zoomControlsEnabled: false,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          mapToolbarEnabled: false,
                        );
                      }),
                      // Location Floating Card
                      _floatingLocationCard(),
                      
                      // Floating My Location Button
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: GestureDetector(
                          onTap: () {
                            _controller.getCurrentLocation(zoomToCurrentLocation: true);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, spreadRadius: 1)
                              ]
                            ),
                            child: const Icon(Icons.my_location, color: Colors.black87),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Bottom Panel
                _buildBottomPanel(),
              ],
            );
          }),
        ),
      ),
    ));
  }

  Widget _topPromoBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.only(left: 20, right: 10, top: 16, bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade900, Colors.blue.shade600],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(text: "FLAT "),
                      TextSpan(text: "20% OFF\n", style: TextStyle(color: Colors.yellow, fontSize: 32)),
                      TextSpan(text: "on your first 3 rides!", style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                    ]
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    "BOOKFAST20",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 8),
                const Text("*T&C Apply", style: TextStyle(color: Colors.white70, fontSize: 8)),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Image.asset(AppImages.icSedan, fit: BoxFit.contain), 
          ),
        ],
      ),
    );
  }

  Widget _floatingLocationCard() {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Dotted line and dots
            Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade700,
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  height: 25,
                  width: 1.5,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  color: Colors.grey.shade400, 
                ),
                const Icon(Icons.location_on, color: Colors.red, size: 16),
              ],
            ),
            const SizedBox(width: 16),
            // Addresses
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("PICKUP LOCATION", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Obx(() {
                    String pickText = _searchDropLocationController.pickAddressController.value.text;
                    if (pickText.isEmpty) pickText = "Fetching location...";
                    return Text(
                      pickText,
                      style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  }),
                  const SizedBox(height: 12),
                  const Text("WHERE TO?", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () {
                      _searchDropLocationController.isFromBookingScreen.value = false;
                      Get.to(const SearchDropLocationScreen())!.then((value) {
                        Future.delayed(const Duration(seconds: 1), () {
                          if (_searchDropLocationController.pickLat.value != 0.0 &&
                              _searchDropLocationController.pickLng.value != 0.0) {
                            _controller.hitCustomerGetDashBoardApi(callBack: () {});
                          }
                          if (_searchDropLocationController.dropAddressController.value.text.isNotEmpty) {
                            _controller.polyline.refresh();
                            _controller.hitCheckFareApi(callBack: () {
                              openFareBottomSheet(Get.context!);
                            });
                          }
                        });
                      });
                    },
                    child: Obx(() {
                      String dropText = _searchDropLocationController.dropAddressController.value.text;
                      if (dropText.isEmpty) dropText = "Enter drop location";
                      return Text(
                        dropText,
                        style: TextStyle(
                          color: dropText == "Enter drop location" ? Colors.black54 : Colors.black87, 
                          fontSize: 14, 
                          fontWeight: FontWeight.w600
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Location target icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.my_location, color: Colors.black, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
        ]
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _tripOption(1, "Daily", "For local travel", Icons.calendar_month),
              _tripOption(2, "Rental", "By the hour/day", Icons.access_time_filled),
              _tripOption(3, "Outstation", "Intercity travel", Icons.edit_road),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Choose your ride", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
              Text("View all", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() {
            double distance = _controller.bookingRideModel.value.data?.km ?? 0.0;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  if (distance < 120)
                    _vehicleOption(AppStrings.strHatchback, 1, Image.asset(AppImages.icHatchback, height: 40), "4 Seats"),
                  if (distance < 120) const SizedBox(width: 12),
                  _vehicleOption(AppStrings.strSedan, 2, Image.asset(AppImages.icSedan, height: 40), "4 Seats"),
                  const SizedBox(width: 12),
                  _vehicleOption(AppStrings.strSUV, 3, Image.asset(AppImages.imgkia, height: 40), "6 Seats"),
                  const SizedBox(width: 12),
                  _vehicleOption(AppStrings.strSUVPrime, 4, Image.asset(AppImages.imginnova, height: 40), "6 Seats"),
                ],
              ),
            );
          }),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () {
              if (_searchDropLocationController.dropAddressController.value.text.isNotEmpty) {
                _controller.hitCheckFareApi(callBack: () {
                  if (Get.isBottomSheetOpen ?? false) Get.back();
                  Future.delayed(const Duration(milliseconds: 300), () {
                    openFareBottomSheet(Get.context!);
                  });
                });
              } else {
                Get.snackbar("Location Required", "Please enter a drop location to find rides");
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Text("Find Rides", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  Positioned(
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: Icon(Icons.arrow_forward, color: Colors.blue.shade700, size: 16),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _tripOption(int index, String title, String subtitle, IconData icon) {
    return Obx(() {
      bool isSelected = _controller.selectedTripTypeIndex.value == index;
      return GestureDetector(
        onTap: () {
          if (index == 2) {
            Get.dialog(
              AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                title: const Text("Coming Soon", style: TextStyle(fontWeight: FontWeight.bold)),
                content: const Text("BookFast Rental service will start soon!"),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("OK", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          } else {
            _controller.selectTripType(index);
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.blue.shade900, size: 28),
            ),
            const SizedBox(height: 8),
            Image.asset(AppImages.icSedan, height: 25), // Reusing existing car asset
            const SizedBox(height: 8),
            Text(title, style: TextStyle(fontSize: 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.bold, color: Colors.black87)),
            Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      );
    });
  }

  Widget _vehicleOption(String title, int index, Image image, String seats) {
    return Obx(() {
      bool isSelected = _controller.selectedVehicleTypeIndex.value == index;
      return GestureDetector(
        onTap: () {
          _controller.selectVehicleType(index);
        },
        child: Container(
          width: 105,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? Colors.blue.shade700 : Colors.grey.shade300, width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 8),
              image,
              const SizedBox(height: 8),
              Text(seats, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
        ),
      );
    });
  }

"""
    lines[start_index:end_index] = [new_content + "\n"]
    
    with open('/Volumes/samsung-apple/Developer/bookfast/App/bookfast_customer-app/lib/ui/screens/home_map_view_screen.dart', 'w') as f:
        f.writelines(lines)
    print("Success")
else:
    print("Failed to find boundaries")
