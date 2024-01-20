import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sucden_smart_factory/database/app_database.dart';
import 'package:sucden_smart_factory/models/model_user.dart';
import 'package:sucden_smart_factory/models/userslist_info.dart';
import 'package:sucden_smart_factory/shared_widgets/buttons.dart';
import 'package:sucden_smart_factory/shared_widgets/form_text_field.dart';

class LoginTest extends StatelessWidget {
  const LoginTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'LoginTest Page',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
      ),
      body: const LoginTestPage(),
    );
  }
}

class LoginTestPage extends StatefulWidget {
  const LoginTestPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginTestPageState createState() => _LoginTestPageState();
}

class _LoginTestPageState extends State<LoginTestPage> {
  final _loginFormKey = GlobalKey<FormState>();
  /*...Create a controller for every field ...*/
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  /*...Make sure the field has value entered ...*/
  String emailValue = '';
  String _emailLatestValue() {
    return emailValue = ((_emailController.text).isNotEmpty &&
            (_emailController.text).isNotEmpty
        ? _emailController.text
        : '');
  }

  String passwordValue = '';
  String _passwordLatestValue() {
    return passwordValue = ((_passwordController.text).isNotEmpty &&
            (_passwordController.text).isNotEmpty
        ? _passwordController.text
        : '');
  }

  List<dynamic> _userMasterList = [];

