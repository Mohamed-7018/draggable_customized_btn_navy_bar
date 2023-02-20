part of draggable_customized_btn_navy_bar;

class MenuOption extends StatelessWidget {
  final IconData? _iconData;
  final Color? _colorIcon;
  final GestureTapCallback? _onTap;
  final bool _enable;

  const MenuOption(this._iconData, this._colorIcon, this._onTap, this._enable,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return ButtonScale(
        activeOpacity: true,
        onTap: _enable
            ? () {
                _onTap!();
              }
            : null,
        child: Container(
          color: Colors.transparent,
          alignment: Alignment.center,
          child: Icon(_iconData, color: _colorIcon, size: 30.0),
        ));
  }
}
