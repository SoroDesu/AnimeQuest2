//Flutter stuff
import 'package:flutter/material.dart';
//Own Stuff
import 'package:aquest/screens/questlist.dart';
import 'package:aquest/screens/eventlist.dart';
import 'package:aquest/screens/characterlist.dart';

class HomeApp extends StatefulWidget {
  const HomeApp({Key? key}) : super(key: key);

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  int currentIndex = 0;
  final PageController controller = PageController();




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: PageView(
        allowImplicitScrolling: true,
        controller: controller,
        onPageChanged: (pageIndex) =>
            setState(() => currentIndex = pageIndex),
        children: const <Widget>[
          CharacterSheet(),
          QuestList(),
          EventList(),
        ]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() => currentIndex = index);
          controller.animateToPage(index,
              duration: const Duration(milliseconds: 500), curve: Curves.ease);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Character",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.my_library_books_sharp),
            label: "Quests",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Events",
          ),
        ],
      ),
    );
  }
}