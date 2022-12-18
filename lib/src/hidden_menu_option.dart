part of draggable_customized_btn_navy_bar;

class HiddenMenuOption extends StatelessWidget {
  final IconData? iconData;
  final String? name;
  final Color backgroundColor;
  final Color colorIcon;
  final Color colorText;

  const HiddenMenuOption(
      {Key? key,
      required this.iconData,
      required this.name,
      required this.backgroundColor,
      required this.colorIcon,
      required this.colorText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const radius2 = Radius.circular(20.0);
    return Container(
      width: 85.0,
      height: 85.0,
      margin: const EdgeInsets.only(right: 20.0),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(20.0)),
      child: DottedBorder(
        color: const Color(0x44000000),
        radius: radius2,
        strokeWidth: 1,
        dashPattern: const [3, 2],
        borderType: BorderType.RRect,
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(iconData, size: 30.0, color: colorIcon),
              const SizedBox(height: 5.0),
              Text(name!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: colorText,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700))
            ],
          ),
        ),
      ),
    );
  }
}
