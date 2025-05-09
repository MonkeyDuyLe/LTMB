import "package:flutter/material.dart";

class MyText extends StatelessWidget {
  const MyText({super.key});

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
              onPressed: () {print("b1");}
      ,icon: Icon(Icons.search),
    ),
          IconButton(
            onPressed: () {print("b2");}
            ,icon: Icon(Icons.abc),
          ),
          IconButton(
            onPressed: () {print("b3");}
            ,icon: Icon(Icons.more_vert),
          ),
  ],
      ),

      body: Center(child: Column(
        children: [
          const SizedBox(height: 50,),
          //Text Cowr banr
          const Text("MonKey nEf"),
          const SizedBox(height: 50,),
          
          const Text(
            "caonima flutter ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
          ),
          const SizedBox(height: 20,),

          const Text(
            "caonima flutter cos nghiax la xin chao cac banj nhoas ",
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      )),

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