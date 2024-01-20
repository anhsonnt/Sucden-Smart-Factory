import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:sucden_smart_factory/models/userslist_info.dart';

class AppDatabase {
  String buyerEmailValue = '';
  String sellerEmailValue = '';
  String passwordValue = '';
  String mobileValue = '';
  String companyNameValue = '';
  String landlineValue = '';
  String fNameValue = '';
  String lNameValue = '';
  String tID = '';
  String tSoXe = '';
  String tCustomer = '';
  String tProduct = '';

  PostgreSQLConnection? connection;
  PostgreSQLResult? newSellerRegisterResult, newBuyerRegisterResult;
  PostgreSQLResult? sellerAlreadyRegistered, buyerAlreadyRegistered;

  PostgreSQLResult? loginResult, userRegisteredResult;

  PostgreSQLResult? updateBuyerResult;
  PostgreSQLResult? updateSellerResult;
  PostgreSQLResult? updateStackResult;

  static String? sellerEmailAddress, buyerEmailAddress, tripID;

  PostgreSQLResult? _fetchSellerDataResult;
  PostgreSQLResult? _fetchUsersDataResult;
  PostgreSQLResult? _fetchtripsDataResult;
  PostgreSQLResult? _fetchstackDataResult;

  AppDatabase() {
    connection = (connection == null || connection!.isClosed == true
        ? PostgreSQLConnection(
            // for external device like mobile phone use domain.com or
            // your computer machine IP address (i.e,192.168.0.1,etc)
            // when using AVD add this IP 10.0.2.2
            '192.168.1.252',
            5433,
            'weightbridge',
            username: 'postgres',
            password: '123@321',
            timeoutInSeconds: 30,
            queryTimeoutInSeconds: 30,
            timeZone: 'UTC',
            useSSL: false,
            isUnixSocket: false,
          )
        : connection);

    fetchDataFuture = [];
  }

  // Register Database Section
  String newSellerFuture = '';
  Future<String> registerSeller(
      String email, String password, String mobile) async {
    try {
      await connection!.open();
      await connection!.transaction((newSellerConn) async {
        //Stage 1 : Make sure email or mobile not registered.
        sellerAlreadyRegistered = await newSellerConn.query(
          'select * from myAppData.register where emailDB = @emailValue OR mobileDB = @mobileValue',
          substitutionValues: {'emailValue': email, 'mobileValue': mobile},
          allowReuse: true,
          timeoutInSeconds: 30,
        );
        if (sellerAlreadyRegistered!.affectedRowCount > 0) {
          newSellerFuture = 'alr';
        } else {
          //Stage 2 : If user not already registered then we start the registration
          newSellerRegisterResult = await newSellerConn.query(
            'insert into myAppData.register(emailDB,passDB,mobileDB,registerDateDB,roleDB,authDB,statusDB,isSellerDB) '
            'values(@emailValue,@passwordValue,@mobileValue,@registrationValue,@roleValue,@authValue,@statusValue,@isSellerValue )',
            substitutionValues: {
              'emailValue': email,
              'passwordValue': password,
              'mobileValue': mobile,
              'statusValue': true,
              'roleValue': 'ROLE_SELLER',
              'authValue': 'seller',
              'registrationValue': DateTime.now(),
              'isSellerValue': true,
            },
            allowReuse: true,
            timeoutInSeconds: 30,
          );
          newSellerFuture =
              (newSellerRegisterResult!.affectedRowCount > 0 ? 'reg' : 'nop');
        }
      });
    } catch (exc) {
      newSellerFuture = 'exc';
      exc.toString();
    }
    return newSellerFuture;
  }

  String newBuyerFuture = '';
  Future<String> registerBuyer(
      String email, String password, String fName, String lName) async {
    try {
      await connection!.open();
      await connection!.transaction((newBuyerConn) async {
        buyerAlreadyRegistered = await newBuyerConn.query(
          'select * from myAppData.register where emailDB = @emailValue order by idDB',
          substitutionValues: {'emailValue': email},
          allowReuse: true,
          timeoutInSeconds: 30,
        );
        if (buyerAlreadyRegistered!.affectedRowCount > 0) {
          newBuyerFuture = 'alr';
        } else {
          newBuyerRegisterResult = await newBuyerConn.query(
            'insert into myAppData.register (emailDB,passDB,fNameDB,lNameDB,statusDB,roleDB,authDB,registerDateDB)'
            'values(@emailValue,@passwordValue,@fNameValue,@lNameValue,@statusValue,@roleValue,@authValue,@registrationValue)',
            substitutionValues: {
              'emailValue': email,
              'passwordValue': password,
              'fNameValue': fName,
              'lNameValue': lName,
              'statusValue': true,
              'roleValue': 'ROLE_BUYER',
              'authValue': 'buyer',
              'registrationValue': DateTime.now(),
            },
            allowReuse: true,
            timeoutInSeconds: 30,
          );
          newBuyerFuture =
              (newBuyerRegisterResult!.affectedRowCount > 0 ? 'reg' : 'nop');
        }
      });
    } catch (exc) {
      exc.toString();
      newBuyerFuture = 'exc';
    }
    return newBuyerFuture;
  }

