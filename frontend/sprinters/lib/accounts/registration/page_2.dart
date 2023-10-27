import 'package:flutter/material.dart';
import 'package:sprinters/assets/styles.dart';
import 'package:sprinters/widgets/accounts/login_widgets.dart';
import 'package:sprinters/widgets/accounts/registration_widgets.dart';

class Registration2 extends StatefulWidget {
  final Function(Map<String, dynamic>)? onNewData;
  final Function()? onNextButtonClicked;
  final Function()? onBackButtonClicked;

  const Registration2({
    Key? key,
    this.onNewData,
    this.onNextButtonClicked,
    this.onBackButtonClicked,
  }) : super(key: key);

  @override
  State<Registration2> createState() => _Registration2State();
}

class _Registration2State extends State<Registration2>
    with AutomaticKeepAliveClientMixin<Registration2> {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _homeAddressController = TextEditingController();
  final TextEditingController _homeUnitController = TextEditingController();
  final TextEditingController _homeCityController = TextEditingController();
  String? _state1Text;
  final TextEditingController _dateOfBirth1Controller = TextEditingController();

  final TextEditingController _mailingAddressController =
      TextEditingController();
  final TextEditingController _mailingUnitController = TextEditingController();
  final TextEditingController _mailingCityController = TextEditingController();
  String? _state2Text;
  final TextEditingController _dateOfBirth2Controller = TextEditingController();

  int _value = 0;

  void _copyAddressInfo() {
    _mailingAddressController.text = _homeAddressController.text;
    _mailingUnitController.text = _homeUnitController.text;
    _mailingCityController.text = _homeCityController.text;
    _state2Text = _state1Text;
    _dateOfBirth2Controller.text = _dateOfBirth1Controller.text;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final homeAddressField = LoginTextField(
      controller: _homeAddressController,
      hintText: "Home Address",
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
      width: MediaQuery.of(context).size.width * 0.55,
    );
    final homeUnitField = Flexible(
      child: LoginTextField(
        controller: _homeUnitController,
        hintText: "Unit #",
      ),
    );
    final homeCityField = LoginTextField(
      controller: _homeCityController,
      hintText: "City",
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
      width: MediaQuery.of(context).size.width * 0.55,
    );
    final SearchableDropdown homeStateField = SearchableDropdown(
      onTextChange: (newText) {
        setState(() {
          _state1Text = newText;
        });
      },
    );
    final mailingAddressField = LoginTextField(
      controller: _mailingAddressController,
      hintText: "Mailing Address",
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
      width: MediaQuery.of(context).size.width * 0.55,
    );
    final mailingUnitField = Flexible(
      child: LoginTextField(
        controller: _mailingUnitController,
        hintText: "Unit #",
      ),
    );
    final mailingCityField = LoginTextField(
      controller: _mailingCityController,
      hintText: "City",
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
      width: MediaQuery.of(context).size.width * 0.55,
    );
    SearchableDropdown state2Field = SearchableDropdown(
      text: _state2Text,
      onTextChange: (newText) {
        setState(() {
          _state2Text = newText;
        });
      },
    );
    final mailingHomeYesOrNo = Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => {_copyAddressInfo(), setState(() => _value = 1)},
            child: SizedBox(
              height: 32,
              width: 32,
              child: Icon(
                _value == 1
                    ? Icons.check_circle
                    : Icons.check_circle_outline_outlined,
                size: 32,
              ),
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () => setState(() => _value = 0),
            child: SizedBox(
              height: 32,
              width: 32,
              child: Icon(
                _value == 0 ? Icons.cancel : Icons.cancel_outlined,
                size: 32,
              ),
            ),
          ),
        ],
      ),
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
                  '(2/3)',
                  style: barlowFont.copyWith(
                    fontSize: 15.0,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : relaiGreen,
                  ),
                ),
                const SizedBox(height: 10.0),
                Row(children: [homeAddressField, homeUnitField]),
                const SizedBox(height: 20.0),
                Row(children: [homeCityField, homeStateField]),
                const SizedBox(height: 20.0),
                LoginTextField(
                    controller: _dateOfBirth1Controller,
                    hintText: "Date of Birth"),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Flexible(
                        child: Text(
                      "Is your Mailing Address the same as your Home Address?",
                      style: barlowFont.copyWith(fontSize: 15.0),
                    )),
                    mailingHomeYesOrNo
                  ],
                ),
                const SizedBox(height: 15.0),
                Row(children: [mailingAddressField, mailingUnitField]),
                const SizedBox(height: 20.0),
                Row(
                  children: [mailingCityField, state2Field],
                ),
                const SizedBox(height: 20.0),
                LoginTextField(
                    controller: _dateOfBirth2Controller,
                    hintText: "Date of Birth"),
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
                        if (widget.onNewData != null) {
                          Map<String, dynamic> data = {
                            'home_address': _homeAddressController.text,
                            'home_state': _state1Text ?? '',
                            'home_unit': _homeUnitController.text,
                            'home_city': _homeCityController.text,
                            'date_of_birth': _dateOfBirth1Controller.text,
                            'mailing_address': _mailingAddressController.text,
                            'mailing_unit': _mailingUnitController.text,
                            'mailing_city': _mailingCityController.text,
                            'mailing_state': _state2Text ?? '',
                          };
                          widget.onNewData!(data);
                        }
                        if (widget.onNextButtonClicked != null) {
                          widget.onNextButtonClicked!();
                        }
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.white
                            : Colors.black,
                      ),
                      label: Text(
                        "Next",
                        style: barlowFont.copyWith(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
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
