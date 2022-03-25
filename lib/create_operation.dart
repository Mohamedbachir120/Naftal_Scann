import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:naftal/data/Localisation.dart';
import 'package:naftal/detail_operation.dart';
import 'package:naftal/history.dart';

void main() => runApp(Create_Operation());

class Create_Operation extends StatefulWidget {

  @override
  _Create_OperationState createState() => _Create_OperationState();
}

class _Create_OperationState extends State<Create_Operation> {
  String _scanBarcode = '';
  late Localisation loc;
  TextEditingController nomController =  TextEditingController();

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


  



  }

  @override
  Widget build(BuildContext context) {
    loc = ModalRoute.of(context)!.settings.arguments as Localisation;
    int _value = 1;

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
                            margin: EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 10
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.add,
                                color: blue,),
                                Text(" L'ajout d'une nouvelle localisation",
                                style: TextStyle(
                                  color: blue,
                                  fontSize:20.0
                                ),
                                )
                              ],
                            ),
                          
                          ),
                          Card(
                            
                            child:
                            
                             Column(
                               children: [
                                 Container(
                                   margin: EdgeInsets.all(10),
                                   width: double.infinity,
                                  child:
                                   Row(
                                     children: [
                                       Icon(Icons.qr_code_2),
                                       SizedBox(width: 10,),
                                       Text('Localisation : ${loc.code_bar}',
                                       style: TextStyle(
                                         fontSize: 16
                                       ),
                                       ),
                                     ],
                                   ),
                            ),

                             Container(
                              margin: EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 10
                              ), 
                              
                             decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: new BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 0.5,
                                  blurRadius: 0.5,
                                  offset: Offset(0, 0), // changes position of shadow
                                ),
                              ],
                            ),
                            child:  TextFormField(
                              controller: nomController,
                              decoration:  InputDecoration(
                                prefixIcon: Icon(Icons.edit,color: Colors.black,),
                                labelText: "Nom",
                                 labelStyle: TextStyle(
                                  color:  Colors.black
                                ),
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                fillColor: Colors.white,
                                border:  OutlineInputBorder(
                                  borderRadius:  BorderRadius.circular(10.0),
                                ),
                                //fillColor: Colors.green
                              ),
                            
                              keyboardType: TextInputType.text,
                              style:  TextStyle(
                                fontFamily: "Poppins",
                              
                              ),
                            ),
                          ),
                        
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  style: TextButton.styleFrom(
                                      primary: Colors.white, 
                                      backgroundColor: Colors.green
                                      // Text Color
                                    ),
                                  icon: Icon(Icons.check , color:Colors.white),
                                  label: Text("Valider"),
                                  onPressed: ()async{

                                    if(nomController.text.trim().length > 0){

                                      loc.designation = nomController.text;

                                      bool stored =  await loc.Soft_Store_Localisation();

                                      if(stored == true){

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) =>  Detail_Operation(),
                                                  settings: RouteSettings(arguments: loc)
                                                  ),
                                                );
                                      }else{

                                        print("error");
                                      }


                                    }else{

                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content:
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Icon(Icons.info,color: Colors.white,size: 25),
                                                Text("Veuillez remplir tous les champs",
                                            style: TextStyle(fontSize: 17.0),
                                            ),
                                              ],
                                            ),
                                            backgroundColor: Colors.red,
                                          )
                                      );
                                    }
                                    

                                  },
                                )
                              ],
                            ),
                          )
                               ],
                             ),
                          ),
                           
                         
                         
                       
                         
                      
                        ]),
                )
                 
                  
                      );
            }));
  }
}
// ignore_for_file: prefer_const_constructors