  //Login Database Section
  String userLoginFuture = '';
  Future<String> loginUser(String email, String password) async {
    try {
      await connection!.open().then((value) {
        debugPrint("Database Connected!");
      });
      await connection!.transaction((loginConn) async {
        //Step 1 : Check email registered or no
        loginResult = await loginConn.query(
          'select name,pwd_mobile,email from public.users_list where name = @emailValue order by id',
          substitutionValues: {'emailValue': email},
          allowReuse: true,
          timeoutInSeconds: 30,
        );
        if (loginResult!.affectedRowCount > 0) {
          sellerEmailAddress = loginResult!.first
              .elementAt(0); //This to use when update seller details
          // userLoginFuture = 'act';
          if (loginResult!.first.elementAt(1).contains(password) == true) {
            userLoginFuture = 'act';
          // } else if (loginResult!.first.elementAt(1).contains(password) ==
          //         true &&
          //     loginResult!.first.elementAt(2) == false) {
          //   userLoginFuture = 'buy';
          } else if (loginResult!.first.elementAt(1).contains(password) ==
              false) {
            userLoginFuture = 'fai';
          } else {
            userLoginFuture = 'exc';
          }
        } else {
          userLoginFuture = 'not';
        }
      });
    } catch (exc) {
      userLoginFuture = 'exc';
      exc.toString();
    }
    return userLoginFuture;
  }

  //Update Database Section
  String futureBuyerUpdate = '';
  Future<String> updateBuyerData(int ssn, String mobile) async {
    try {
      await connection!.open();
      await connection!.transaction((updateBuyerConn) async {
        debugPrint('update buyer');
        // Mobile column in DB is unique..so we check the buyer mobile first
        PostgreSQLResult checkBuyerMobile = await updateBuyerConn.query(
          'select mobileDB from myAppData.register where mobileDB = @mobileValue',
          substitutionValues: {'mobileValue': mobile},
          allowReuse: false,
          timeoutInSeconds: 30,
        );
        if (checkBuyerMobile.affectedRowCount > 0) {
          futureBuyerUpdate = 'alr';
        } else {
          //If check fails ..then we update buyer data
          updateBuyerResult = await updateBuyerConn.query(
            'update myAppData.register set SSN_DB = @ssnValue, mobileDB = @mobileValue where emailDB = @emailValue',
            substitutionValues: {
              'ssnValue': ssn,
              'mobileValue': mobile,
              'emailValue': AppDatabase.sellerEmailAddress,
            },
            allowReuse: false,
            timeoutInSeconds: 30,
          );
          debugPrint('update buyer 1');
          futureBuyerUpdate =
              (updateBuyerResult!.affectedRowCount > 0 ? 'upd' : 'nop');
        }
      });
    } catch (exc) {
      futureBuyerUpdate = 'exc';
      exc.toString();
    }
    return futureBuyerUpdate;
  }

  String sellerDetailsFuture = '';
  Future<String> updateSellerData(
      String companyNameValue, String fNameValue, String logoImage) async {
    try {
      await connection!.open();
      await connection!.transaction((sellerUpdateConn) async {
        updateSellerResult = await sellerUpdateConn.query(
          'update myAppData.register set companyDB = @companyValue , fNameDB = @fNameValue , avatar = @avatarValue where emailDB = @emailValue',
          substitutionValues: {
            'companyValue': companyNameValue,
            'fNameValue': fNameValue,
            'avatarValue': logoImage,
            'emailValue': AppDatabase.sellerEmailAddress,
          },
          allowReuse: false,
          timeoutInSeconds: 30,
        );
        sellerDetailsFuture =
            (updateSellerResult!.affectedRowCount > 0 ? 'upd' : 'not');
      });
    } catch (exc) {
      sellerDetailsFuture = 'exc';
      exc.toString();
    }
    return sellerDetailsFuture;
  }

  // Fetch Data Section
  List<dynamic> fetchDataFuture = [];
  Future<List<dynamic>> fetchSellerData(String emailText) async {
    try {
      await connection!.open().then((value) {
        debugPrint("Database Connected!");
      });
      await connection!.transaction((fetchDataConn) async {
        _fetchSellerDataResult = await fetchDataConn.query(
          'select name,email,user_id,password,change_first_login from public.users_list where email = @emailValue order by id',
          substitutionValues: {'emailValue': emailText},
          allowReuse: false,
          timeoutInSeconds: 30,
        );
        if (_fetchSellerDataResult!.affectedRowCount > 0) {
          fetchDataFuture = _fetchSellerDataResult!.first.toList(growable: true);
        } else {
          fetchDataFuture = [];
        }
      });
    } catch (exc) {
      fetchDataFuture = [];
      exc.toString();
    }
    return fetchDataFuture;
  }

