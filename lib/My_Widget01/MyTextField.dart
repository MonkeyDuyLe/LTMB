import "package:flutter/material.dart";

class Mytextfield extends StatelessWidget {
  const Mytextfield({super.key});

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

      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 50,),

                TextField(
                  decoration: InputDecoration(
                    labelText: "FullName",
                    hintText: "Nhập tên của bạn",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 50,),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: " ...@gmail.com",
                    helperText: "Nhập Email",
                    prefixIcon: Icon(Icons.email),
                    suffixIcon: Icon(Icons.clear),

                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),

                    filled: true,
                    fillColor: Colors.lightBlue

                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 50,),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Số Phone",
                    hintText: "SĐT m đâu",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,

                ),
                SizedBox(height: 30,),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Ngày Sinh",
                    hintText: "Ngyaf sinh của m đau",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                SizedBox(height: 30,),
                TextField(
                  obscureText: true,
                  obscuringCharacter:'❤',
                  decoration: InputDecoration(
                    labelText: "Mật Khẩu",

                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                SizedBox(height: 30,),
                TextField(
                  onChanged: (value){
                    print("Đăng nhập:$value");
                  },
                  onSubmitted: (value){
                    print("Đã hoàn thành nội dung: $value");
                  },
                  obscureText: false  ,
                  obscuringCharacter:'❤',
                  decoration: InputDecoration(

                    labelText: "Câu hỏi Sign",

                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.datetime,
                )
              ],
            ),
          )
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