import 'package:flutter/material.dart';

class AppBarSearchStyle {
  FocusNode? focusNode;
  String? hintText;
  void Function(String)? onChanged;
  void Function(String)? onSubmitted;

  AppBarSearchStyle(
      {this.focusNode, this.hintText, this.onChanged, this.onSubmitted});
}

class LeadingStyle {
  IconData icon;
  void Function()? onPressed;

  LeadingStyle({required this.icon, this.onPressed});
}

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? title;
  final bool searchIcon;
  final AppBarSearchStyle appBarSearchStyle;
  final bool transparentBackground;
  final LeadingStyle? leadingStyle;
  final TextEditingController searchController;

  CustomAppBar(
      {Key? key,
      this.title,
      this.searchIcon = false,
      AppBarSearchStyle? appBarSearchStyle,
      this.transparentBackground = false,
      this.leadingStyle,
      TextEditingController? searchController})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        this.appBarSearchStyle = appBarSearchStyle ?? AppBarSearchStyle(),
        this.searchController = searchController ?? TextEditingController(),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  late TextEditingController _searchFieldController;

  List<Widget> actionButtons = [];

  ThemeData? theme;

  bool searchMode = false;
  bool firstBuild = true;

  @override
  void initState() {
    super.initState();
    _searchFieldController = widget.searchController;
    _searchFieldController.addListener(() {
      // print(_searchFieldController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);

    if (firstBuild) {
      if (widget.searchIcon) {
        actionButtons.add(_buildIcon(Icons.search, () {
          setState(() {
            searchMode = !searchMode;
          });
        }));
      }

      actionButtons.add(_buildIcon(Icons.notifications_outlined, () {
        var navi = Navigator.of(context);
        navi.pop();
        navi.pushNamed('/notifications');
      }));

      firstBuild = false;
    }

    return searchMode
        ? AppBar(
            titleSpacing: 0,
            title: TextField(
              controller: _searchFieldController,
              cursorColor: widget.transparentBackground
                  ? Colors.white
                  : theme!.textTheme.bodyMedium?.color,
              style: theme!.textTheme.bodyLarge?.copyWith(
                  color: widget.transparentBackground ? Colors.white : null),
              focusNode: widget.appBarSearchStyle.focusNode,
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: theme!.colorScheme.onSurfaceVariant, width: 1.0),
                    borderRadius: BorderRadius.circular(1000)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: theme!.colorScheme.onSurfaceVariant, width: 1.0),
                    borderRadius: BorderRadius.circular(1000)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: theme!.colorScheme.onSurfaceVariant, width: 1.0),
                    borderRadius: BorderRadius.circular(1000)),
                filled: widget.transparentBackground,
                fillColor: Color.fromRGBO(0, 0, 0, 0.6),
                hintText: widget.appBarSearchStyle.hintText,
                hintStyle: theme!.textTheme.bodyLarge?.copyWith(
                    color: widget.transparentBackground ? Colors.white : null),
              ),
              onChanged: widget.appBarSearchStyle.onChanged,
              onSubmitted: widget.appBarSearchStyle.onSubmitted,
              autofocus: true,
            ),
            automaticallyImplyLeading: false,
            leading: _buildIcon(Icons.arrow_back, () {
              setState(() {
                searchMode = !searchMode;
              });
            }),
            backgroundColor: widget.transparentBackground
                ? Colors.transparent
                : theme!.colorScheme.surface,
            foregroundColor: theme!.colorScheme.onSurface,
            elevation: 0,
          )
        : AppBar(
            title: Text(widget.title ?? ""),
            automaticallyImplyLeading: false,
            backgroundColor: widget.transparentBackground
                ? Colors.transparent
                : theme!.colorScheme.surface,
            foregroundColor: theme!.colorScheme.onSurface,
            actions: actionButtons,
            elevation: 0,
            leading: widget.leadingStyle != null
                ? _buildIcon(
                    widget.leadingStyle!.icon, widget.leadingStyle!.onPressed)
                : null,
          );
  }

  Widget _buildIcon(IconData icon, void Function()? onPressed) {
    Widget iconB = IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      padding: EdgeInsets.all(0),
      color: widget.transparentBackground ? Colors.white : null,
    );

    if (widget.transparentBackground) {
      return Row(
        children: [
          SizedBox(width: 5),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(0, 0, 0, 0.6),
              borderRadius: BorderRadius.all(Radius.circular(50.0)),
              border: Border.all(
                color: Colors.white,
                width: 1.0,
              ),
            ),
            child: Center(child: iconB),
          ),
          SizedBox(width: 5)
        ],
      );
    }
    return iconB;
  }
}