  // Fetch User Data List
  List<dynamic> fetchUserData = [];
  Future<List<dynamic>> fetchUsersData() async {
    try {
      await connection!.open().then((value) {
        debugPrint("Database Connected!");
      });
      await connection!.transaction((fetchDataConn) async {
        _fetchUsersDataResult = await fetchDataConn.query('select name from public.users_list order by name',
          allowReuse: false,
          timeoutInSeconds: 30,
        );
        if (_fetchUsersDataResult!.affectedRowCount > 0) {
          fetchUserData = _fetchUsersDataResult!.toList(growable: true);
          // debugPrint(fetchUserData.toString());
          // fetchUserData = _fetchUsersDataResult!.isNotEmpty ? _fetchUsersDataResult!.map((c) => UserListInfo.fromJson(c)).toList() : [];
        } else {
          fetchUserData = [];
        }
      });
    } catch (exc) {
      fetchUserData = [];
      exc.toString();
    }
    return fetchUserData;
  }

  // // Fetch Users Data
  // List<String> list = [];
  // Future<List<dynamic>> fetchUsersData() async {
  //   // List<UserListInfo> list = [];
  //   if (connection!.isClosed) {
  //     await connection!.open().then((value) {
  //       debugPrint("Database Connected!");
  //     });
  //   }
  //   try {
  //     // List<Map<String, Map<String, dynamic>>> results = 
  //     final results = await connection!.query('select name from public.users_list order by name');
  //     // debugPrint(results.toString());
  //     list.map((e) => Tab(text: results.elementAt(0).toString())).toList(growable: false);
  //     debugPrint(list.toString());

  //     // List<UserListInfo> list = results.map((e) => UserListInfo.fromJson(e as Map<String, dynamic>)).toList();
  //     return list;
  //   } catch (exc) {
  //     list = [];
  //     exc.toString();
  //   }
  //   // print(usersDataFuture!.elementAt(0));
  //   return list;
  // }
  // Fetch Delivery Registration Section
  Future<List<dynamic>> fetchtripsData(String tripsText) async {
    try {
      await connection!.open().then((value) {
        debugPrint("Database Connected!");
      });
      await connection!.transaction((fetchDataConn) async {
        _fetchtripsDataResult = await fetchDataConn.query(
          'SELECT tr.id, tr.soxe, tr.customer, tr.good FROM public.trips tr JOIN public.security_gate se ON tr.security_gate_id=se.security_id WHERE se.security_name = @tripsValue',
          substitutionValues: {'tripsValue': tripsText},
          allowReuse: false,
          timeoutInSeconds: 30,
        );
        if (_fetchtripsDataResult!.affectedRowCount > 0) {
          fetchDataFuture = _fetchtripsDataResult!.first.toList(growable: true);
        } else {
          fetchDataFuture = [];
        }
      });
    } catch (exc) {
      fetchDataFuture = [];
      exc.toString();
    }
    return fetchDataFuture;
  }
  // Fetch Delivery Registration Section
  Future<List<dynamic>> fetchStackData(String stackText) async {
    try {
      await connection!.open().then((value) {
        debugPrint("Database Connected!");
      });
      await connection!.transaction((fetchDataConn) async {
        _fetchstackDataResult = await fetchDataConn.query(
          'SELECT stack_id, stack_name, zone_id, zone_name FROM public.stack WHERE stack_name = @stackValue',
          substitutionValues: {'stackValue': stackText},
          allowReuse: false,
          timeoutInSeconds: 30,
        );
        if (_fetchstackDataResult!.affectedRowCount > 0) {
          fetchDataFuture = _fetchstackDataResult!.first.toList(growable: true);
        } else {
          fetchDataFuture = [];
        }
      });
    } catch (exc) {
      fetchDataFuture = [];
      exc.toString();
    }
    return fetchDataFuture;
  }

  //Update Database Section
  String futureStackUpdate = '';
  Future<String> updateStackData(int stackID, int zoneID, int tripID, String zoneName) async {
    try {
      await connection!.open();
      await connection!.transaction((updateStackConn) async {
        updateStackResult = await updateStackConn.query(
          'update public.trips set stack_id = @stackIDValue:int4, zone_id = @zoneIDValue:int4, note = @zoneNameValue, mobile_update=@mobile_updateValue where id = @tripIDValue:int4',
          substitutionValues: {
            'stackIDValue': stackID,
            'zoneIDValue': zoneID,
            'tripIDValue': tripID,
            'zoneNameValue': zoneName,
            'mobile_updateValue': true,
          },
          allowReuse: false,
          timeoutInSeconds: 30,
        );
        futureStackUpdate =
            (updateStackResult!.affectedRowCount > 0 ? 'upd' : 'nop');
      });
    } catch (exc) {
      futureStackUpdate = 'exc';
      exc.toString();
    }
    return futureStackUpdate;
  }
}
