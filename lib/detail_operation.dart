import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:naftal/create_bien.dart';
import 'package:naftal/data/Bien_materiel.dart';
import 'package:naftal/data/Localisation.dart';
import 'package:naftal/detail_bien.dart';
import 'package:naftal/history.dart';

import 'data/User.dart';

void main() => runApp(Detail_Operation());

class Detail_Operation extends StatefulWidget {

  @override
  _Detail_OperationState createState() => _Detail_OperationState();
}

class _Detail_OperationState extends State<Detail_Operation> {
  String _scanBarcode = '';
  late Localisation loc;
  late User user;
  late  int nb_objects;
  TextEditingController nomController =  TextEditingController();
  late List<Bien_materiel> list_objects;


   static const Color  blue = Color.fromRGBO(0, 73, 132, 1);
   static const Color yellow   =  Color.fromRGBO(255, 227,24, 1);
  
  @override
  void initState() {
    super.initState();
   


 
  }

 Future<User> get_user() async{
    user  = await User.auth();
    list_objects = await loc.get_linked_Object();
    nb_objects = list_objects.length;

    return user;
  }
   String date_format(String date){

    DateTime day = DateTime.parse(date);

    return "${day.day}/${day.month}/${day.year}    ${day.hour}:${day.minute}";

  }
 TextStyle textStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    

  );

Widget BienWidget(Bien_materiel bien){

    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),

           boxShadow: [
                BoxShadow(color: Colors.white70, spreadRadius: 1),
              ],
              gradient: LinearGradient(
                // ignore: prefer_const_literals_to_create_immutables
                colors: [
              
                  Colors.white,
                  Colors.white60,
                  Color.fromARGB(255, 238, 238, 238),
                 
                  
                  
        
              
        
        
        
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            

      ),
     
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              
              children: [
              Icon(Icons.category),  
              SizedBox(width: 10,),
              Text("Type :",style: textStyle,),
              Text("${bien.designation}",style: textStyle,)
            ],),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.qr_code),
                SizedBox(width: 10,),
                Text("Code bar :",style: textStyle,),
                Text(bien.code_bar,style: textStyle,)
              ],
            ),
          ),
          
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(onPressed: (){
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  Detail_Bien(),
                    settings: RouteSettings(arguments: bien)
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: blue,
                )
                , icon: Icon(Icons.book),
                 label: Text("Détail"))
              ],
          ),
            )
        ],
      ),



    );
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

  
    Bien_materiel bien   =  Bien_materiel(_scanBarcode, "vide", 1, DateTime.now().toIso8601String(), loc.code_bar);

    bool exist = await bien.exists();

    if(exist == true){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
             Row(
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 Icon(Icons.info,color: Colors.white,size: 25),
                 Text("Bien matériel existe déjà",
            style: TextStyle(fontSize: 17.0),
            ),
               ],
             ),
            backgroundColor: Colors.red,
          )
      );

    }else{

      
         Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  Create_Bien(),
              settings: RouteSettings(arguments: bien)
              ),
            );

      



    }
  }

  @override
  Widget build(BuildContext context) {
    loc = ModalRoute.of(context)!.settings.arguments as Localisation;

    return Scaffold(
            appBar: AppBar(title: const Text('Naftal Scanner',style: TextStyle(
              color: yellow
           
            )
            )
            ,backgroundColor:     blue,
            

            ),
            body: Builder(builder: (BuildContext context) {
              return SingleChildScrollView(
                child:  FutureBuilder(
                  future: get_user(),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot)  { 
                  
                  if(snapshot.hasData){

                  
                    return Padding(
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
                                    Icon(Icons.book,
                                    color: blue,),
                                    Text(" Détail Localisation",
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
                                           Text('Code bar : ${loc.code_bar}',
                                           style: TextStyle(
                                             fontSize: 16
                                           ),
                                           ),
                                         ],
                                       ),
                                ),
                                   Container(
                                       margin: EdgeInsets.all(10),
                                       width: double.infinity,
                                      child:
                                       Row(
                                         children: [
                                           Icon(Icons.category),
                                           SizedBox(width: 10,),
                                           Text('Type : ${loc.designation}',
                                           style: TextStyle(
                                             fontSize: 16
                                           ),
                                           ),
                                         ],
                                       ),
                                ),   Container(
                                       margin: EdgeInsets.all(10),
                                       width: double.infinity,
                                      child:
                                       Row(
                                         children: [
                                           Icon(Icons.person),
                                           SizedBox(width: 10,),
                                           Text('Scanné par : ${user.nom}  ${user.prenom}',
                                           style: TextStyle(
                                             fontSize: 16
                                           ),
                                           ),
                                         ],
                                       ),
                                ),
                                 Container(
                                       margin: EdgeInsets.all(10),
                                       width: double.infinity,
                                      child:
                                       Row(
                                         children: [
                                           Icon(Icons.timer),
                                           SizedBox(width: 10,),
                                           Text('Le : ${date_format(loc.date_scan.toString())}',
                                           style: TextStyle(
                                             fontSize: 16
                                           ),
                                           ),
                                         ],
                                       ),
                                ),
                                  Container(
                                       margin: EdgeInsets.all(10),
                                       width: double.infinity,
                                      child:
                                       Row(
                                         children: [
                                           Icon(Icons.storage),
                                           SizedBox(width: 10,),
                                           Text('Stocké :' ,
                                           style: TextStyle(
                                             fontSize: 16
                                           ),
                                           ),
                                           Text(
                                             (loc.stockage == 0) ? "Localement":"sur serveur",
                                             style: TextStyle(
                                               fontSize: 16
                                             ),
                                           )
                                         ],
                                       ),
                                      ),
                                    Container(
                                       margin: EdgeInsets.all(10),
                                       width: double.infinity,
                                      child:
                                       Row(
                                         children: [
                                           Icon(Icons.format_list_numbered),
                                           SizedBox(width: 10,),
                                           Text('Nombre des bien matériaux :' ,
                                           style: TextStyle(
                                             fontSize: 16
                                           ),
                                           ),
                                           Text(
                                               nb_objects.toString(),
                                             style: TextStyle(
                                               fontSize: 16
                                             ),
                                           )
                                         ],
                                       ),
                                ),
                                 Container(
                                       margin: EdgeInsets.all(10),
                                       width: double.infinity,
                                      child:
                                       Row(
                                         mainAxisAlignment: MainAxisAlignment.end,
                                         children: [
                                           TextButton.icon(
                                             style: TextButton.styleFrom(
                                               primary: Colors.white,
                                               backgroundColor: blue
                                             ),
                                             onPressed: ()async{
                                               await scanBarcodeNormal(context);
                                             },
                                            icon: Icon(Icons.add),
                                             label: Text("Ajouter un bien matériel")
                                             )
                                         ],
                                       ),
                                ) ,
                                  Container(
                                   margin: EdgeInsets.all(10),
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        Icon(Icons.format_list_numbered_rounded),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text("Elements de : ${loc.designation}",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold
                                        ),
                                        ),
                                      ],
                                    ),

                                ),
                             
                                
                
                                   ]..addAll(list_objects.map((bien) => BienWidget(bien))),
                                 ),
                                 


                              ),
                                
                             
                               
                             
                             
                           
                             
                          
                            ]) ,

                    );}
                    else{

                      return LinearProgressIndicator();
                    }
                  }
                )
                 
                  
                      );
            }));
  }
}
// ignore_for_file: prefer_const_constructors