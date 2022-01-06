import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestUI extends StatefulWidget {

  final String pageTitle;
  final bool showSearchTextField;
  final TextEditingController? searchFieldController;
  final Widget bodyContent;
  final List<HeaderActionButton>? actions;

  const TestUI({Key? key,
    required this.pageTitle,
    required this.showSearchTextField,
    this.searchFieldController,
    required this.bodyContent,
    this.actions
  }) : super(key: key);

  @override
  _TestUIState createState() => _TestUIState();
}

class _TestUIState extends State<TestUI> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16,right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                              Icons.chevron_left,
                              size: 30,
                          ),
                          onPressed: (){
                            Navigator.of(context).pop();
                          }
                        ),
                        Text(
                          widget.pageTitle,
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                    ...widget.actions!
                    // for(int i=0; i < actions!.length; i++) actions![i]
                  ],
                ),
              ),
            ),
            widget.showSearchTextField ? Padding(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: TextField(
                controller: widget.searchFieldController,
                decoration: InputDecoration(
                  hintText: "Search ...",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey.shade100
                      )
                  ),
                ),
              ),
            ) : Container(),
            Padding(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: widget.bodyContent,
            )
          ],
        ),
      ),
    );
  }
}

class HeaderActionButton extends StatelessWidget {

  final String buttonTitle;
  final Color buttonBackgroundColor;
  final IconData buttonIcon;
  final Color buttonIconColor;

  const HeaderActionButton({Key? key, required this.buttonTitle, required this.buttonBackgroundColor, required this.buttonIcon, required this.buttonIconColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: buttonBackgroundColor,
      ),
      child: Row(
        children: [
          Icon(
              buttonIcon,
              color: buttonIconColor,
              size: 20
          ),
          SizedBox(width: 2,),
          Text(
            buttonTitle,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }
}

