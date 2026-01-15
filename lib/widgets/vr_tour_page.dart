import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:panorama_viewer/panorama_viewer.dart';

class VRTourPage extends StatefulWidget {
  final String title;
  final List<String> images;

  const VRTourPage({super.key, required this.title, required this.images});

  @override
  State<VRTourPage> createState() => _VRTourPageState();
}

class _VRTourPageState extends State<VRTourPage> {
  int _currentIndex = 0;

  double _lon = 0;
  double _lat = 0;
  double _tilt = 0;
  bool _showDebugInfo = false;

  bool _showTopBar = false;

  static const double _topBarAreaHeight = 140.0;
  static const double _menuBoxSize = 56.0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _onViewChanged(double longitude, double latitude, double tilt) {
    setState(() {
      _lon = longitude;
      _lat = latitude;
      _tilt = tilt;
    });
  }

  void _goToRoom(int index) {
    if (index < 0 || index >= widget.images.length) return;
    setState(() => _currentIndex = index);
  }

  void _hideTopBar() {
    if (_showTopBar) {
      setState(() => _showTopBar = false);
    }
  }

  void _handleAnyTouchToHide(Offset _, BuildContext __) {
    if (_showTopBar) _hideTopBar();
  }

  Widget _hotspotButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          elevation: 10,
          shadowColor: const Color(0xFF00E5FF).withOpacity(0.35),
          shape: const CircleBorder(),
          child: Ink(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF00D2FF),
                  Color(0xFF3A7BD5),
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.35),
                width: 1.2,
              ),
            ),
            child: InkWell(
              customBorder: const CircleBorder(),
              splashColor: Colors.white.withOpacity(0.25),
              highlightColor: Colors.white.withOpacity(0.10),
              onTap: onPressed,
              child: Center(
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black.withOpacity(0.55),
                Colors.black.withOpacity(0.25),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    );
  }

  List<Hotspot> _buildHotspots() {
    final List<Hotspot> hotspots = [];

    if (_currentIndex < widget.images.length - 1) {
      hotspots.add(
        Hotspot(
          latitude: 0.0,
          longitude: 90.0,
          width: 120,
          height: 120,
          widget: _hotspotButton(
            text: 'الغرفة التالية',
            icon: Icons.arrow_forward_rounded,
            onPressed: () => _goToRoom(_currentIndex + 1),
          ),
        ),
      );
    }

    if (_currentIndex > 0) {
      hotspots.add(
        Hotspot(
          latitude: 0.0,
          longitude: -90.0,
          width: 120,
          height: 120,
          widget: _hotspotButton(
            text: 'الغرفة السابقة',
            icon: Icons.arrow_back_rounded,
            onPressed: () => _goToRoom(_currentIndex - 1),
          ),
        ),
      );
    }

    return hotspots;
  }

  Widget _buildTopBar() {
    final bool hasPrev = _currentIndex > 0;

    return SafeArea(
      bottom: false,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.55),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (hasPrev)
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => _goToRoom(_currentIndex - 1),
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'غرفة ${_currentIndex + 1}/${widget.images.length}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String currentImage = widget.images[_currentIndex];

    return Scaffold(
      body: Stack(
        children: [
          PanoramaViewer(
            sensitivity: 2.0,
            sensorControl: SensorControl.orientation,
            onViewChanged: _onViewChanged,
            hotspots: _buildHotspots(),
            child: Image.asset(currentImage),
          ),

          Positioned.fill(
            child: Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown: (e) => _handleAnyTouchToHide(e.position, context),
              onPointerMove: (e) => _handleAnyTouchToHide(e.position, context),
              child: const SizedBox.expand(),
            ),
          ),

          if (!_showTopBar)
            SafeArea(
              bottom: false,
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, right: 8),
                  child: Material(
                    color: Colors.black.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => setState(() => _showTopBar = true),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        child: Icon(
                          Icons.more_vert,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            left: 0,
            right: 0,
            top: _showTopBar ? 0 : -_topBarAreaHeight,
            child: _buildTopBar(),
          ),

          if (_showDebugInfo)
            Positioned(
              left: 10,
              bottom: 10,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'lon: ${_lon.toStringAsFixed(2)}, '
                  'lat: ${_lat.toStringAsFixed(2)}, '
                  'tilt: ${_tilt.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
