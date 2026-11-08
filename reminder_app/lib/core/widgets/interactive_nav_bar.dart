import 'package:flutter/material.dart';

// Navigasi bar bawah dengan animasi bouncy saat ikon ditekan.
class InteractiveNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;

  const InteractiveNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  State<InteractiveNavBar> createState() => _InteractiveNavBarState();
}

class _InteractiveNavBarState extends State<InteractiveNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  int _pressedIndex = -1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(int index) {
    setState(() => _pressedIndex = index);
    _controller.forward(from: 0);
  }

  void _onTapUp(int index) {
    widget.onTap(index);
    setState(() => _pressedIndex = -1);
    _controller.reverse();
  }

  // Helper untuk mengambil IconData dari widget Icon.
  IconData _getIconData(Widget? iconWidget) {
    if (iconWidget is Icon) return iconWidget.icon ?? Icons.circle;
    return Icons.circle;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BottomAppBar(
      color: colorScheme.surface,
      elevation: 8,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(widget.items.length, (index) {
            final isActive = index == widget.currentIndex;
            final isPressed = index == _pressedIndex;

            return Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (_) => _onTapDown(index),
                onTapUp: (_) => _onTapUp(index),
                onTapCancel: () => setState(() => _pressedIndex = -1),
                child: AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: isPressed ? _scaleAnimation.value : 1.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isActive
                                ? _getIconData(widget.items[index].activeIcon)
                                : _getIconData(widget.items[index].icon),
                            color: isActive
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant,
                            size: 26,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.items[index].label ?? '',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isActive
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isActive
                                  ? colorScheme.primary
                                  : colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
