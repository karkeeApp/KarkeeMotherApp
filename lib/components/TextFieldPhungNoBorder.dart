import 'package:flutter/material.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:carkee/config/colors.dart';

class TextFieldPhungNoBorder extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool notAllowEmpty;
  final bool isPassword;
  final bool requiredEmail;
  final String hintText;
  final TextInputType keyboardType;
  final Function(String) onChange;
  final Function() updateChange;
  const TextFieldPhungNoBorder(
      {Key key,
      @required this.controller,
      this.labelText = "labelText",
      this.hintText = "hintText",
      this.notAllowEmpty = false,
      this.requiredEmail = false,
      this.isPassword = false,
      this.keyboardType = TextInputType.text,
      this.onChange, this.updateChange})
      : super(key: key);
  @override
  _TextFieldPhungNoBorderState createState() => _TextFieldPhungNoBorderState();
}

class _TextFieldPhungNoBorderState extends State<TextFieldPhungNoBorder> {
  FocusNode _focus = new FocusNode();
  String _text = "";

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {
        _text = widget.controller.text;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // _focus.dispose();//dont need
    // widget.controller.dispose();//dont need
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: TextFormField(
        focusNode: _focus,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.isPassword,
        autocorrect: false,
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Config.secondColor),
          ),
          // focusedBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: Config.primaryColor, width: 5.0),
          // ),
          // enabledBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: Config.primaryColor, width: 5.0),
          // ),
          labelText: widget.labelText,
          hintText: widget.hintText,
          suffixIcon: (_text.isNotEmpty && _focus.hasFocus)
              // suffixIcon: (_text.isNotEmpty)
              ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      widget.controller.clear();
                    });
                  },
                )
              : null,
        ),
        validator: (value) {
          if (widget.notAllowEmpty && value.isEmpty) {
            return 'Required';
          }
          if (widget.requiredEmail && !Session.shared.isValidEmail(value)) {
            return 'Invalid email';
          }
          return null;
        },
        onChanged: (value) {
          print(value);
          if (widget.updateChange != null) widget.updateChange();
          // widget.updateChange();
          // if (widget.onChange != null) widget.onChange(value);

        },
      ),
    );
  }
}
