import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:naftal/data/Bien_materiel.dart';
import 'package:naftal/data/Localisation.dart';
import 'package:naftal/detail_bien.dart';
import 'package:naftal/detail_operation.dart';
import 'package:naftal/history.dart';

void main() => runApp(Create_Bien());

class Create_Bien extends StatefulWidget {

  @override
  _Create_BienState createState() => _Create_BienState();
}

class _Create_BienState extends State<Create_Bien> {
  String _scanBarcode = '';
  late Bien_materiel bien;
  TextEditingController nomController =  TextEditingController();

   static const Color  blue = Color.fromRGBO(0, 73, 132, 1);
   static const Color yellow   =  Color.fromRGBO(255, 227,24, 1);
  int _value= 2;

  
  @override
  void initState() {
    super.initState();


 
  }



  

  @override
  Widget build(BuildContext context) {
    bien = ModalRoute.of(context)!.settings.arguments as Bien_materiel;
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
                                Text(" L'ajout d'un bien matériel",
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
                                       Text('Bien Matériel : ${bien.code_bar}',
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                      children: [
                                          Icon(Icons.rate_review),
                                          SizedBox(
                                            width: 10,
                                          ),
                                         Text("Etat du bien matériel",
                                          style: TextStyle(
                                          fontSize: 16,
                                  ),)
                                      ],
                                  )
                                 ,
                                        
                                      ListTile(
                                        title: Text(
                                          'Mauvais',
                                        ),
                                        leading: Radio(
                                          value: 1,
                                          groupValue: _value,
                                          onChanged:  (val){

                                            setState(() {
                                              
                                              _value = val as int;
                                              print(_value);

                                            });
                                              

                                          } ,
                                        ),
                                      ),
                                         ListTile(
                                        title: Text(
                                          'Moyen',
                                        ),
                                        leading: Radio(
                                          value: 2,
                                          groupValue: _value,
                                          onChanged:  (val){

                                            setState(() {
                                              
                                              _value = val as int;
                                              print(_value);
                                            });
                                              

                                          } ,
                                        ),
                                      ),
                                         ListTile(
                                        title: Text(
                                          'Bon',
                                        ),
                                        leading: Radio(
                                          value: 3,
                                          groupValue: _value,
                                          onChanged:  (val){

                                            setState(() {
                                              
                                              _value = val as int;
                                              print(_value);

                                            });
                                              

                                          } ,
                                        ),
                                      ),
                                ],

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

                                      bien.designation = nomController.text;
                                      bien.etat = _value;

                                      bool stored =  await bien.Store_Bien();

                                      if(stored == true){

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) =>  Detail_Bien(),
                                                  settings: RouteSettings(arguments: bien)
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