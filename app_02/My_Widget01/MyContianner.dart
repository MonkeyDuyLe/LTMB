import "package:flutter/material.dart";

class Mycontianner extends StatelessWidget {
  const Mycontianner({super.key});

  @override
  Widget build(BuildContext context) {
    //Trả về Scarffold - Widget cung cấp b cục material Design co ban
    //Man hinh
    return Scaffold(
      //Tieu De cua ung dunh
      appBar: AppBar(
        title: Text("App 02"),
        //Mauf Neenf
        backgroundColor: Colors.lightBlue,
        //Do Nang cua bongs
        elevation: 4,
        actions: [
          IconButton(
            onPressed: () {
              print("b1");
            }
            , icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              print("b2");
            }
            , icon: Icon(Icons.abc),
          ),
          IconButton(
            onPressed: () {
              print("b3");
            }
            , icon: Icon(Icons.more_vert),
          ),
        ],
      ),

      body: Center(
        child: Container(
          width: 200,
          height: 200,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ]
        ),


        child: Align(
            alignment: Alignment.center,
            child: const Text(
              "Monkey nè ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            )
        ),
      ),

    ),

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