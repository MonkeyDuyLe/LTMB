import "package:flutter/material.dart";

class MyScaffold extends StatelessWidget {
  const MyScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    //Trả về Scarffold - Widget cung cấp b cục material Design co ban
    //Man hinh
    return Scaffold(
      //Tieu De cua ung dunh
      appBar: AppBar(
        title: Text("App 02"),
      ),
      backgroundColor: Colors.lightBlue,
      body: Center(child: Text("Nihao ma"),),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Pressed");
        },
        child: const Icon(Icons.add_ic_call),
      ),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang Chur"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Timf Kiems"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Ca Nhan"),
      ]),
    );
  }
}