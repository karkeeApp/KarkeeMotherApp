import 'package:flutter/material.dart';

import 'debouncer.dart';

class SearchBarPhung extends StatefulWidget {
  final Function(String) startSearching;
  final Function reload;
  final TextEditingController searchTextController;
  const SearchBarPhung({
    Key key,
    @required this.startSearching,
    @required this.reload,
    this.searchTextController,
  }) : super(key: key);

  @override
  _SearchBarPhungState createState() => _SearchBarPhungState();
}

class _SearchBarPhungState extends State<SearchBarPhung> {
  var searchTextController = TextEditingController();
  var searchTextString = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.searchTextController != null) {
      searchTextController = widget.searchTextController;
    }
  }

  final Debouncer onSearchDebouncer = Debouncer(delay: Duration(seconds: 1));
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                  offset: Offset(1,
                      1), //(0,-12) Bóng lên,(0,12) bóng xuống,, tuong tự cho trái phải
                  blurRadius: 4,
                  color: Colors.black12)
            ]),
        child: TextField(
          controller: searchTextController,
          onChanged: (value) {
            setState(() {
              searchTextString = searchTextController.text;
            });
            onSearchDebouncer.debounce(() {
              // print(
              //     "controller.searchTextController.text ${widget.controller.searchTextController.text}");
              widget.startSearching(searchTextString);
            });
          },
          decoration: InputDecoration(
            labelText: 'Search',
            hintText: 'Search',
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            filled: true,
            fillColor: Colors.white, //Color.fromARGB(255, 242, 242, 242),
            prefixIcon: Icon(Icons.search_sharp),
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0, color: Colors.black26),
              borderRadius: BorderRadius.circular(30),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0, color: Colors.black26),
              borderRadius: BorderRadius.circular(30),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            suffixIcon: searchTextString != ""
                ? IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      print("clear text");
                      searchTextController.text = '';
                      // print("${widget.controller.searchTextString.value}");
                      setState(() {
                        searchTextString = '';
                      });

                      // print("${widget.controller.searchTextString.value}");
                      widget.reload();
                    },
                  )
                : SizedBox(),
          ),
        ));
  }
}
