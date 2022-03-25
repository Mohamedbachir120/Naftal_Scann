import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:naftal/create_operation.dart';
import 'package:naftal/data/Localisation.dart';
import 'package:naftal/data/User.dart';
import 'package:naftal/history.dart';

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


  bool check_format(int type,String value){
    print(value);

    if(type == 0){
      // Expression réguliére pour les localisations

      final localisation = RegExp(r'^[a-zA-Z]{2}[0-9]{14}$');


      return localisation.hasMatch(value);

    }else if(type == 1){
      // Expression réguliére pour les bien Matériaux

      final BienMateriel = RegExp(r'^[a-zA-Z]{1}[0-9]{14}$');


      return BienMateriel.hasMatch(value);


    }
    return false;

  }

  Future<void> scanBarcodeNormal(BuildContext context) async {

    
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  

  // if(check_format(1, _scanBarcode) == false){

      // ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content:
      //        Row(
      //          mainAxisAlignment: MainAxisAlignment.start,
      //          children: [
      //            Icon(Icons.info,color: Colors.white,size: 25),
      //            Text("Opération échouée objet non valide",
      //       style: TextStyle(fontSize: 17.0),
      //       ),
      //          ],
      //        ),
      //       backgroundColor: Colors.red,
      //     )
      // );

        
  
  // }

    User user =  await User.auth();
    Localisation loc =  Localisation(_scanBarcode, "Bureau", DateTime.now().toIso8601String(), 0, user.matricule);
  
    

     loc.Store_Localisation().then((exist){
        if(exist == true){
            
       Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  Create_Operation(),
                            settings:RouteSettings(
                              arguments:loc )
                            ),
                          
                        );

         
        }else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
             Row(
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 Icon(Icons.info,color: Colors.white,size: 25),
                 Text("Localisation existe déjà",
            style: TextStyle(fontSize: 17.0),
            ),
               ],
             ),
            backgroundColor: Colors.red,
          )
      );

        }


     });

   
  



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              onPressed: () => scanBarcodeNormal(context),
                              child: Column(
                                  children: [
                                     Icon(Icons.add,
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
                                onPressed: (){
                                    
                                },
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
                                onPressed: () =>{

                                        Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>  History()),
                                  )
                                },
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
                                onPressed: () => scanBarcodeNormal(context),
                               ),
                          ),
                      
                        ]),
                )
                 
                  
                      );
            }));
  }
}
// ignore_for_file: prefer_const_constructors