import 'package:flutter/material.dart';

import '../item/nav_item.dart';
import '../pages/activity_page.dart';
import '../pages/find_view_page.dart';
import '../pages/fragment_page.dart';
import '../pages/layout_page.dart';
import '../state/content_state.dart';

class HomeRouter extends StatefulWidget {
  const HomeRouter({super.key});

  @override
  State<HomeRouter> createState() => _HomeRouterState();
}

class _HomeRouterState extends State<HomeRouter> {
  late final PageController _pageController;
  late final ValueNotifier<int> _currentNavIndex;
  late final List<NavItem> _navList;

  @override
  void initState() {
    ContentState.clear();
    _pageController = PageController();
    _currentNavIndex = ValueNotifier(0);
    _navList = [
      NavItem(icon: "ic_activity", label: "Activity"),
      NavItem(icon: "ic_fragment", label: "Fragment"),
      NavItem(icon: "ic_layout", label: "Layout"),
      NavItem(icon: "ic_find_view", label: "FindView"),
    ];

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentNavIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          ValueListenableBuilder(
            valueListenable: _currentNavIndex,
            builder: (ctx, value, child) {
              return NavigationRail(
                selectedIndex: value,
                elevation: 2.0,
                labelType: NavigationRailLabelType.all,
                onDestinationSelected: (index) {
                  _currentNavIndex.value = index;
                  _pageController.jumpToPage(index);
                },
                leading: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Icon(
                    Icons.abc,
                    size: 48.0,
                  ),
                ),
                destinations: _navList.map((it) {
                  return NavigationRailDestination(
                    icon: icon(it.icon),
                    label: Text(it.label),
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                  );
                }).toList(),
              );
            },
          ),
          Flexible(
            child: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              itemCount: _navList.length,
              itemBuilder: (ctx, index) {
                return page(_navList[index].label);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget icon(String name) {
    switch (name) {
      case "ic_activity":
        return const Icon(Icons.fit_screen);
      case "ic_fragment":
        return const Icon(Icons.view_agenda);
      case "ic_layout":
        return const Icon(Icons.layers_outlined);
      case "ic_find_view":
        return const Icon(Icons.manage_search);
      default:
        return const Icon(Icons.info);
    }
  }

  Widget page(String name) {
    switch (name) {
      case "Activity":
        return const ActivityPage();
      case "Fragment":
        return const FragmentPage();
      case "Layout":
        return const LayoutPage();
      case "FindView":
        return const FindViewPage();
      default:
        return const SizedBox();
    }
  }
}
