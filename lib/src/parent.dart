part of draggable_customized_btn_navy_bar;

/// [DraggableCustomizedBtnNavyBar] Parent class to create a custom navigation bar
class DraggableCustomizedBtnNavyBar extends StatefulWidget {
  /// List of items to be displayed in the navigation bar
  final List<DraggableCustomizedDotBarItem?> items;

  //// max number of displayed items
  final int maximumNumberOfDisplayItems;

  /// function to be done if the user want to add item
  /// to the displayed items and he reaches to the max
  /// diplayed number of items
  final void Function()? onDisplayedStackOverflows;

  /// min number of displayed items
  final int minimumNumberOfDisplayedItems;

  /// function to be done if the user want to remove item
  /// from the displayed items and he reaches to the min
  /// diplayed number of items
  final void Function()? onDisplayedStackIsEmpty;

  /// List of items that will be hidden
  final List<DraggableCustomizedDotBarItem?> hiddenItems;

  /// Item key that is selected
  final String? keyItemSelected;

  /// Navigation bar width
  final double? width;

  /// Navigation bar height
  final double height;

  /// Navigation bar radius
  final BorderRadius borderRadius;

  /// Selected Icon color
  final Color selectedColorIcon;

  /// Unselected Icon color
  final Color unSelectedColorIcon;

  /// Navigator Container Background color
  final Color navigatorBackground;

  /// Setting Container Background color (Hidden items)
  final Color settingBackground;

  /// Settings button icon
  final IconData iconSetting;

  /// Settings button icon color
  final Color iconSettingColor;

  /// Setting Title Text
  final String settingTitleText;

  /// Setting Title color
  final Color settingTitleColor;

  /// Setting Sub-Title Text
  final String settingSubTitleText;

  /// Setting Sub-Title color
  final Color settingSubTitleColor;

  /// Done button Text
  final String doneText;

  /// Text Done Color
  final Color textDoneColor;

  /// Button done color
  final Color buttonDoneColor;

  /// Background of hidden item
  final Color hiddenItemBackground;

  /// Icon Hidden Color
  final Color iconHiddenColor;

  /// Text Hidden Color
  final Color textHiddenColor;

  /// Selection Indicator Color (Dot|Point)
  final Color dotColor;

  /// Shadow of container
  final List<BoxShadow>? boxShadow;

  /// Event when you sort the hidden options, this has as parameter the list of hidden options with the new order.
  final Function(List<DraggableCustomizedDotBarItem?>? hiddenItems)?
      onOrderHideItems;

  /// Event when ordering browser options, this has as parameter the list of options with the new order.
  final Function(List<DraggableCustomizedDotBarItem?>? items)? onOrderItems;

  /// Event when you add a new option to the navigation bar, this has as parameters the item you add and the list of options.
  final Function(DraggableCustomizedDotBarItem? itemAdd,
      List<DraggableCustomizedDotBarItem?>? items)? onAddItem;

  /// Event when you delete an option from the navigation bar, this has as parameters the element to delete and the list of hidden options.
  final Function(DraggableCustomizedDotBarItem? itemRemove,
      List<DraggableCustomizedDotBarItem?>? hiddenItems)? onRemoveItem;

