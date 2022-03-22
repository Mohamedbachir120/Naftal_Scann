import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _scanBarcode = '';

   static const Color  blue = Color.fromRGBO(0, 73, 132, 1);
   static const Color yellow   =  Color.fromRGBO(255, 227,24, 1);
  
  @override
  void initState() {
    super.initState();
  }



  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
    print(_scanBarcode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: const Text('Naftal Scanner',style: TextStyle(
              color: yellow
           
            )
            )
            ,backgroundColor:     blue,
            

            ),
            body: Builder(builder: (BuildContext context) {
              return SingleChildScrollView(
                child:  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Icon(Icons.list_alt,
                                color: blue,),
                                Text("  MES OPÉRATIONS",
                                style: TextStyle(
                                  color: blue,
                                  fontSize:20.0
                                ),
                                )
                              ],
                            ),
                          
                          ),
                          Container(
                            
                            width: double.infinity,
                              margin: EdgeInsets.all(3),

                              decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: new BorderRadius.circular(7),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 3,
                                  blurRadius: 3,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: TextButton(
                              onPressed: () => scanBarcodeNormal(),
                              child: Column(
                                  children: [
                                     Icon(Icons.camera_alt,
                                     size: 30,
                                color: blue,
                                ),
                                Text('Nouvelle opération' ,  
                                
                                style: TextStyle(color: blue,
                                fontSize: 18.0
                                ),
                                )
                                  ]

                              ),
                                  
                                
                                 
                                
                                ),
                          ),
                          Container(
                              width :double.infinity,
                              margin: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: new BorderRadius.circular(7),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 3,
                                  blurRadius: 3,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),

                            child: TextButton(
                                child: Column(
                                  children: [
                                  Icon(Icons.arrow_circle_right_outlined,
                                             color: blue,size: 30,),
                                  Text('Poursuivre la derniére opération',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 18.0
                                      ),
                                )
                                  ],
                                ),
                                onPressed: () => scanBarcodeNormal(),
                               ),
                          ),
                          Container(
                              width: double.infinity,
                              margin: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: new BorderRadius.circular(7),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 3,
                                  blurRadius: 3,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: TextButton(
                                child: Column(children: [
                                 Icon(Icons.history , color: blue, size: 30,),

                                   Text('Historique des opérations', 
                                style: TextStyle(
                                  color: blue,
                                  fontSize: 18

                                ),

                                )
                                ]),
                                onPressed: () => scanBarcodeNormal(),
                            ),
                          ),
                          Container(
                              width: double.infinity,
                              margin: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: new BorderRadius.circular(7),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 3,
                                  blurRadius: 3,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child:TextButton(
                                child: Column(children: [
                                  Icon(Icons.library_books ,
                                color: blue,
                                size: 30,
                                ),
                                 Text('Consulter tous les objets',
                                style: TextStyle(
                                  color: blue,
                                  fontSize: 18.0
                                ),
                                )
                                ]),
                                onPressed: () => scanBarcodeNormal(),
                               ),
                          ),
                      
                        ]),
                )
                 
                  
                      );
            })));
  }
}
// ignore_for_file: prefer_const_constructors