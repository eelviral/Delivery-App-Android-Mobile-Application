import 'package:flutter/material.dart';
import 'package:sprinters/assets/styles.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class Registration3 extends StatefulWidget {
  final Function(Map<String, dynamic>)? onNewData;
  final Function()? onSubmitButtonClicked;
  final Function()? onBackButtonClicked;

  const Registration3({
    Key? key,
    this.onNewData,
    this.onSubmitButtonClicked,
    this.onBackButtonClicked,
  }) : super(key: key);

  @override
  State<Registration3> createState() => _Registration3State();
}

class _Registration3State extends State<Registration3>
    with AutomaticKeepAliveClientMixin<Registration3> {
  @override
  bool get wantKeepAlive => true;

  final List<String> items = [
    'To cover primary expenses\n (i.e. food, housing, childcare)',
    'To generate\nsupplementary income',
    'To support my\n local businesses',
    'To reduce harmful\n emissions in my community',
    'To explore new places\n and meet new people',
    'To exercise and\n get paid for it',
    'Other',
  ];
  List<String> selectedItems = [];
  int _backgroundCheckValue = 0;

  _verifyInfo() async {
    Widget okButton = TextButton(
      child: Text(
        "OK",
        style: barlowFont.copyWith(color: relaiGreen),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    AlertDialog backgroundCheckAlert = AlertDialog(
      title: Text("Submission Error",
          style: barlowFont.copyWith(fontWeight: FontWeight.bold)),
      content: Text("You must agree to the terms before proceeding.",
          style: barlowFont.copyWith(fontSize: 18.0)),
      actions: [
        okButton,
      ],
    );
    if (_backgroundCheckValue != 1) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return backgroundCheckAlert;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final selectResponseField = Center(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          hint: Align(
            alignment: AlignmentDirectional.center,
            child: Text(
              '(Please select up to 3 responses)',
              style: barlowFont.copyWith(
                fontSize: 15.0,
                color: Theme.of(context).hintColor,
              ),
            ),
          ),
          buttonDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : relaiGreen,
            ),
          ),
          buttonElevation: 2,
          dropdownMaxHeight: 200,
          dropdownPadding: null,
          dropdownDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
          ),
          dropdownElevation: 8,
          scrollbarRadius: const Radius.circular(40),
          scrollbarThickness: 6,
          scrollbarAlwaysShow: true,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              //disable default onTap to avoid closing menu when selecting an item
              enabled: false,
              child: StatefulBuilder(
                builder: (context, menuSetState) {
                  final isSelected = selectedItems.contains(item);
                  return InkWell(
                    onTap: () {
                      isSelected
                          ? selectedItems.remove(item)
                          : selectedItems.add(item);
                      //This rebuilds the StatefulWidget to update the button's text
                      setState(() {});
                      //This rebuilds the dropdownMenu Widget to update the check mark
                      menuSetState(() {});
                    },
                    child: Container(
                      height: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          isSelected
                              ? const Icon(Icons.check_box_outlined)
                              : const Icon(Icons.check_box_outline_blank),
                          const SizedBox(width: 16),
                          Text(
                            item,
                            style: barlowFont.copyWith(
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }).toList(),
          //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
          value: selectedItems.isEmpty ? null : selectedItems.last,
          onChanged: (value) {},
          buttonHeight: 40,
          buttonWidth: 250,
          itemHeight: 40,
          itemPadding: EdgeInsets.zero,
          selectedItemBuilder: (context) {
            return items.map(
              (item) {
                return Container(
                  alignment: AlignmentDirectional.center,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    selectedItems.join(', '),
                    style: const TextStyle(
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                );
              },
            ).toList();
          },
        ),
      ),
    );
    final backgroundCheckYesOrNo = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () => {setState(() => _backgroundCheckValue = 1)},
          child: SizedBox(
            height: 32,
            width: 32,
            child: Icon(
              _backgroundCheckValue == 1
                  ? Icons.check_circle
                  : Icons.check_circle_outline_outlined,
              size: 32,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text("Yes", style: barlowFont),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () => setState(() => _backgroundCheckValue = 0),
          child: SizedBox(
            height: 32,
            width: 32,
            child: Icon(
              _backgroundCheckValue == 0 ? Icons.cancel : Icons.cancel_outlined,
              size: 32,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text("No", style: barlowFont),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 100.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1.0,
        leading: TextButton.icon(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 25.0,
            color: relaiGreen,
          ),
          style: TextButton.styleFrom(
            primary: relaiGreen,
            textStyle: barlowFont.copyWith(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          label: const Text('Back'),
          onPressed: () {
            if (widget.onBackButtonClicked != null) {
              widget.onBackButtonClicked!();
            }
          },
        ),
        centerTitle: true,
        title: Text(
          'Registration',
          style: barlowFont,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'New Account',
                  style: barlowFont.copyWith(
                    fontSize: 32.0,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : relaiGreen,
                  ),
                ),
                Text(
                  '(3/3)',
                  style: barlowFont.copyWith(
                    fontSize: 15.0,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : relaiGreen,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  "Why do you want to be a sprinter?",
                  style: barlowFont.copyWith(
                      fontSize: 15.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15.0),
                selectResponseField,
                const SizedBox(height: 20.0),
                Text(
                  "Do you agree to having a third party conduct a background check "
                  "in collaboration with Relai? (This check is critical to determine"
                  " your eligibility to become a sprinter.)",
                  style: barlowFont.copyWith(fontSize: 15.0),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Align(
                  alignment: Alignment.center,
                  child: backgroundCheckYesOrNo,
                ),
                const SizedBox(
                  height: 25.0,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary:
                            Theme.of(context).brightness == Brightness.light
                                ? greyButtonColor
                                : relaiGreen,
                      ),
                      onPressed: () {
                        _verifyInfo();

                        if (widget.onNewData != null) {
                          Map<int, String> whySprinterResponses =
                              selectedItems.asMap();
                          Map<String, String> data = <String, String>{};
                          // Map<String, dynamic> data = {
                          //   'why_sprinter': whySprinterResponses
                          // };
                          whySprinterResponses.forEach((key, value) {
                            data.putIfAbsent(key.toString(), () => value);
                          });
                          widget.onNewData!(data);
                        }
                        if (widget.onSubmitButtonClicked != null) {
                          widget.onSubmitButtonClicked!();
                        }
                      },
                      icon: Icon(
                        Icons.check,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.white
                            : Colors.black,
                      ),
                      label: Text("Submit",
                          style: barlowFont.copyWith(
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.white
                                    : Colors.black,
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