  /// Constructor
  const DraggableCustomizedBtnNavyBar({
    required this.items,
    required this.hiddenItems,
    Key? key,
    this.width,
    this.height = 60.0,
    this.settingBackground = appPink,
    this.iconSettingColor = kScaffoldLight,
    this.buttonDoneColor = appBlue,
    this.settingSubTitleColor = appBlue,
    this.dotColor = appPink,
    this.textDoneColor = kScaffoldLight,
    this.borderRadius = const BorderRadius.vertical(top: Radius.circular(60.0)),
    this.selectedColorIcon = appPink,
    this.unSelectedColorIcon = kScaffoldLight,
    this.boxShadow,
    this.navigatorBackground = appBlue,
    // this.settingBackground = appPink,
    // this.iconSettingColor = kScaffoldLight,
    this.iconSetting = Icons.content_copy,
    this.settingTitleText = 'Your Menu',
    this.settingSubTitleText = 'Drag and drop options',
    this.doneText = 'Done',
    // this.buttonDoneColor = appPink,
    this.settingTitleColor = Colors.white,
    // this.settingSubTitleColor = appBlue,
    this.onOrderHideItems,
    this.onOrderItems,
    this.onAddItem,
    this.onRemoveItem,
    this.keyItemSelected,
    this.hiddenItemBackground = Colors.white,
    this.iconHiddenColor = Colors.black,
    this.textHiddenColor = Colors.black,
    this.maximumNumberOfDisplayItems = 5,
    this.minimumNumberOfDisplayedItems = 1,
    this.onDisplayedStackOverflows,
    this.onDisplayedStackIsEmpty,
    // this.textDoneColor = Colors.black,
    // this.dotColor = const Color(0xBB000000)
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DraggableCustomizedBtnNavyBarState();
}

class _DraggableCustomizedBtnNavyBarState
    extends State<DraggableCustomizedBtnNavyBar> {
  StreamController<DragItemUpdate>? dragItemUpdateStream;
  ScrollController? _scrollController;
  double? _positionIndicatorDot;
  double? _widthBase;
  double _navContainerTranslate = .0;
  bool _activeLimitScroll = false;
  bool? _isRightDirection = true; /////////// remember/////////
  bool _settingVisible = false;
  bool? _buttonSettingVisible = false;
  Offset? _positionDrag = Offset.zero;
  Offset? _initPositionItem = Offset.zero;
  List<double> _translateItemList = [];
  List<double> _translateHiddenItemList = [];
  DraggableCustomizedDotBarItem? _draggedItem;
  bool _blockAnimationHiddenMenuOption = true;
  bool _animationItemNavigator = false;
  List<DraggableCustomizedDotBarItem?>? _internalItems;
  List<DraggableCustomizedDotBarItem?>? _internalHiddenItems;
  late List<DraggableCustomizedDotBarItem?> _all;
  late Map<String, DraggableCustomizedDotBarItem> map;
  String get _suffix => (widget.key?.toString() ?? "").replaceAll(RegExp(r'[\W]'), "_");

  List<String> keys = [];
  List<String> unKey = [];
  // int max = 5;
  // int min = 1;
  // List<String> keys = ['item-5', 'item-9', 'item-6', 'item-1'];
  late List temp = [];
  void _buildPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    keys = prefs.getStringList(
            'draggable_customized_btn_navy_bar_keys_package_samir'+_suffix) ??
        [];
    unKey = prefs.getStringList(
            'undraggable_customized_btn_navy_bar_keys_package_samir'+_suffix) ??
        [];
    if (keys.isNotEmpty) {
      _internalItems = [];
      _internalHiddenItems = [];
      for (int i = 0; i < _all.length; i++) {
        temp.add(_all[i]!.keyItem);
        if (unKey.isEmpty) {
          // un key is empty
          if (!keys.contains(_all[i]!.keyItem)) {
            if (kDebugMode) {
              print("${_all[i]!.keyItem} - ${_all[i]!.name}");
            }
            _internalHiddenItems!.add(_all[i]);
          }
        }
      }

      ////////
      if (unKey.isNotEmpty) {
        for (int i = 0; i < unKey.length; i++) {
          _internalHiddenItems!.add(_all[temp.indexOf(unKey[i])]);
        }
      }
      ///////

      for (int i = 0; i < keys.length; i++) {
        _internalItems!.add(_all[temp.indexOf(keys[i])]);
      }
    }
    setState(() {});
  }

  void _updatePrefs(List<String> keys) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        'draggable_customized_btn_navy_bar_keys_package_samir'+_suffix, keys);
  }

  void _updateUnPrefs(List<String> unkeys) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        'undraggable_customized_btn_navy_bar_keys_package_samir'+_suffix, unkeys);
  }

  @override
  void initState() {
    _internalItems = widget.items;
    _internalHiddenItems = widget.hiddenItems;
    _all = [];
    for (int i = 0; i < _internalItems!.length; i++) {
      _all.add(_internalItems![i]);
    }
    for (int i = 0; i < _internalHiddenItems!.length; i++) {
      _all.add(_internalHiddenItems![i]);
    }

    ///
    _buildPrefs();
    //////

    dragItemUpdateStream = StreamController<DragItemUpdate>();
    _scrollController = ScrollController();
    dragItemUpdateStream!.stream.listen((event) {
      setState(() {
        if (event.eventDragEnum == EventDragEnum.start) {
          _draggedItem = event.item;
          _animationItemNavigator = true;
          _initPositionItem = event.typeMenuOption == TypeMenuOption.navigation
              ? Offset(event.position!.dx - .5, event.position!.dy + 7.0)
              : event.position;
          _positionDrag = event.typeMenuOption == TypeMenuOption.navigation
              ? Offset(event.position!.dx, event.position!.dy - 15.0)
              : event.position;
          if (event.typeMenuOption == TypeMenuOption.navigation) {
            _translateItemList = getTranslateItemListFromBottom(
                _positionXNavigator(_positionDrag!.dx), .0, .0);
          } else {
            _translateHiddenItemList = getTranslateHiddenItemListFromTop(
                _positionXNavigator(_initPositionItem!.dx), .0, .0);
          }
        } else if (event.eventDragEnum == EventDragEnum.update) {
          _blockAnimationHiddenMenuOption = false;
          _positionDrag = Offset(_positionDrag!.dx + event.position!.dx,
              _positionDrag!.dy + event.position!.dy);
          final initXPositionDrag = _positionDrag!.dx - _initPositionItem!.dx;
          final initYPositionDrag = _positionDrag!.dy - _initPositionItem!.dy;
          if (event.typeMenuOption == TypeMenuOption.navigation) {
            _translateHiddenItemList = getTranslateHiddenItemListFromBottom(
                _positionXNavigator(_positionDrag!.dx), initYPositionDrag);
            _translateItemList = getTranslateItemListFromBottom(
                _positionXNavigator(_positionDrag!.dx),
                initXPositionDrag,
                initYPositionDrag);
          } else {
            _translateHiddenItemList = getTranslateHiddenItemListFromTop(
                _positionXNavigator(_positionDrag!.dx),
                initXPositionDrag,
                initYPositionDrag);
            _translateItemList = getTranslateItemListFromTop(
                _positionXNavigator(_positionDrag!.dx), initYPositionDrag);
          }
        } else if (event.eventDragEnum == EventDragEnum.end) {
          final initXPositionDrag = _positionDrag!.dx - _initPositionItem!.dx;
          final initYPositionDrag = _positionDrag!.dy - _initPositionItem!.dy;
          final xPosition = _positionXNavigator(_positionDrag!.dx);
          if (event.typeMenuOption == TypeMenuOption.navigation) {
            if (initYPositionDrag >= -60.0 &&
                ((xPosition + 110.0) >= -25.0 &&
                    (xPosition + 110.0) <= (_widthBase! - 55))) {
              if (_translateItemList.any((value) => value != .0)) {
                final oldIndex = _internalItems!.indexOf(_draggedItem);
                final newIndex = initXPositionDrag.isNegative
                    ? _translateItemList.indexWhere((value) => value != .0)
                    : _translateItemList.lastIndexWhere((value) => value != .0);
                final double positionX =
                    (_widthBase! / (_internalItems!.length) * 0.5) *
                        (newIndex + (newIndex + 1));
                double differenceWidth = _differenceWidthContainer() - 110.0;
                _positionDrag = Offset(
                    differenceWidth + positionX - 42.5, _initPositionItem!.dy);
                _translateHiddenItemList = [];
                _animationItemNavigator = false;
                _executeAfterAnimation(() {
                  _reorderItemList(oldIndex, newIndex);
                  _translateItemList = [];
                  _resetOperators();
                });
              } else {
                _positionDrag = _initPositionItem;
                _translateItemList = [];
                _translateHiddenItemList = [];
                _executeAfterAnimation(_resetOperators);
              }
            } else if ((initYPositionDrag >= -250.0 &&
                    initYPositionDrag <= -40.0) &&
                (xPosition >= -80.0 && xPosition <= (_widthBase! - 20))) {
              final indexItemRemove = _internalItems!.indexOf(_draggedItem);
              final indexPositionHidden =
                  _translateHiddenItemList.indexWhere((value) => value != .0);
              _translateHiddenItemList = _translateHiddenItemList
                  .map((value) => value == .0 ? .0 : 105.0)
                  .toList();
              final heightYPosition =
                  MediaQuery.of(context).size.height - widget.height;
              _positionDrag = Offset(
                  (indexPositionHidden != -1
                              ? indexPositionHidden
                              : _translateHiddenItemList.length) *
                          105.0 +
                      _differenceWidthContainer() +
                      35.0 -
                      _scrollController!.offset,
                  heightYPosition - 121.0);
              _animationItemNavigator = false;
              _executeAfterAnimation(() {
                if (_internalItems!.length >
                    widget.minimumNumberOfDisplayedItems) {
                  _removeItemList(
                      indexItemRemove,
                      indexPositionHidden != -1
                          ? indexPositionHidden
                          : _translateHiddenItemList.length);
                } else {
                  widget.onDisplayedStackIsEmpty != null
                      ? widget.onDisplayedStackIsEmpty!()
                      : _roundedSnackBar(context, "The drawer can't be empty");
                }
                _translateItemList = [];
                _resetOperators();
              });
            } else {
              _positionDrag = _initPositionItem;
              _translateItemList = [];
              _translateHiddenItemList = [];
              _executeAfterAnimation(_resetOperators);
            }
          } else if (event.typeMenuOption == TypeMenuOption.hidden) {
            if (initYPositionDrag >= 80.0 &&
                (xPosition >= -135.0 && xPosition <= (_widthBase! - 165))) {
              final indexItem = _internalHiddenItems!.indexOf(_draggedItem);
              _translateHiddenItemList =
                  _translateHiddenItemList.map((value) => .0).toList();
              final indexNavigator = _translateItemList
                          .indexWhere((value) => !value.isNegative) !=
                      -1
                  ? _translateItemList.indexWhere((value) => !value.isNegative)
                  : _translateItemList.length;
              final yPosition =
                  MediaQuery.of(context).size.height - (widget.height * 0.5);
              double differenceWidth = _differenceWidthContainer() - 110.0;
              final double positionX =
                  (_widthBase! / (_internalItems!.length + 1) * 0.5) *
                      (indexNavigator + (indexNavigator + 1));
              _positionDrag =
                  Offset(differenceWidth + positionX - 42.5, yPosition - 34);
              _animationItemNavigator = false;
              _executeAfterAnimation(() {
                if (_internalItems!.length <
                    widget.maximumNumberOfDisplayItems) {
                  _insertItemToNavigator(indexItem, indexNavigator);
                } else {
                  widget.onDisplayedStackOverflows != null
                      ? widget.onDisplayedStackOverflows!()
                      : _roundedSnackBar(context, "No more items can be added");
                }
                _translateItemList = [];
                _resetOperators();
              });
            } else if ((initYPositionDrag >= -105.0 &&
                    initYPositionDrag <= 105.0) &&
                (xPosition >= -80.0 && xPosition <= (_widthBase! - 20))) {
              final oldIndex = _internalHiddenItems!.indexOf(_draggedItem);
              final previewValue =
                  oldIndex != 0 ? _translateHiddenItemList[oldIndex - 1] : .0;
              final nextValue = (oldIndex + 1) != _internalHiddenItems!.length
                  ? _translateHiddenItemList[oldIndex + 1]
                  : -1.0;
              if (previewValue != .0 || nextValue == .0) {
                _translateHiddenItemList = _translateHiddenItemList
                    .map((value) => value == .0 ? .0 : 105.0)
                    .toList();
                final newIndex = _translateHiddenItemList
                        .lastIndexWhere((value) => value == .0) +
                    (initXPositionDrag.isNegative ? 1 : 0);
                _positionDrag = Offset(
                    newIndex * 105.0 +
                        _differenceWidthContainer() +
                        35.0 -
                        _scrollController!.offset,
                    _initPositionItem!.dy);
                _executeAfterAnimation(() {
                  _reorderHiddenItemList(oldIndex, newIndex);
                  _resetOperators();
                });
              } else {
                _translateHiddenItemList = getTranslateHiddenItemListFromTop(
                    _positionXNavigator(_initPositionItem!.dx), .0, .0);
                _positionDrag = _initPositionItem;
                _translateItemList = [];
                _executeAfterAnimation(_resetOperators);
              }
            } else {
              _translateHiddenItemList = getTranslateHiddenItemListFromTop(
                  _positionXNavigator(_initPositionItem!.dx), .0, .0);
              _positionDrag = _initPositionItem;
              _translateItemList = [];
              _executeAfterAnimation(_resetOperators);
            }
          }
        }
      });
    });
    super.initState();
  }

  _roundedSnackBar(context, String text) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          //  style: GoogleFonts.lilyScriptOne(),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15),
          ),
        ),
      ),
    );
  }

  _executeAfterAnimation(Function() function) {
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        function();
      });
    });
  }

  _reorderHiddenItemList(int oldIndex, int newIndex) {
    final item = _internalHiddenItems!.removeAt(oldIndex);
    _internalHiddenItems!.insert(newIndex, item);
    if (widget.onOrderHideItems != null) {
      widget.onOrderHideItems!(_internalHiddenItems);
    }
    //////
    unKey = [];
    for (int i = 0; i < _internalHiddenItems!.length; i++) {
      unKey.add(_internalHiddenItems![i]!.keyItem);
    }
    _updateUnPrefs(unKey);
    //////
  }

  _reorderItemList(int oldIndex, int newIndex) {
    final item = _internalItems!.removeAt(oldIndex);
    _internalItems!.insert(newIndex, item);
    if (widget.onOrderItems != null) widget.onOrderItems!(_internalItems);
    keys = [];
    for (int i = 0; i < _internalItems!.length; i++) {
      keys.add(_internalItems![i]!.keyItem);
    }
    // print("/*---------------- reorder ----------------*/");
    // print(keys);
    _updatePrefs(keys);
  }

  _insertItemToNavigator(int indexItem, int indexNavigator) {
    final item = _internalHiddenItems!.removeAt(indexItem);
    _internalItems!.insert(indexNavigator, item);
    if (widget.onAddItem != null) widget.onAddItem!(item, _internalItems);
    keys = [];
    for (int i = 0; i < _internalItems!.length; i++) {
      keys.add(_internalItems![i]!.keyItem);
    }
    // print("/*---------------- insert ----------------*/");
    // print(keys);
    _updatePrefs(keys);
  }

  _removeItemList(int indexRemove, int indexHiddenPosition) {
    final item = _internalItems!.removeAt(indexRemove);
    _internalHiddenItems!.insert(indexHiddenPosition, item);
    if (widget.onRemoveItem != null) {
      widget.onRemoveItem!(item, _internalHiddenItems);
    }
    keys = [];
    for (int i = 0; i < _internalItems!.length; i++) {
      keys.add(_internalItems![i]!.keyItem);
    }
    // print("/*---------------- removes ----------------*/");
    // print(keys);
    _updatePrefs(keys);
  }

  void _resetOperators() {
    _draggedItem = null;
    _positionDrag = Offset.zero;
    _translateHiddenItemList = [];
    _blockAnimationHiddenMenuOption = true;
  }

  List<double> getTranslateHiddenItemListFromTop(double dragContainerXPosition,
      double initXPositionDrag, double initYPositionDrag) {
    return (initYPositionDrag >= -105.0 && initYPositionDrag <= 105.0) &&
            (dragContainerXPosition >= -80.0 &&
                dragContainerXPosition <= (_widthBase! - 20))
        ? Iterable<double>.generate(
            _internalHiddenItems!.length,
            (index) => (dragContainerXPosition + _scrollController!.offset) <=
                    (index * 105.0) +
                        (initXPositionDrag.isNegative ? 90.0 : -18.0)
                ? 105.0 - initYPositionDrag.abs().clamp(.0, 105)
                : .0).toList()
        : Iterable<double>.generate(_internalHiddenItems!.length, (index) => .0)
            .toList();
  }

  List<double> getTranslateHiddenItemListFromBottom(
      double dragContainerXPosition, double initYPositionDrag) {
    return (initYPositionDrag >= -250.0 && initYPositionDrag <= -40.0) &&
            (dragContainerXPosition >= -80.0 &&
                dragContainerXPosition <= (_widthBase! - 20))
        ? Iterable<double>.generate(
            _internalHiddenItems!.length,
            (index) =>
                (dragContainerXPosition - 110) + _scrollController!.offset <=
                        (index * 105.0) - 21.0
                    ? 105.0 - (initYPositionDrag + 134.0).abs().clamp(.0, 105)
                    : .0).toList()
        : Iterable<double>.generate(_internalHiddenItems!.length, (index) => .0)
            .toList();
  }

  List<double> getTranslateItemListFromTop(
      double dragContainerXPosition, double initYPositionDrag) {
    final navDragContainerXPosition = dragContainerXPosition + 110.0;
    if (initYPositionDrag >= 80.0 &&
        (navDragContainerXPosition >= -25.0 &&
            navDragContainerXPosition <= (_widthBase! - 55))) {
      final sizeList = _internalItems!.length;
      final baseDifference = ((_widthBase! / sizeList) * 0.5) -
          ((_widthBase! / (sizeList + 1)) * 0.5);
      return Iterable<int>.generate(_internalItems!.length, (i) {
        final limitSize = ((_widthBase! / (sizeList + 1)) * (i + 1)) - 42.0;
        if (navDragContainerXPosition <= limitSize) {
          final index = sizeList - 1 - i;
          return index + index + 1;
        } else {
          return -(i + (i + 1));
        }
      }).map((multiply) => baseDifference * multiply).toList();
    } else {
      return [];
    }
  }

  List<double> getTranslateItemListFromBottom(double dragContainerXPosition,
      double initXPositionDrag, double initYPositionDrag) {
    final navDragContainerXPosition = dragContainerXPosition + 110.0;
    final lengthList = _internalItems!.length;
    if (initYPositionDrag >= -60.0 &&
        (navDragContainerXPosition >= -25.0 &&
            navDragContainerXPosition <= (_widthBase! - 55))) {
      final indexSelected = _internalItems!.indexOf(_draggedItem);
      final fractionWidth = _widthBase! / lengthList;
      return Iterable<int>.generate(lengthList, (i) {
        final limitSize =
            fractionWidth * (i + (i <= indexSelected ? 1 : 0)) - 42.0;
        return (navDragContainerXPosition <= limitSize)
            ? i < indexSelected
                ? 2
                : 0
            : i < indexSelected
                ? 0
                : -2;
      }).map((multiply) => (fractionWidth * 0.5) * multiply).toList();
    } else {
      final baseDifference = ((_widthBase! / lengthList) * 0.5) -
          ((_widthBase! / (lengthList - 1)) * 0.5);
      final limitWidth = (_internalItems!.indexOf(_draggedItem)) *
          (_widthBase! / (lengthList - 1));
      return Iterable<int>.generate(lengthList, (i) {
        final limitSize = _widthBase! / (lengthList + 1) * (i + 1);
        if (limitWidth <= limitSize) {
          final index = lengthList - 1 - i;
          return index + index + 1;
        } else {
          return -(i + (i + 1));
        }
      }).map((multiply) => baseDifference * multiply).toList();
    }
  }

  double _positionXNavigator(double translateX) =>
      translateX - _differenceWidthContainer();

  double _differenceWidthContainer() {
    final withNavigator = MediaQuery.of(context).size.width;
    return (_widthBase != withNavigator)
        ? ((withNavigator - _widthBase!) / 2)
        : .0;
  }

  @override
  void dispose() {
    dragItemUpdateStream!.close();
    _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _widthBase = widget.width ?? MediaQuery.of(context).size.width;
    _positionIndicatorDot =
        positionItem(_widthBase, widget.keyItemSelected, _draggedItem?.keyItem);
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        _buildSettingContainer(),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: GestureDetector(
            onHorizontalDragStart: _settingVisible
                ? null
                : (dragStart) {
                    _activeLimitScroll = _buttonSettingVisible! ||
                        (dragStart.localPosition.dx -
                                _differenceWidthContainer()) >=
                            (_widthBase! * 0.75);
                  },
            onHorizontalDragEnd: _settingVisible
                ? null
                : (dragEnd) {
                    setState(() {
                      if (_isRightDirection! &&
                          _navContainerTranslate > -50.0) {
                        _buttonSettingVisible = false;
                        _navContainerTranslate = .0;
                      } else if (!_isRightDirection! &&
                          _navContainerTranslate < -50.0) {
                        _buttonSettingVisible = true;
                        _navContainerTranslate = -110.0;
                      } else {
                        _navContainerTranslate = _isRightDirection! ? -110 : .0;
                        _buttonSettingVisible = _isRightDirection;
                      }
                    });
                  },
            onHorizontalDragUpdate: _settingVisible
                ? null
                : (dragUpdate) {
                    _isRightDirection = dragUpdate.delta.dx > 0;
                    if (!_settingVisible &&
                        (_activeLimitScroll || _isRightDirection!) &&
                        _navContainerTranslate <= .0 &&
                        _navContainerTranslate >= -110.0) {
                      setState(() {
                        final result =
                            _navContainerTranslate + (dragUpdate.delta.dx / 1);
                        _navContainerTranslate = result > 0
                            ? .0
                            : result < -110.0
                                ? -110
                                : result;
                      });
                    }
                  },
            child: Stack(
              alignment: Alignment.bottomRight,
              children: <Widget>[
                Positioned(
                    right: (MediaQuery.of(context).size.width / 2) -
                        (_widthBase! * 0.5),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                      width: _widthBase! - _navContainerTranslate,
                      height: widget.height,
                      decoration: BoxDecoration(
                          borderRadius: widget.borderRadius,
                          boxShadow: widget.boxShadow),
                      child: _buildNavigator(),
                    )),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.topLeft,
          child: _buildItemDragged(),
        )
      ],
    );
  }

  Widget _buildNavigator() {
    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: Stack(
        children: <Widget>[
          Positioned(right: 0, child: _buildButtonSetting()),
          _buildNavOptionsMenu()
        ],
      ),
    );
  }

  Widget _buildNavOptionsMenu() {
    return Container(
      width: _widthBase,
      height: widget.height,
      decoration: BoxDecoration(
          color: widget.navigatorBackground,
          borderRadius: widget.borderRadius,
          boxShadow: widget.boxShadow),
      child: Container(
        padding: const EdgeInsets.only(bottom: 0.0, top: 0.0),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _buildNavigationItemList(_internalItems!)),
            AnimatedPositioned(
                duration: Duration(milliseconds: _settingVisible ? 200 : 400),
                curve: Curves.ease,
                left: _positionIndicatorDot,
                top: 0,
                bottom: 0,
                child: Opacity(
                    opacity: _visiblePointNavigator ? 1.0 : .0,
                    child: Container(
                      transform: Matrix4.translationValues(.0, 25.0, .0),
                      child: CircleAvatar(
                          radius: 2.5, backgroundColor: widget.dotColor),
                    ))),
          ],
        ),
      ),
    );
  }

  bool get _visiblePointNavigator {
    return widget.keyItemSelected != _draggedItem?.keyItem &&
        _internalItems!.indexWhere((navigationItem) =>
                navigationItem!.keyItem == widget.keyItemSelected) !=
            -1;
  }

  Widget _buildButtonSetting() {
    return Container(
      height: widget.height,
      width: 220.0,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 35.0, bottom: 15.0),
      decoration: BoxDecoration(
        color: widget.settingBackground,
        borderRadius: widget.borderRadius,
      ),
      transform: Matrix4.translationValues(-.5, .5, .0),
      child: ButtonScale(
        onTap: () => setState(() {
          if (!_settingVisible) _scrollController!.jumpTo(.0);
          _settingVisible = !_settingVisible;
        }),
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(widget.iconSetting,
              size: 30.0, color: widget.iconSettingColor),
        ),
      ),
    );
  }

  Widget _buildSettingContainer() {
    const boxConstraints = BoxConstraints(maxWidth: 130.0);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 700),
      curve: Curves.ease,
      width: _widthBase,
      height: widget.height + 275.0,
      transform: Matrix4.translationValues(
          .0, _settingVisible ? .0 : 275.0 + widget.height, .0),
      decoration: BoxDecoration(
          color: widget.settingBackground,
          borderRadius: widget.borderRadius,
          boxShadow: widget.boxShadow),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 50.0, left: 35.0, right: 35.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.settingTitleText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: widget.settingTitleColor, fontSize: 35.0),
                      ),
                      Text(widget.settingSubTitleText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: widget.settingSubTitleColor,
                              fontSize: 22.0)),
                    ],
                  ),
                ),
                ButtonScale(
                    onTap: () => setState(() => _settingVisible = false),
                    color: widget.buttonDoneColor,
                    borderRadius: BorderRadius.circular(20.0),
                    child: Container(
                      constraints: boxConstraints,
                      padding: const EdgeInsets.all(20.0),
                      child: Text(widget.doneText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: widget.textDoneColor,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700)),
                    ))
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: _draggedItem != null
                  ? const NeverScrollableScrollPhysics()
                  : null,
              padding: EdgeInsets.only(
                  bottom: widget.height,
                  left: 35.0,
                  right: _draggedItem != null ? 120.0 : 15.0),
              child: Row(children: _buildHiddenItemList(_internalHiddenItems!)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItemDragged() {
    return Visibility(
        visible: _positionDrag != Offset.zero,
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: Matrix4.translationValues(
                _positionDrag!.dx, _positionDrag!.dy, .0),
            child: HiddenMenuOption(
                iconData: _draggedItem?.icon,
                name: _draggedItem?.name,
                backgroundColor: widget.hiddenItemBackground,
                colorIcon: widget.iconHiddenColor,
                colorText: widget.textHiddenColor)));
  }

  List<DraggedMenuOption> _buildNavigationItemList(
      List<DraggableCustomizedDotBarItem?> bottomPersonalizedDotBarItemList) {
    List<DraggedMenuOption> childrenList = <DraggedMenuOption>[];
    bottomPersonalizedDotBarItemList.asMap().forEach((index, item) {
      childrenList.add(DraggedMenuOption(
        iconData: item!.icon,
        colorIcon: (item.keyItem == widget.keyItemSelected)
            ? widget.selectedColorIcon
            : widget.unSelectedColorIcon,
        onTap: () => item.onTap!(item.keyItem),
        translate:
            _translateItemList.isNotEmpty ? _translateItemList[index] : .0,
        statusDragged: _draggedItem == null
            ? StatusDragged.none
            : item.keyItem == _draggedItem!.keyItem
                ? StatusDragged.dragged
                : StatusDragged.unDragged,
        bottomItem: item,
        dragItemUpdateStream: dragItemUpdateStream,
        settingVisible: _settingVisible,
        animationItemNavigator: _animationItemNavigator,
      ));
    });
    return childrenList;
  }

  List<DraggedHiddenMenuOption> _buildHiddenItemList(
      List<DraggableCustomizedDotBarItem?> bottomPersonalizedDotBarItemList) {
    List<DraggedHiddenMenuOption> children = <DraggedHiddenMenuOption>[];
    bottomPersonalizedDotBarItemList.asMap().forEach((index, item) {
      children.add(DraggedHiddenMenuOption(
          bottomItem: item,
          iconData: item!.icon,
          name: item.name,
          dragItemUpdateStream: dragItemUpdateStream,
          statusDragged: _draggedItem == null
              ? StatusDragged.none
              : item.keyItem == _draggedItem!.keyItem
                  ? StatusDragged.dragged
                  : StatusDragged.unDragged,
          translateData: _translateHiddenItemList.isNotEmpty
              ? _translateHiddenItemList[index]
              : .0,
          blockAnimationHiddenMenuOption: _blockAnimationHiddenMenuOption,
          backgroundColor: widget.hiddenItemBackground,
          colorIcon: widget.iconHiddenColor,
          colorText: widget.textHiddenColor));
    });
    return children;
  }

  double positionItem(
      double? width, String? keyItemSelected, String? keyItemDragged) {
    final indexItemSelected = _internalItems!.indexWhere(
        (navigationItem) => navigationItem!.keyItem == keyItemSelected);
    if (indexItemSelected != -1) {
      final translate = (keyItemSelected != keyItemDragged)
          ? (_translateItemList.isNotEmpty
              ? _translateItemList[indexItemSelected]
              : .0)
          : .0;
      final numPositionBase = width! / _internalItems!.length;
      final numDifferenceBase = (numPositionBase - (numPositionBase / 2) + 2.3);
      return (numPositionBase * (indexItemSelected + 1) -
          numDifferenceBase +
          translate);
    } else {
      return .0;
    }
  }
}
