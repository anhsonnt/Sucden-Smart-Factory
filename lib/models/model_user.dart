import 'package:flutter/material.dart';
import 'package:sucden_smart_factory/database/app_database.dart';
import 'package:sucden_smart_factory/models/userslist_info.dart';

class ModelsUsers {
  // Register Model Section
  String futureSeller = '';
  Future<String> registerNewSeller(
      String email, String password, String mobile) async {
    futureSeller = await AppDatabase().registerSeller(email, password, mobile);

    return futureSeller;
  }

  String futureBuyer = '';
  Future<String> registerNewBuyer(
      String buyerEmail, String password, String fName, String lName) async {
    futureBuyer =
        await AppDatabase().registerBuyer(buyerEmail, password, fName, lName);
    return futureBuyer;
  }

  /// Login Model Section
  String loginFuture = '';
  Future<String> userLoginModel(String email, String password) async {
    loginFuture = await AppDatabase().loginUser(email, password);
    return loginFuture;
  }

  //Update Model Section
  String futureUpdateBuyer = '';
  Future<String> updateBuyerDetails(
      int ssnFieldValue, String mobileFieldValue) async {
    futureUpdateBuyer =
        await AppDatabase().updateBuyerData(ssnFieldValue, mobileFieldValue);

    return futureUpdateBuyer;
  }

  String sellerUpdateFuture = '';
  Future<String> updateSellerDetails(String companyFieldValue,
      String fNameFieldValue, String logoValue) async {
    sellerUpdateFuture = await AppDatabase().updateSellerData(
        companyFieldValue, fNameFieldValue, logoValue);

    return sellerUpdateFuture;
  }

  // Fetch Seller Data
  List<dynamic> sellerDataFuture = [];
  Future<List<dynamic>> fetchSellerData(String emailValue) async{
    sellerDataFuture = await AppDatabase().fetchSellerData(emailValue);
  return sellerDataFuture ;
  }

  // Fetch Seller Data
  List<dynamic> usersDataFuture = [];
  Future<List<dynamic>> fetchUsersData() async{
    usersDataFuture = await AppDatabase().fetchUsersData();
  return usersDataFuture ;
  }

  // // Fetch Users Data
  // List<UserListInfo> list = [];
  // Future<List<UserListInfo>> fetchUsersData() async {
  //   if (AppDatabase().connection!.isClosed) {
  //     await AppDatabase().connection!.open().then((value) {
  //       debugPrint("Database Connected!");
  //     });
  //   }
  //   try {
  //     List<Map<String, Map<String, dynamic>>> results = 
  //     await AppDatabase().connection!.mappedResultsQuery('select user_id, name, pwd_mobile from public.users_list order by name');
  //     debugPrint(results as String?);
      
  //     list = results.isNotEmpty ? results.map((e) => UserListInfo.fromJson(e)).toList() : [];
  //     return list;
  //   } catch (exc) {
  //     exc.toString();
  //   }
  //   // print(usersDataFuture!.elementAt(0));
  //   return list ;
  // }

  // Fetch Delivery Registration Data
  List<dynamic> tripsDataFuture = [];
  Future<List<dynamic>> fetchtripsData(String tripsValue) async{
    tripsDataFuture = await AppDatabase().fetchtripsData(tripsValue);
  return tripsDataFuture ;
  }
  // Fetch Stack Data
  List<dynamic> stackDataFuture = [];
  Future<List<dynamic>> fetchStackData(String stackValue) async{
    stackDataFuture = await AppDatabase().fetchStackData(stackValue);
  return stackDataFuture ;
  }

  String stackUpdateFuture = '';
  Future<String> updateStackDetails(int stackIDValue,
      int zoneIDValue, int tripIDValue, String zoneName) async {
    stackUpdateFuture = await AppDatabase().updateStackData(
        stackIDValue, zoneIDValue, tripIDValue, zoneName);

    return stackUpdateFuture;
  }

}
