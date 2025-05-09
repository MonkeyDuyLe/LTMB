import "package:flutter/material.dart";

class Mygestures extends StatelessWidget {
  const Mygestures ({super.key});

  @override
  Widget build(BuildContext context) {
    // Tra ve Scaffold - widget cung cap bo cuc Material Design co ban
    // Man hinh
    return Scaffold(
      // Tiêu đề của ứng dụng
      appBar: AppBar(
        // Tieu de
        title: Text("App 02"),
        // Mau nen
        backgroundColor: Colors.yellow,
        // Do nang/ do bong cua AppBar
        elevation: 4,
        actions: [
          IconButton(
            onPressed: () {
              print("b1");
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              print("b2");
            },
            icon: Icon(Icons.abc),
          ),
          IconButton(
            onPressed: () {
              print("b3");
            },
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),

body: Center(
  child: Column(
    children: [
      SizedBox(height: 50,),
      GestureDetector(
        onTap: (){
          print("Nội dung đã được xác nhanaj");
        },
          onDoubleTap: (){
            print("Nội dung đã được xác nhanaj 2 lần");
          },
          onPanUpdate: (details){
          print('Kéo đến di chuyển đến:${details.delta}');
          },
        child: Container(
          width: 100,
          height: 100,
          color: Colors.lightBlue,
          child: Center(child:Text("touch me bit")),
        )
      )
    ],
  ),
),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("pressed");
        },
        child: const Icon(Icons.add_ic_call),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang chủ"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Tìm kiếm"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Cá nhân"),
        ],
      ),
    );
  }
}