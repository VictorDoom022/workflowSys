import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestUI extends StatefulWidget {

  final String pageTitle;
  final bool showSearchTextField;
  final TextEditingController? searchFieldController;
  final Function(String)? onchange;
  final Widget bodyContent;
  final List<HeaderActionButton>? actions;
  final Widget? floatingActionButton;

  const TestUI({Key? key,
    required this.pageTitle,
    required this.showSearchTextField,
    this.searchFieldController,
    this.onchange,
    required this.bodyContent,
    this.actions,
    this.floatingActionButton
  }) : super(key: key);

  @override
  _TestUIState createState() => _TestUIState();
}

class _TestUIState extends State<TestUI> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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
                    Expanded(
                      flex: 8,
                      child: Row(
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
                          Flexible(
                            child: Text(
                              widget.pageTitle,
                              style: TextStyle(
                                  fontSize: screenWidth * 0.08 > 32 ? 32 : screenWidth * 0.08,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children: [
                          if(widget.actions != null)
                            ...widget.actions!
                        ],
                      ),
                    )

                    // for(int i=0; i < actions!.length; i++) actions![i]
                  ],
                ),
              ),
            ),
            widget.showSearchTextField ? Padding(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: TextField(
                onChanged: widget.onchange,
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
      floatingActionButton: widget.floatingActionButton,
    );
  }
}

class HeaderActionButton extends StatelessWidget {

  final String buttonTitle;
  final Color buttonBackgroundColor;
  final IconData buttonIcon;
  final Color buttonIconColor;
  final VoidCallback buttonFunction;

  const HeaderActionButton({Key? key, required this.buttonTitle, required this.buttonBackgroundColor, required this.buttonIcon, required this.buttonIconColor, required this.buttonFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttonFunction,
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
        height: 30,
        constraints: BoxConstraints(
          maxWidth: 150
        ),
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
      ),
    );
  }
}

class CupertinoCustomSearchBar extends StatelessWidget {

  final Function(String) onChanged;

  const CupertinoCustomSearchBar({Key? key, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
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
    );
  }
}
