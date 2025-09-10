import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/config/config.dart';
import 'package:my_first_app/model/request/customer_register_post_req.dart';
import 'package:my_first_app/model/request/customers_login_post_req.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  var fullnameCtl = TextEditingController();
  var phoneCtl = TextEditingController();
  var emailCtl = TextEditingController();
  var passCtl = TextEditingController();
  var confirmpassCtl = TextEditingController();

  String url = '';

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ลงทะเบียนสมาชิกใหม่')),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [Text('ชื่อ-นามสกุล')],
                    ),
                    TextField(
                      controller: fullnameCtl,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [Text('หมายเลขโทรศัพท์')],
                    ),
                    TextField(
                      controller: phoneCtl,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [Text('อีเมล์')],
                    ),
                    TextField(
                      controller: emailCtl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [Text('รหัสผ่าน')],
                    ),
                    TextField(
                      controller: passCtl,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [Text('ยืนยันรหัสผ่าน')],
                    ),
                    TextField(
                      controller: confirmpassCtl,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton(onPressed: register, child: Text('สมัครสมาชิก')),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('หากมีบัญชีอยู่แล้ว?'),
                  TextButton(onPressed: back, child: Text('เข้าสู่ระบบ')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void register() {
    CustomerRegisterPostRequest request = CustomerRegisterPostRequest(
      fullname: fullnameCtl.text,
      phone: phoneCtl.text,
      email: emailCtl.text,
      image: "",
      password: passCtl.text,
    );

    http
        .post(
          Uri.parse("$url/customers"),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: jsonEncode(request),
        )
        .catchError((error) {
          log('Error $error');
        });
    back();
  }

  void back() {
    Navigator.pop(context);
  }
}
