import 'dart:async';
import 'dart:convert';

import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:sucden_smart_factory/main.dart';
import 'package:sucden_smart_factory/models/model_user.dart';
import 'package:sucden_smart_factory/models/userslist_master.dart';

class DropMenu extends StatelessWidget {
  const DropMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'DropMenu Page',
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
      body: const DropMenuPage(),
    );
  }
}

class DropMenuPage extends StatefulWidget {
  const DropMenuPage({Key? key}) : super(key: key);

  @override
  _dropMenuState createState() => _dropMenuState();
}

class _dropMenuState extends State<DropMenuPage> {
  final GlobalKey<FormState> formKeyValidateUpdateLocationScreen =
      GlobalKey<FormState>();

  List<String> stateType = ['Please select user'];
  List<String> stateTypeI = [];
  List<dynamic> _userMasterList = [];
  String? _currentuserType;
  String? _userID = '';

  @override
  void initState() {
    if (!mounted) return;
    // getSateData();

    super.initState();
  }

  // String currentCountry = '';
  //   Future<void> getSateData() async {
  //   _userMasterList = (await ModelsUsers().fetchUsersData());
  //   for (int i = 0; i < _userMasterList.length; i++) {
  //     print(_userMasterList[i][1]);
  //     stateType.add(_userMasterList[i][1]);
   

  //   setState(() {
     
  //   });
  //   }
  // }
  Future<String> _getStateID(String stateType) async {
    var _filterFilter =
        _userMasterList.where((prod) => prod.userName == stateType).toList();
    print(_filterFilter);
    for (int i = 0; i < _filterFilter.length; i++) {
      _userID = _filterFilter[i].userID.toString();
    }

    setState(() {
      _userID = _userID;
    });

    return _userID!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title:   Text(
          'your Location',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0, systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Container(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
          child: Form(
            key: formKeyValidateUpdateLocationScreen,
            child: Padding(
              padding: const EdgeInsets.only(top: 7.0, left: 24.0, right: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                 
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                    child: 
                    DropdownSearch<String>(
                        popupProps: PopupProps.menu(
                            showSelectedItems: true,
                            disabledItemFn: (String s) => s.startsWith('I'),
                        ),                      
                        items: stateType,
                        validator: (value) {
                        if (value == null) {
                          return 'State required';
                        }
                        },
                        onChanged: (val) 
                            {
                          setState(() async {
                                       _currentuserType = val!;
                          });
                        }

               
                        ),
                      ),
        
                  const SizedBox(
                    height: 10,
                  ),
                // Padding(
                //     padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                //     child: 
                //     DropdownSearch<String>(
                        
                //         mode: Mode.MENU,
                //         showSelectedItems: true,
            
                //         showSearchBox: true,
                //        label: 'user',
                //         hint: 'user',
                //         popupItemDisabled: (String s) => s.startsWith('I'),
                      
                //         items: userType,
                //         validator: (value) {
                //         if (value == null) {
                //              return 'user';
                //         }
                //         },
                //         onChanged: (val) //=>

                //             {
                //           setState(() async {
                //                        _currentuserType = val!;
                                         
                           
                //           });
                       
                //         }

                    
                //         ),
                //       ),
 
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // bottomNavigationBar: Container(
      //   height: 65,
      //   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      //   decoration: const BoxDecoration(
      //     color: Color.fromARGB(255, 234, 231, 231),
      //   ),
      //   child: ElevatedButton(
      //     style: ElevatedButton.styleFrom(
      //         primary: AppTheme.mainColor,
      //         textStyle: CustomTextStyle.textFormFieldMedium
      //             .copyWith(fontSize: 15, fontWeight: FontWeight.normal)),
      //     onPressed: () async {
      //      //-your code
      //       }
      //     ),
      //     child:   Text('Next'),
      //   ),
    );
  }
}
