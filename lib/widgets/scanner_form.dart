import 'dart:async';
import 'dart:convert';

import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:image_picker/image_picker.dart';

import 'package:sucden_smart_factory/models/model_user.dart';
import 'package:sucden_smart_factory/shared_widgets/buttons.dart';
import 'package:sucden_smart_factory/shared_widgets/clay.dart';
import 'package:sucden_smart_factory/shared_widgets/form_text_field.dart';

class ScannerForm extends StatelessWidget {
  const ScannerForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scanner QR, Barcode',
          style: TextStyle(
              fontSize: 20.0,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: const ScannerPage(),
    );
  }
}
class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final _updateStackAccount = GlobalKey<FormState>();

  ScanResult? scanResult;

  final _flashOnController = TextEditingController(text: 'Flash on');
  final _flashOffController = TextEditingController(text: 'Flash off');
  final _cancelController = TextEditingController(text: 'Cancel');

  var _aspectTolerance = 0.00;
  var _numberOfCameras = 0;
  var _selectedCamera = -1;
  var _useAutoFocus = true;
  var _autoEnableFlash = false;

  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);

  List<BarcodeFormat> selectedFormats = [..._possibleFormats];

  String? companyName;
  String? email;
  String? fName;
  String? mobile;
  String avatar = '';
// Delivery Registration variable
  int id = 0;
  String soxe = '';
  String customer = '';
  String product = '';
