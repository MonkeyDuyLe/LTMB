import "package:flutter/material.dart";

class Mybutton extends StatelessWidget {
  const Mybutton({super.key});

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
          //Testbutton dạng đổ bóng
          SizedBox(height:  50,),
          ElevatedButton(
              onPressed: (){print("ElevatedButton");},
              child: Text("ElevatedButton",style: TextStyle(fontSize: 24),)),

          SizedBox(height:  20,),
          //Testbutton là một dạng phẳng
          TextButton(
              onPressed:(){print("TextButton");},
              child: Text("TextButton",style: TextStyle(fontSize: 24),)),

          SizedBox(height: 20),
          //Cos đường viền xung quanh
          OutlinedButton(
              onPressed: (){print("OutLinedButton");},
              child: Text("OutLinedButton",style: TextStyle(fontSize: 24),)),
          SizedBox(height: 20),
          //Dạng Icon
          IconButton(
              onPressed: (){print("IconButton");},
              icon: Icon(Icons.favorite)),

          SizedBox(height: 20),
          //Floating action Button
          //Nổi trên giao diện
          FloatingActionButton(
              onPressed: (){print("FloatingActionButton");},
            child:Icon(Icons.account_balance_outlined),
          )
        ]
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