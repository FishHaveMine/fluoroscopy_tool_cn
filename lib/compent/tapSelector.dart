import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TapSelector extends StatefulWidget {
  List Option = [];
  Function onSelectChange;
  String selected = "";

  TapSelector(
      {super.key,
      required this.Option,
      required this.onSelectChange,
      required this.selected});

  @override
  _TapSelectorState createState() => _TapSelectorState();
}

class _TapSelectorState extends State<TapSelector> {
  String selectedOption = ''; // Default selected option

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      selectedOption = widget.selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            for (var name in widget.Option) _buildOption(name),
          ],
        ));
  }

  Widget _buildOption(String option) {
    bool isSelected = selectedOption == option;

    return GestureDetector(
      onTap: () {
        widget.onSelectChange(option);
        // setState(() {
        //   selectedOption = option;
        // });
      },
      child: Container(
        width: 42,
        height: 34,
        decoration: BoxDecoration(
            color: isSelected
                ? const Color.fromRGBO(0, 128, 255, 0.4)
                : const Color.fromRGBO(194, 194, 194, 0.2)),
        child: Center(
          child: Text(
            tr(option),
            style: TextStyle(
                color: isSelected
                    ? const Color.fromRGBO(0, 128, 255, 1)
                    : const Color.fromRGBO(194, 194, 194, 1),
                fontSize: 12),
          ),
        ),
      ),
    );
  }
}