// Stack variable
  String stackID = '';
  String stackName = '';
  String zoneID = '';
  String zoneName = '';

  final _emailController = TextEditingController();

  String _emailTextValue = '';
  String _getEmailText() {
    _emailTextValue = ((_emailController.text).isEmpty != true ||
            (_emailController.text).isNotEmpty
        ? _emailController.text
        : '');
    return _emailTextValue;
  }

  String _scanBarcode = 'Unknown or Scan not result';
  String _scanQRcode = 'Unknown or Scan not result';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      _numberOfCameras = await BarcodeScanner.numberOfCameras;
      setState(() {});
    });
    _emailController.addListener(() {
      _getEmailText();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _scan(String type) async {
    if (type == 'DR') {
      id = 0;
      soxe = '';
      customer = '';
      product = '';
    } else if (type == 'STACK') {
      stackID = '';
      stackName = '';
      zoneID = '';
      zoneName = '';
    }
    print(type);
    try {
      final result = await BarcodeScanner.scan(
        options: ScanOptions(
          strings: {
            'cancel': _cancelController.text,
            'flash_on': _flashOnController.text,
            'flash_off': _flashOffController.text,
          },
          restrictFormat: selectedFormats,
          useCamera: _selectedCamera,
          autoEnableFlash: _autoEnableFlash,
          android: AndroidOptions(
            aspectTolerance: _aspectTolerance,
            useAutoFocus: _useAutoFocus,
          ),
        ),
      );
      print(result.rawContent);
      if (type == 'DR') {
        // _scanBarcode = 'DR/240113/2220';
        ModelsUsers()
            .fetchtripsData(result.rawContent)
            // .fetchtripsData('DR/240113/2220')
            .then((fetchedDataFuture) {
              print(fetchedDataFuture);
              if (fetchedDataFuture != []) {
                // If we receive data from DB
                String tripID =
                    fetchedDataFuture.elementAt(0).toString();
                String tripSoxe =
                    fetchedDataFuture.elementAt(1).toString();
                String tripCustomer =
                    fetchedDataFuture.elementAt(2).toString();
                String tripProduct =
                    fetchedDataFuture.elementAt(3).toString();
                Timer(const Duration(seconds: 2), () {
                setState(() {
                  //Important we give time to fetch data from DB
                  // Then we set new state for the page
                  id = int.parse(tripID);
                  soxe = tripSoxe;
                  customer = tripCustomer;
                  product = tripProduct;
                  });
                });
              }
          // print('Trip ID: $id');
        });
        setState(() {
          _scanBarcode = result.rawContent;
          // _scanBarcode = 'DR/240113/2220';
        });
      } else if (type == 'STACK') {
        // _scanQRcode = 'STACK-23-06466';
        ModelsUsers()
            .fetchStackData(result.rawContent)
            // .fetchStackData('STACK-23-06466')
            .then((fetchedDataFuture) {
              print(fetchedDataFuture);
              if (fetchedDataFuture != []) {
                // If we receive data from DB
                String zsstackID =
                    fetchedDataFuture.elementAt(0).toString();
                String zsstackName =
                    fetchedDataFuture.elementAt(1).toString();
                String zszoneID =
                    fetchedDataFuture.elementAt(2).toString();
                String zszoneName =
                    fetchedDataFuture.elementAt(3).toString();
                Timer(const Duration(seconds: 2), () {
                setState(() {
                  //Important we give time to fetch data from DB
                  // Then we set new state for the page
                  stackID = zsstackID;
                  stackName = zsstackName;
                  zoneID = zszoneID;
                  zoneName = zszoneName;
                  });
                });
              }
        });
        setState(() {
          _scanQRcode = result.rawContent;
          // _scanQRcode = 'STACK-23-06466';
        });   
      }
    } on PlatformException catch (e) {
      if (type == 'DR') {
        _scanBarcode = 'Unknown error: $e';
      } else if (type == 'STACK') {
        _scanQRcode = 'Unknown error: $e';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final scanResult = this.scanResult;
    return ListView(
        scrollDirection: Axis.vertical,
        controller: ScrollController(),
        shrinkWrap: true,
        children: [
          Form(
            key: _updateStackAccount,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                Container( 
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton.icon(
                    onPressed: () => _scan('DR'),
                    icon: Icon(Icons.camera_alt),  //icon data for elevated button
                    label: Text("Start scan DR"), //label text 
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Color.fromARGB(255, 6, 49, 113),
                        primary: Color.fromARGB(255, 218, 252, 251) //elevated btton background color
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: ClayContainerDesign(
                    containerColor: Colors.grey[300],
                    borderRadius: 10,
                    customBorderRadius: const BorderRadius.all(Radius.circular(10)),
                    curveType: CurveType.convex,
                    height: 45.0,
                    textDetails: _scanBarcode,
                    clayTextSize: 15.0,
                    clayTextColor: Colors.white,
                    clayTextColorText: Colors.black,
                  ),
                ),
                if (_scanBarcode.contains('DR')) ... [
                  const SizedBox(
                    height: 10.0,
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: ClayContainerDesign(
                      containerColor: Colors.grey[300],
                      borderRadius: 10,
                      customBorderRadius: const BorderRadius.all(Radius.circular(10)),
                      curveType: CurveType.convex,
                      height: 45.0,
                      textDetails: soxe,
                      clayTextSize: 15.0,
                      clayTextColor: Colors.white,
                      clayTextColorText: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: ClayContainerDesign(
                      containerColor: Colors.grey[300],
                      borderRadius: 10,
                      customBorderRadius: const BorderRadius.all(Radius.circular(10)),
                      curveType: CurveType.convex,
                      height: 45.0,
                      textDetails: customer,
                      clayTextSize: 15.0,
                      clayTextColor: Colors.white,
                      clayTextColorText: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: ClayContainerDesign(
                      containerColor: Colors.grey[300],
                      borderRadius: 10,
                      customBorderRadius: const BorderRadius.all(Radius.circular(10)),
                      curveType: CurveType.convex,
                      height: 45.0,
                      textDetails: product,
                      clayTextSize: 15.0,
                      clayTextColor: Colors.white,
                      clayTextColorText: Colors.black,
                    ),
                  ),
                ],
                const SizedBox(
                  height: 10.0,
                ),
                Container( 
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton.icon(
                    onPressed: () => _scan('STACK'),
                    icon: Icon(Icons.camera_alt),  //icon data for elevated button
                    label: Text("Start scan STACK"), //label text 
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Color.fromARGB(255, 6, 49, 113),
                        primary: Color.fromARGB(255, 218, 252, 251) //elevated btton background color
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.loose,
                  child: ClayContainerDesign(
                    containerColor: Colors.grey[300],
                    borderRadius: 10,
                    customBorderRadius: const BorderRadius.all(Radius.circular(10)),
                    curveType: CurveType.convex,
                    height: 45.0,
                    textDetails: _scanQRcode,
                    clayTextSize: 15.0,
                    clayTextColor: Colors.white,
                    clayTextColorText: Colors.black,
                  ),
                ),
                if (_scanQRcode.contains('STACK')) ... [
                  const SizedBox(
                    height: 10.0,
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: ClayContainerDesign(
                      containerColor: Colors.grey[300],
                      borderRadius: 10,
                      customBorderRadius: const BorderRadius.all(Radius.circular(10)),
                      curveType: CurveType.convex,
                      height: 45.0,
                      textDetails: zoneName,
                      clayTextSize: 15.0,
                      clayTextColor: Colors.white,
                      clayTextColorText: Colors.black,
                    ),
                  ),
                ],
                const SizedBox(
                  height: 10.0,
                ),
                Container( 
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton.icon(
                    onPressed: () => updateStackDetailsMethod(context),
                    icon: Icon(Icons.camera_alt),  //icon data for elevated button
                    label: Text("UPDATE STACK TO DR"), //label text 
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Color.fromARGB(255, 65, 68, 250),
                        primary: Color.fromARGB(255, 218, 252, 251) //elevated btton background color
                    ),
                  ),
                ),

                // const SizedBox(
                //   height: 10.0,
                // ),
                // Flexible(
                //   flex: 1,
                //   fit: FlexFit.loose,
                //   child: Image.memory(
                //     const Base64Decoder().convert(avatar),
                //     width: 200.0,
                //     height: 170.0,
                //   ),
                // ),
              ],
            ),
          ),
        ]);
  }

  void updateStackDetailsMethod(BuildContext context) {
    if (_updateStackAccount.currentState!.validate()) {
      _updateStackAccount.currentState!.save();
      // Here we arrange all inputs data from the application
      //and forward to the update model class
      ModelsUsers()
          .updateStackDetails(int.parse(stackID), int.parse(zoneID), id, zoneName)
          .then((updateStackFuture) {
        if (updateStackFuture.toString().contains('upd')) {
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
                content: Text(
                  "Update Successful",
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
            Timer(Duration(seconds: 4), () {
              Navigator.pushNamed(context, '/scannerForm');
            });
          });
        } else if (updateStackFuture.toString().contains('not')) {
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
                content: Text(
                  "Update Failed",
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
            // _companyNameFieldController.clear();
            // _fNameFieldController.clear();
            Timer(Duration(seconds: 4), () {
              Navigator.pushNamed(context, '/scannerForm');
            });
          });
        } else if (updateStackFuture.toString().contains('exc')) {
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
                content: Text(
                  "Something Went Wrong..Try Again",
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
            // _companyNameFieldController.clear();
            // _fNameFieldController.clear();
            Timer(Duration(seconds: 4), () {
              Navigator.pushNamed(context, '/scannerForm');
            });
          });
        }
      });
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
            content: Text(
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
        // _companyNameFieldController.clear();
        // _fNameFieldController.clear();
        Timer(Duration(seconds: 4), () {
          Navigator.pushNamed(context, '/scannerForm');
        });
      });
    }
  }
}