  @override
  void initState() {
    // 'TODO: implement initState
    getSateData();
    super.initState();
    _emailController.addListener(() {
      _emailLatestValue();
    });
    _passwordController.addListener(() {
      _passwordLatestValue();
    });
  }
  List<String> stateType = [];
  Future<void> getSateData() async {
    _userMasterList = (await ModelsUsers().fetchUsersData());
    // List<UserListInfo> todo = _userMasterList.map<UserListInfo>((item) => UserListInfo.fromJson(item)).toList();
    // debugPrint(todo.toString());
    for (int i = 0; i < _userMasterList.length; i++) {
      debugPrint(_userMasterList[i][0].toString());
      stateType.add(_userMasterList[i][0].toString());
  

    setState(() {
    
    });
    }
  }
  @override
  void dispose() {
    // 'TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          scrollDirection: Axis.vertical,
          reverse: false,
          controller: ScrollController(),
          primary: false,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10.0),
              constraints: const BoxConstraints(
                minWidth: 380.0,
                maxWidth: 420.0,
                minHeight: 120.0,
                maxHeight: 170.0,
              ),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('res/sucden_coffee.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Form(
              key: _loginFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RawAutocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      return stateType.where((String option) {
                        return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    fieldViewBuilder: (
                      BuildContext context,
                      TextEditingController textEditingController,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted,
                    ) {
                      // return FormTextFieldStandard(
                      //   controller: _emailController,
                      //   textInputType: TextInputType.emailAddress,
                      //   textInputAction: TextInputAction.next,
                      //   fontSize: 16.0,
                      //   fontWeight: FontWeight.w400,
                      //   fontColor: Colors.black,
                      //   icon: Icons.email,
                      //   tooltip: "Email",
                      //   maxLines: 1,
                      //   formTextFieldLabel: "Email Address",
                      //   onFieldSubmitted: (String value) {
                      //       onFieldSubmitted();
                      //     },
                      //   // validate: (stringEmailValue) => stringEmailValue!.isEmpty == true ? "Email" : null,
                      // );
                      return TextFormField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          labelStyle: TextStyle(
                              color: Colors.black, fontSize: 19.0, fontStyle: FontStyle.italic),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.teal,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green,
                              width: 1.0,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            gapPadding: 4.0,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.orangeAccent,
                              width: 1.0,
                              style: BorderStyle.solid,
                            ),
                          ),
                          errorStyle: TextStyle(color: Colors.black),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.red, width: 1.0, style: BorderStyle.solid),
                          ),
                        ),
                        textCapitalization: TextCapitalization.none,
                        textInputAction: TextInputAction.next,
                        strutStyle: StrutStyle(),
                        textAlign: TextAlign.start,
                        textAlignVertical: TextAlignVertical.center,
                        autocorrect: true,
                        enableSuggestions: true,
                        maxLines: 1,
                        /*(val)=> !val.contains(pattern) ||  val.isEmpty? 'Invalid Charachters': null,*/
                        //onSaved: (val)=> _text = val ,
                        toolbarOptions:
                            ToolbarOptions(copy: true, cut: true, paste: true, selectAll: true),
                        autofocus: false,
                        onFieldSubmitted: (String value) {
                          onFieldSubmitted();
                        },
                      );
                    },
                    optionsViewBuilder: (
                      BuildContext context,
                      AutocompleteOnSelected<String> onSelected,
                      Iterable<String> options,
                    ) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          elevation: 4.0,
                          child: SizedBox(
                            height: 200.0,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(8.0),
                              itemCount: options.length,
                              itemBuilder: (BuildContext context, int index) {
                                final String option = options.elementAt(index);
                                return GestureDetector(
                                  onTap: () {
                                    onSelected(option);
                                  },
                                  child: ListTile(
                                    title: Text(option),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  FormTextFieldStandard(
                    controller: _emailController,
                    textInputType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    fontColor: Colors.black,
                    icon: Icons.email,
                    tooltip: "Email",
                    maxLines: 1,
                    formTextFieldLabel: "Email Address",
                    validate: (stringEmailValue) =>
                        stringEmailValue!.isEmpty == true ? "Email" : null,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  FormTextFieldStandardObsecured(
                    controller: _passwordController,
                    textInputType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    fontColor: Colors.black,
                    icon: Icons.security,
                    tooltip: "Password",
                    maxLines: 1,
                    formTextFieldLabel: "Password",
                    validate: (stringPassValue) =>
                        stringPassValue!.isEmpty == true
                            ? "Add Password"
                            : null,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    alignment: Alignment.center,
                    constraints: const BoxConstraints(
                      minWidth: 380.0,
                      maxWidth: 420.0,
                      minHeight: 50.0,
                      maxHeight: 50.0,
                    ),
                    child: StandardElevatedButton(
                      style: const ButtonStyle(),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Color.fromARGB(255, 6, 49, 113),
                          fontSize: 17.0,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                        ),
                      ),
                      onPressed: () {
                        processLoginData(context);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  // Container(
                  //   alignment: Alignment.center,
                  //   constraints: const BoxConstraints(
                  //     minWidth: 380.0,
                  //     maxWidth: 420.0,
                  //     minHeight: 50.0,
                  //     maxHeight: 50.0,
                  //   ),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     crossAxisAlignment: CrossAxisAlignment.stretch,
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       Expanded(
                  //         flex: 1,
                  //         child: InkWell(
                  //           child: const Text(
                  //             "Register Account",
                  //             style: TextStyle(
                  //               color: Colors.blue,
                  //               fontSize: 14.0,
                  //               fontStyle: FontStyle.italic,
                  //               fontWeight: FontWeight.bold,
                  //               decoration: TextDecoration.underline,
                  //             ),
                  //             textAlign: TextAlign.center,
                  //           ),
                  //           onTap: () {
                  //             Navigator.pushNamed(context, '/register');
                  //           },
                  //         ),
                  //       ),
                  //       Expanded(
                  //         flex: 1,
                  //         child: InkWell(
                  //           child: const Text(
                  //             'Seller Shop',
                  //             style: TextStyle(
                  //               color: Colors.blue,
                  //               fontSize: 14.0,
                  //               fontStyle: FontStyle.italic,
                  //               fontWeight: FontWeight.bold,
                  //               decoration: TextDecoration.underline,
                  //             ),
                  //             textAlign: TextAlign.center,
                  //           ),
                  //           onTap: () {
                  //             Navigator.pushNamed(context, '/sellerShop');
                  //           },
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> processLoginData(BuildContext context) async {
    if (_loginFormKey.currentState!.validate()) {
      _loginFormKey.currentState!.save();

      ModelsUsers()
          .userLoginModel(emailValue, passwordValue)
          .then((loginFuture) {
        if (loginFuture.toString().contains('act')) {
          Navigator.pushNamed(context, '/scannerForm');
          setState(() {
            _emailController.clear();
            _passwordController.clear();
          });
        } else if (loginFuture.toString().contains('sel')) {
          Navigator.pushNamed(context, '/sellerAccount');
          setState(() {
            _emailController.clear();
            _passwordController.clear();
          });
        } else if (loginFuture.toString().contains('not')) {
          setState(() {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.white,
                elevation: 10.0,
                shape: Border.all(
                    color: Colors.red, width: 0.5, style: BorderStyle.solid),
                content: const Text(
                  "Email Not Registered",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 1.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
            _emailController.clear();
            _passwordController.clear();
            Timer(const Duration(seconds: 3), () {
              Navigator.pushNamed(context, '/');
            });
          });
        } else if (loginFuture.contains('fai')) {
          setState(() {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.white,
                elevation: 10.0,
                shape: Border.all(
                  color: Colors.red,
                  width: 0.5,
                  style: BorderStyle.solid,
                ),
                content: const Text(
                  "Login Failed..wrong email or password",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 1.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
            _emailController.clear();
            _passwordController.clear();
            Timer(const Duration(seconds: 3), () {
              Navigator.pushNamed(context, '/login');
            });
          });
        } else if (loginFuture.contains('exc')) {
          setState(() {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.white,
                elevation: 10.0,
                shape: Border.all(
                    color: Colors.orange, width: 0.5, style: BorderStyle.solid),
                content: const Text(
                  "Something Went Wrong",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 1.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
            _emailController.clear();
            _passwordController.clear();
            Timer(const Duration(seconds: 4), () {
              Navigator.pushNamed(context, '/login');
            });
          });
        }
      }).catchError((err) {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.white,
              elevation: 10.0,
              shape: Border.all(
                  color: Colors.orange, width: 0.5, style: BorderStyle.solid),
              content: const Text(
                "Something Went Wrong",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 1.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
          _emailController.clear();
          _passwordController.clear();
          Timer(const Duration(seconds: 4), () {
            Navigator.pushNamed(context, '/login');
          });
        });
      }).whenComplete(() => null);
    } else {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.white,
            elevation: 10.0,
            shape: Border.all(
              color: Colors.orange,
              width: 0.5,
              style: BorderStyle.solid,
            ),
            content: const Text(
              "Fill All Details",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                letterSpacing: 1.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
        _emailController.clear();
        _passwordController.clear();
        Timer(const Duration(seconds: 4), () {
          Navigator.pushNamed(context, '/login');
        });
      });
    }
  }

  loginFieldsData() {}
}

class AutocompleteBasicExample extends StatelessWidget {
  AutocompleteBasicExample({Key? key});

  static const List<String> _options = <String>[
    'aardvark',
    'bobcat',
    'chameleon',
  ];

  List<dynamic> _userMasterList = [];

  // @override
  // void initState() {
  //   // 'TODO: implement initState
  //   getSateData();
  //   super.initState();
  // }
  List<String> stateType = [];
  Future<void> getSateData() async {
    _userMasterList = (await ModelsUsers().fetchUsersData());
    // List<UserListInfo> todo = _userMasterList.map<UserListInfo>((item) => UserListInfo.fromJson(item)).toList();
    // debugPrint(todo.toString());
    for (int i = 0; i < _userMasterList.length; i++) {
      debugPrint(_userMasterList[i][0].toString());
      stateType.add(_userMasterList[i][0].toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        return _userMasterList[0].where((String option) {
          return option.contains(textEditingValue.text.toLowerCase());
        });
      },
      fieldViewBuilder: (
        BuildContext context,
        TextEditingController textEditingController,
        FocusNode focusNode,
        VoidCallback onFieldSubmitted,
      ) {
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          onFieldSubmitted: (String value) {
            onFieldSubmitted();
          },
        );
      },
      optionsViewBuilder: (
        BuildContext context,
        AutocompleteOnSelected<String> onSelected,
        Iterable<String> options,
      ) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            child: SizedBox(
              height: 200.0,
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final String option = options.elementAt(index);
                  return GestureDetector(
                    onTap: () {
                      onSelected(option);
                    },
                    child: ListTile(
                      title: Text(option),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}