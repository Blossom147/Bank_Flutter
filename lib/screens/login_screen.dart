import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr/constant/CommonConstant.dart';
import 'package:qr/screens/signup_screen.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/customClipper.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  late String fullName = '';
  final _formKey = GlobalKey<FormState>();


   String username = '';
   String password = '';
   String firstName = '';
   String lastName = '';
   String accountNumber = '';

  bool _passwordVisible = false;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool validatePassword(String value) {
    if (value.isEmpty) return false;
    // Password must have at least 8 characters and contain at least one uppercase letter and one digit
    RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[0-9]).{8,}$');
    return regex.hasMatch(value);
  }

  bool validateUsername(String value) {
    if (value.isEmpty) return false;
    // Username must have at least 5 characters and at most 15 characters
    RegExp regex = RegExp(r'^.{5,15}$');
    return regex.hasMatch(value);
  }

  // Hàm gửi request login
  Future<void> sendLoginRequest(String username, String password) async {

    // URL của API login
    final url = Uri.parse(CommonConstant.apiUrlSendLoginReq);



    try {
      // Gửi request POST với body chứa thông tin tài khoản và mật khẩu
      debugPrint('send: $username');

      final response = await http.post(
        url,
        body: {
          'username': username,
          'password': password
        },
        headers: {
          'Authorization': 'Basic ' + base64.encode(utf8.encode('$username:$password')),
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      // Kiểm tra response status code
      if (response.statusCode == 200) {
        final userData = await getDataUser(username,password);
        accountNumber = userData['accountNumber'];
        // fullName = userData['firstName'] + " " + userData['lastName'];


        final prefs = await SharedPreferences.getInstance();
        prefs.setString('jwt', base64.encode(utf8.encode('$username:$password')));
        prefs.setString('userName', username);
        prefs.setString('fullName', userData['firstName'] + " " + userData['lastName']);
        prefs.setString('accountNumber', accountNumber);

        debugPrint('send: $prefs');
        // Đăng nhập thành công
        print(response.body);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
            ),
          ),
        );

      } else {
        // Đăng nhập thất bại
        // Xử lý thông báo lỗi ở đây
      }
    } catch (e) {

      debugPrint('error: $e ');
      // Xử lý exception ở đây
    }
  }

  Future<Map<String, dynamic>> getDataUser(String username,String password) async {

    // URL của API login

    final url = Uri.parse(CommonConstant.apiUrlGetDataUser+'$username');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      firstName = jsonResponse['firstName'];
      lastName = jsonResponse['lastName'];
      accountNumber = jsonResponse['accountNumber'];
      debugPrint('send: $firstName, $lastName, $accountNumber');
      return {'firstName': firstName, 'lastName': lastName, 'accountNumber': accountNumber};
    } else {
      throw Exception('Failed to load data');
    }
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
          height: height,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: -MediaQuery.of(context).size.height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: Container(
                    child: Transform.rotate(
                      angle: -pi / 3.5,
                      child: ClipPath(
                        clipper: ClipPainter(),
                        child: Container(
                          height: MediaQuery.of(context).size.height * .5,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xffE6E6E6),
                                Color(0xff14279B),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: 'KebHana',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff14279B),
                            ),
                            children: [
                              TextSpan(
                                text: 'Bank',
                                style: TextStyle(color: Colors.black, fontSize: 30),
                              ),
                            ]),
                      ),
                      SizedBox(height: 50),
                      Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Tài khoản",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: _usernameController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: Color(0xfff3f3f4),
                                    filled: true,
                                    labelText: 'Tài khoản',
                                    labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                  validator: (value) {
                                    if (!validateUsername(value!)) {
                                      return 'Vui lòng nhập tài khoản đúng định dạng';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    username = value!;
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Mật khẩu",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: !_passwordVisible,
                              decoration: InputDecoration(
                                labelText: 'Mật khẩu',
                                border: InputBorder.none,
                                fillColor: Color(0xfff3f3f4),
                                filled: true,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (!validatePassword(value!)) {
                                  return 'Mật khẩu không đúng';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                password = value!;
                              },
                            )
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                          child: Text('Đăng nhập'),
                          onPressed: (){
                            if (_formKey.currentState!.validate()) {
                              // Perform login logic here

                              final username = _usernameController.text;
                              final password = _passwordController.text;
                              sendLoginRequest(username, password);
                            }else{
                            }
                          }
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.centerRight,
                        child: Text('Quên mật khẩu ?',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                      ),
                      SizedBox(height: height * .055),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpScreen()));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          padding: EdgeInsets.all(15),
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Bạn chưa có tài khoản ?',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Đăng ký',
                                style: TextStyle(
                                    color: Color(0xff14279B),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
    ),
                ),
              ),
              Positioned(
                top: 40,
                left: 0,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
                          child:
                          Icon(Icons.keyboard_arrow_left, color: Colors.black),
                        ),
                        Text('Quay lại',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
