import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:login_demo_for_finlite/models/LoginResponse.dart';
import 'package:login_demo_for_finlite/provider/NoValueNotifier.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool passwordVisible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  var resMsg = "";
  var resColor = Colors.red;
  @override
  Widget build(BuildContext context) {
    // resMsg = "";
    // Provider.of<ProgressNotifier>(context, listen: false).show(false);
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      // resizeToAvoidBottomInset: true,
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 1.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('images/login_bg.jpg'),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.6), BlendMode.dstATop),
            )),
            // child: Image.asset(
            //   'images/login_bg.jpg',
            //   height: MediaQuery.of(context).size.height / 1.5,
            //   width: MediaQuery.of(context).size.width,
            //   fit: BoxFit.cover,
            // ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: 170),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 20.0,
                          ),
                        ],
                      ),
                      margin: EdgeInsets.all(15),
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white70, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadowColor: Colors.grey,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Form(
                            key: _formKey,
                            autovalidate: _autoValidate,
                            child: Column(
                              children: [
                                Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Color(0xffC62827),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  controller: _emailController,
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context).nextFocus();
                                  },
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (s) {
                                    if (s.isEmpty)
                                      return "Please enter email";
                                    else if (!isValidEmail(s))
                                      return 'Invalid email';
                                    else
                                      return null;
                                  },
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                      labelText: "Email Address"),
                                ),
                                SizedBox(height: 20),
                                Consumer<NoValueNotifier>(builder:
                                    (BuildContext context,
                                        NoValueNotifier value, Widget child) {
                                  return TextFormField(
                                    controller: _passwordController,
                                    obscureText: passwordVisible,
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.text,
                                    validator: (s) {
                                      if (s.isEmpty)
                                        return "Please enter password";
                                      else
                                        return null;
                                    },
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                        ),
                                        // suffixIcon: Icon(Icons.visibility),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            passwordVisible
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                          ),
                                          color: Theme.of(context).primaryColor,
                                          onPressed: () {
                                            // setState(() {

                                            passwordVisible = !passwordVisible;
                                            Provider.of<NoValueNotifier>(
                                                    context,
                                                    listen: false)
                                                .notify();
                                            // });
                                          },
                                        ),
                                        labelText: "Password"),
                                  );
                                }),
                                SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text('Forgot Password ?'),
                                ),
                                SizedBox(height: 30),
                                Consumer<ProgressNotifier>(
                                  builder: (BuildContext context,
                                      ProgressNotifier progress, Widget child) {
                                    if (!progress.isShowing) {
                                      return ButtonTheme(
                                        height: 48,
                                        minWidth:
                                            MediaQuery.of(context).size.width,
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              side: BorderSide(
                                                  color: Color(0xFFC1E7E4))),
                                          color: Color(0xffC62827),
                                          child: Text(
                                            "Login",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onPressed: () {
                                            isValid();
                                          },
                                        ),
                                      );
                                    } else {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }
                                  },
                                ),
                                SizedBox(height: 10),
                                Consumer<NoValueNotifier>(
                                  builder: (BuildContext context,
                                      NoValueNotifier value, Widget child) {
                                    return Text(resMsg,
                                        style: TextStyle(color: resColor));
                                  },
                                ),
                                SizedBox(height: 30),
                                Text('Don\'t have an account ?'),
                                Text('CREATE NOW',
                                    style: TextStyle(
                                        color: Color(0xffC62827),
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void isValid() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      resMsg = "";
      resColor = Colors.green;
      Provider.of<NoValueNotifier>(context, listen: false).notify();

      Provider.of<ProgressNotifier>(context, listen: false).show(true);

      callLoginAPI();
    } else {
      Provider.of<ProgressNotifier>(context, listen: false).show(false);
      setState(() {
        _autoValidate = true;
      });
    }
  }

  bool isValidEmail(String s) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(s);
  }

  Future callLoginAPI() async {
    String uri =
        "https://osiamart.com/index.php?route=api/android/customer/login";
    var map = Map<String, String>();
    map['email'] = _emailController.text;
    map['password'] = _passwordController.text;
    map['devicetoken'] = "123456";
    map['devicetype'] = "android";

    var request = http.MultipartRequest("POST", Uri.parse(uri))
      ..fields.addAll(map);

    var response = await request.send();
    var res = await http.Response.fromStream(response);

    var result = json.decode(res.body);
    LoginResponse loginResponse = LoginResponse.fromJson(result);
    resMsg = loginResponse.message;
    Log.displayResponse(payload: map.toString(), requestType: 'POST', res: res);

    if (loginResponse.success)
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pushNamed("home").then((value) {
          resMsg = "";
          Provider.of<NoValueNotifier>(context, listen: false).notify();
        });
      });
    else {
      resColor = Colors.red;
    }
    Provider.of<NoValueNotifier>(context, listen: false).notify();
    Provider.of<ProgressNotifier>(context, listen: false).show(false);
//    subSiteDetails = SubSiteDetailsModel.fromJson(result);
  }
}

class Log {
  Log.displayResponse({payload, http.Response res, String requestType}) {
    if (payload != null) print("payload : " + payload);
    if (res != null) {
//      print('headers : '+ res.headers.toString());
      print("url : " + res.request.url.toString());
      if (requestType != null) {
        print("requestType : " + requestType);
      }
      print("status code : " + res.statusCode.toString());
      print("response : " + res.body.toString());
    } else {
      print("Log displayResponse is : " + res.toString());
    }
  }
}
