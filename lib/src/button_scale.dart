part of draggable_customized_btn_navy_bar;

class ButtonScale extends StatefulWidget {
  final Widget? child;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final Color? color;
  final double minScale;
  final bool activeOpacity;

  const ButtonScale(
      {Key? key,
      required this.onTap,
      this.child,
      this.borderRadius,
      this.color,
      this.minScale = 0.90,
      this.activeOpacity = false})
      : super(key: key);

  @override
  ButtonScaleState createState() => ButtonScaleState();
}

class ButtonScaleState extends State<ButtonScale>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _scaleAnimation =
        Tween(begin: 1.0, end: widget.minScale).animate(_animationController);
    _opacityAnimation =
        Tween(begin: 1.0, end: 0.7).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _animationController.forward();
      },
      onTapUp: (_) {
        _animationController.reverse();
      },
      onTapCancel: () {
        _animationController.reverse();
      },
      onTap: widget.onTap,
      child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              alignment: FractionalOffset.center,
              child: widget.activeOpacity
                  ? Opacity(
                      opacity: _opacityAnimation.value,
                      child: _buildContent(child))
                  : _buildContent(child),
            );
          },
          child: widget.child),
    );
  }

  Widget _buildContent(Widget? child) {
    return Container(
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: widget.borderRadius,
        ),
        child: child);
  }
}
