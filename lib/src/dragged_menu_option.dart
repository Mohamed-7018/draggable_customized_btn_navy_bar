part of draggable_customized_btn_navy_bar;

class DraggedMenuOption extends StatefulWidget {
  final IconData? iconData;
  final Color? colorIcon;
  final GestureTapCallback? onTap;
  final double? translate;
  final StatusDragged statusDragged;
  final DraggableCustomizedDotBarItem? bottomItem;
  final StreamController<DragItemUpdate>? dragItemUpdateStream;
  final bool settingVisible;
  final bool animationItemNavigator;

  const DraggedMenuOption(
      {Key? key,
      this.iconData,
      this.colorIcon,
      this.onTap,
      this.translate,
      required this.statusDragged,
      required this.bottomItem,
      required this.dragItemUpdateStream,
      required this.settingVisible,
      required this.animationItemNavigator})
      : super(key: key);

  @override
  DraggedMenuOptionState createState() => DraggedMenuOptionState();
}

class DraggedMenuOptionState extends State<DraggedMenuOption> {
  final GlobalKey _keyItem = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final activeDrag = widget.statusDragged != StatusDragged.unDragged &&
        widget.settingVisible;
    return GestureDetector(
      key: _keyItem,
      onPanStart: activeDrag
          ? (details) {
              final RenderBox renderBox =
                  _keyItem.currentContext!.findRenderObject() as RenderBox;
              final position = renderBox.localToGlobal(Offset.zero);
              widget.dragItemUpdateStream!.add(DragItemUpdate(
                  widget.bottomItem,
                  Offset(position.dx - 27, position.dy - 16),
                  EventDragEnum.start,
                  TypeMenuOption.navigation));
            }
          : null,
      onPanUpdate: activeDrag
          ? (details) {
              widget.dragItemUpdateStream!.add(DragItemUpdate(
                  widget.bottomItem,
                  details.delta,
                  EventDragEnum.update,
                  TypeMenuOption.navigation));
            }
          : null,
      onPanEnd: activeDrag
          ? (details) {
              widget.dragItemUpdateStream!.add(DragItemUpdate(widget.bottomItem,
                  null, EventDragEnum.end, TypeMenuOption.navigation));
            }
          : null,
      child: widget.statusDragged != StatusDragged.dragged
          ? (widget.animationItemNavigator
              ? AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.ease,
                  transform:
                      Matrix4.translationValues(widget.translate!, .0, .0),
                  child: MenuOption(widget.iconData, widget.colorIcon,
                      widget.onTap, !widget.settingVisible),
                )
              : Container(
                  transform:
                      Matrix4.translationValues(widget.translate!, .0, .0),
                  child: MenuOption(widget.iconData, widget.colorIcon,
                      widget.onTap, !widget.settingVisible),
                ))
          : Container(
              width: 30.0,
            ),
    );
  }
}
