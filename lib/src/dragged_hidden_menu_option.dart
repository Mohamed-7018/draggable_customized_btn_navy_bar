part of draggable_customized_btn_navy_bar;

class DraggedHiddenMenuOption extends StatefulWidget {
  final IconData? iconData;
  final String? name;
  final StreamController<DragItemUpdate>? dragItemUpdateStream;
  final DraggableCustomizedDotBarItem? bottomItem;
  final StatusDragged statusDragged;
  final double translateData;
  final bool blockAnimationHiddenMenuOption;
  final Color backgroundColor;
  final Color colorIcon;
  final Color colorText;

  const DraggedHiddenMenuOption(
      {Key? key,
      this.iconData,
      required this.dragItemUpdateStream,
      this.name,
      this.bottomItem,
      required this.statusDragged,
      required this.translateData,
      required this.blockAnimationHiddenMenuOption,
      required this.backgroundColor,
      required this.colorIcon,
      required this.colorText})
      : super(key: key);

  @override
  DraggedHiddenMenuOptionState createState() => DraggedHiddenMenuOptionState();
}

class DraggedHiddenMenuOptionState extends State<DraggedHiddenMenuOption> {
  final GlobalKey _keyItem = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        key: _keyItem,
        onPanStart: (widget.statusDragged != StatusDragged.unDragged)
            ? (details) {
                final RenderBox renderBox =
                    _keyItem.currentContext!.findRenderObject() as RenderBox;
                final position = renderBox.localToGlobal(Offset.zero);
                widget.dragItemUpdateStream!.add(DragItemUpdate(
                    widget.bottomItem,
                    position,
                    EventDragEnum.start,
                    TypeMenuOption.hidden));
              }
            : null,
        onPanUpdate: (widget.statusDragged != StatusDragged.unDragged)
            ? (details) {
                widget.dragItemUpdateStream!.add(DragItemUpdate(
                    widget.bottomItem,
                    details.delta,
                    EventDragEnum.update,
                    TypeMenuOption.hidden));
              }
            : null,
        onPanEnd: (widget.statusDragged != StatusDragged.unDragged)
            ? (details) {
                widget.dragItemUpdateStream!.add(DragItemUpdate(
                    widget.bottomItem,
                    null,
                    EventDragEnum.end,
                    TypeMenuOption.hidden));
              }
            : null,
        child: widget.statusDragged != StatusDragged.dragged
            ? (widget.blockAnimationHiddenMenuOption
                ? Transform(
                    transform: Matrix4.translationValues(
                        widget.statusDragged == StatusDragged.dragged
                            ? .0
                            : widget.translateData,
                        .0,
                        .0),
                    child: HiddenMenuOption(
                        iconData: widget.iconData,
                        name: widget.name,
                        backgroundColor: widget.backgroundColor,
                        colorIcon: widget.colorIcon,
                        colorText: widget.colorText))
                : AnimatedContainer(
                    curve: Curves.ease,
                    duration: const Duration(milliseconds: 200),
                    transform: Matrix4.translationValues(
                        widget.statusDragged == StatusDragged.dragged
                            ? .0
                            : widget.translateData,
                        .0,
                        .0),
                    child: HiddenMenuOption(
                        iconData: widget.iconData,
                        name: widget.name,
                        backgroundColor: widget.backgroundColor,
                        colorIcon: widget.colorIcon,
                        colorText: widget.colorText)))
            : Container());
  }
}
