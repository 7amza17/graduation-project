import 'package:flutter/material.dart';
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

  void _onViewChanged(double longitude, double latitude, double tilt) {
    setState(() {
      _lon = longitude;
      _lat = latitude;
      _tilt = tilt;
    });
  }

  void _goToRoom(int index) {
    if (index < 0 || index >= widget.images.length) return;
    setState(() {
      _currentIndex = index;
    });
  }

   Widget _hotspotButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          style: ButtonStyle(
            shape: WidgetStateProperty.all(const CircleBorder()),
            backgroundColor: WidgetStateProperty.all(Colors.black38),
            foregroundColor: WidgetStateProperty.all(Colors.white),
          ),
          onPressed: onPressed,
          child: Icon(icon),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(text, style: const TextStyle(fontSize: 10)),
        ),
      ],
    );
  }

  List<Hotspot> _buildHotspots() {
    final List<Hotspot> hotspots = [];

    final bool hasNext = _currentIndex < widget.images.length - 1;
    final bool hasPrev = _currentIndex > 0;

     if (hasNext) {
      hotspots.add(
        Hotspot(
          latitude: 0.0,
          longitude: 90.0, 
          width: 90.0,
          height: 80.0,
          widget: _hotspotButton(
            text: 'الغرفة التالية',
            icon: Icons.double_arrow,
            onPressed: () => _goToRoom(_currentIndex + 1),
          ),
        ),
      );
    }

     if (hasPrev) {
      hotspots.add(
        Hotspot(
          latitude: 0.0,
          longitude: -90.0, 
          width: 90.0,
          height: 80.0,
          widget: _hotspotButton(
            text: 'الغرفة السابقة',
            icon: Icons.keyboard_backspace,
            onPressed: () => _goToRoom(_currentIndex - 1),
          ),
        ),
      );
    }

    return hotspots;
  }

  @override
  Widget build(BuildContext context) {
    final String currentImage = widget.images[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          '${widget.title}  |  غرفة ${_currentIndex + 1} / ${widget.images.length}',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
           IconButton(
            icon: Icon(
              _showDebugInfo ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _showDebugInfo = !_showDebugInfo;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
           PanoramaViewer(
             animSpeed: 0.1,

             sensorControl: SensorControl.orientation,

             onViewChanged: _onViewChanged,

             hotspots: _buildHotspots(),

             child: Image.asset(currentImage),
          ),

           Positioned(
            top: 20,
            right: 20,
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.5),
              child: Text(
                '${_currentIndex + 1}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
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
