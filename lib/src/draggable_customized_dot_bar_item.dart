part of draggable_customized_btn_navy_bar;

/// [DraggableCustomizedDotBarItem] Represents an item, it can be hidden or in the navigation bar
class DraggableCustomizedDotBarItem {
  /// Unique key
  final String keyItem;

  /// Item icon
  final IconData? icon;

  /// Item name
  final Function(String)? onTap;

  /// Event with you press the item.
  final String? name;

  /// Constructor
  const DraggableCustomizedDotBarItem(this.keyItem,
      {this.name, this.icon, this.onTap});
}
