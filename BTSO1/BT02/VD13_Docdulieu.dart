import 'dart:io';
void main()
//Nhập tên người dùng
{
  stdout.write('Nhập tên m vào :');
String name= stdin.readLineSync()!;

 // Nhập tuổi ng dùng
    stdout.write('Nhập tuổi m vào :');
int age= int.parse(stdin.readLineSync()!);

print("Nihaoma: $name ,Your age :$age");

}