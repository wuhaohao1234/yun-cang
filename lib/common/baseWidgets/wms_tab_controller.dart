import 'package:flutter/material.dart';
import 'package:wms/common/baseWidgets/wms_search_bar.dart';
import 'package:wms/utils/jk_over_scroll_behavior.dart';

class WMSTabController extends StatelessWidget {
  final List<String> tabTitles;
  final List<Widget> pages;
  final Color themeColor;
  final VoidCallback onTapSearchBar;
  final TabController controller;

  const WMSTabController({Key key, @required this.tabTitles, @required this.pages, this.controller,this.onTapSearchBar,this.themeColor = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: tabTitles.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: GestureDetector(
              onTap: onTapSearchBar,
              child: WMSSearchBar()),
          bottom: PreferredSize(
              child: Material(
                child: TabBar(
                  controller: controller,
                  indicatorColor: themeColor,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: themeColor,
                  unselectedLabelColor: Colors.black,
                  labelPadding: EdgeInsets.symmetric(horizontal: 0),
                  tabs: tabTitles
                      .map((title) => Tab(
                            text: title,
                          ))
                      .toList(),
                ),
              ),
              preferredSize: Size.fromHeight(48)),
        ),
        body: ScrollConfiguration(
          behavior: JKOverScrollBehavior(),
          child: TabBarView(
            children: pages,
            controller: controller,
          ),
        ),
      ),
    );
  }
}
