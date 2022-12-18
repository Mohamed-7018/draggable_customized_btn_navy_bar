part of draggable_customized_btn_navy_bar;

class DragItemUpdate {
  final DraggableCustomizedDotBarItem? item;
  final Offset? position;
  final EventDragEnum eventDragEnum;
  final TypeMenuOption typeMenuOption;

  DragItemUpdate(
      this.item, this.position, this.eventDragEnum, this.typeMenuOption);
}
