import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:sprinters/assets/data.dart';
import 'package:sprinters/assets/styles.dart';

class SearchableDropdown extends StatefulWidget {
  final String? text;
  final Function(String)? onTextChange;

  const SearchableDropdown({
    Key? key,
    this.text,
    this.onTextChange,
  }) : super(key: key);

  @override
  State<SearchableDropdown> createState() => _SearchableDropdownState();
}

class _SearchableDropdownState extends State<SearchableDropdown> {
  final List<String> items = stateAbbreviations;

  String? selectedValue;
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Center(
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            isExpanded: true,
            hint: Text(
              'State',
              style: barlowFont.copyWith(
                color: Theme.of(context).hintColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            items: items
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item, style: barlowFont),
                    ))
                .toList(),
            value: widget.text ?? selectedValue,
            onChanged: (value) {
              setState(() {
                selectedValue = value as String;
                if (widget.onTextChange != null) {
                  widget.onTextChange!(selectedValue!);
                }
              });
            },
            // Styling
            buttonHeight: 55,
            buttonWidth: 160,
            buttonPadding: const EdgeInsets.only(left: 18),
            buttonDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32.0),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : relaiGreen,
              ),
            ),
            // buttonElevation: 2,
            itemHeight: 40,
            // itemPadding: const EdgeInsets.only(left: 14, right: 14),
            dropdownMaxHeight: 200,
            dropdownWidth: 200,
            dropdownPadding: null,
            dropdownDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
            ),
            dropdownElevation: 8,
            scrollbarRadius: const Radius.circular(40),
            scrollbarThickness: 6,
            scrollbarAlwaysShow: true,
            offset: const Offset(-20, 0),

            searchController: textEditingController,
            searchInnerWidget: Padding(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 4,
                right: 8,
                left: 8,
              ),
              child: TextFormField(
                controller: textEditingController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  hintText: 'Search State...',
                  hintStyle: barlowFont,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            searchMatchFn: (item, searchValue) {
              return (item.value.toString().contains(searchValue));
            },
            //This to clear the search value when you close the menu
            onMenuStateChange: (isOpen) {
              if (!isOpen) {
                textEditingController.clear();
              }
            },
          ),
        ),
      ),
    );
  }
}
