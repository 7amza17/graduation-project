import 'package:flutter/material.dart';

class MarqueeText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration speed;

  const MarqueeText({
    super.key,
    required this.text,
    required this.style,
    this.speed = const Duration(seconds: 6),
  });

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText>
    with SingleTickerProviderStateMixin {
  late final ScrollController _controller;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ready = true;
      _startScrollLoop();
    });
  }

  void _startScrollLoop() async {
    if (!_ready || !_controller.hasClients) return;

    while (mounted) {
      final maxScroll = _controller.position.maxScrollExtent;
      if (maxScroll == 0) return;

      await _controller.animateTo(
        maxScroll,
        duration: widget.speed,
        curve: Curves.linear,
      );

      await Future.delayed(const Duration(milliseconds: 300));

      _controller.jumpTo(0);

      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.style.fontSize! + 12,
      child: ListView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Text(widget.text, style: widget.style),
          const SizedBox(width: 60),
        ],
      ),
    );
  }
}
