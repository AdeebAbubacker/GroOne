import 'package:flutter/material.dart';

class MapFloatingMenu extends StatefulWidget {
  final VoidCallback? onToggleTraffic;
  final VoidCallback? onToggleMapType;
  final VoidCallback? onReachability;
  final VoidCallback? onNearbyVehicles;
  final VoidCallback? onNearbyPlaces;
  final bool isTrafficEnabled;
  final bool isSatellite;

  const MapFloatingMenu({
    super.key,
    this.onToggleTraffic,
    this.onToggleMapType,
    this.onReachability,
    this.onNearbyVehicles,
    this.onNearbyPlaces,
    this.isTrafficEnabled = false,
    this.isSatellite = false,
  });

  @override
  State<MapFloatingMenu> createState() => _MapFloatingMenuState();
}

class _MapFloatingMenuState extends State<MapFloatingMenu>
    with TickerProviderStateMixin {
  bool _isOpen = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isOpen = !_isOpen;
    });

    if (_isOpen) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _onOptionTap(String option) {
    switch (option) {
      case 'Traffic':
        widget.onToggleTraffic?.call();
        break;
      case 'Satellite Map':
        widget.onToggleMapType?.call();
        break;
      case 'Reachability':
        widget.onReachability?.call();
        break;
      case 'Nearby Vehicles':
        widget.onNearbyVehicles?.call();
        break;
      case 'Nearby Places':
        widget.onNearbyPlaces?.call();
        break;
    }
    _toggleMenu();
  }

  @override
  Widget build(BuildContext context) {
    final options = [
      {
        'label': 'Reachability',
        'iconPath': 'assets/icons/png/traffic_light_icon.png',
      },
      {
        'label': 'Traffic',
        'iconPath': 'assets/icons/png/traffic_light_icon.png',
      },
      {
        'label': 'Nearby Vehicles',
        'iconPath': 'assets/icons/png/delivery_truck_icon.png',
      },
      {
        'label': 'Satellite Map',
        'iconPath': 'assets/icons/png/map_geofence_satellite.png',
      },
      {
        'label': 'Nearby Places',
        'iconPath': 'assets/icons/png/map_pins_icon.png',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_isOpen)
          ...options.asMap().entries.map((entry) {
            final idx = entry.key;
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(
                      (idx * 0.1).clamp(0.0, 1.0),
                      ((idx + 1) * 0.1).clamp(0.0, 1.0),
                      curve: Curves.easeOut,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        onPressed:
                            () => _onOptionTap(entry.value['label'] as String),
                        child: Text(
                          entry.value['label'] as String,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Image.asset(
                            entry.value['iconPath'] as String,
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: _toggleMenu,
          child: Icon(_isOpen ? Icons.close : Icons.add, color: Colors.white),
        ),
      ],
    );
  }
}
