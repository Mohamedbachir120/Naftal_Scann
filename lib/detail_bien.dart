import 'dart:async';

import 'package:flutter/material.dart';
import 'package:naftal/data/Bien_materiel.dart';
import 'package:naftal/data/Localisation.dart';
import 'package:naftal/history.dart';
import 'package:naftal/update_bien.dart';

import 'data/User.dart';

void main() => runApp(Detail_Bien());

class Detail_Bien extends StatefulWidget {

  @override
  _Detail_BienState createState() => _Detail_BienState();
}

class _Detail_BienState extends State<Detail_Bien> {
  late Bien_materiel bien;

  TextEditingController nomController =  TextEditingController();

   static const Color  blue = Color.fromRGBO(0, 73, 132, 1);
   static const Color yellow   =  Color.fromRGBO(255, 227,24, 1);
  
  @override
  void initState() {
    super.initState();
   


 
  }

 
   String date_format(String date){

    DateTime day = DateTime.parse(date);

    return "${day.day}/${day.month}/${day.year}    ${day.hour}:${day.minute}";

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
                                    Icon(Icons.book,
                                    color: blue,),
                                    Text(" Détail bien matériel",
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
                                           Text('Code bar : ${bien.code_bar}',
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
                                           Text('Type : ${bien.designation}',
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
                                           Icon(Icons.qr_code_2),
                                           SizedBox(width: 10,),
                                           Text('Etat : ${bien.get_state()}',
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
                                           Text('Date de scan : ${date_format(bien.date_scan.toString())}',
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
                                           Icon(Icons.qr_code_2),
                                           SizedBox(width: 10,),
                                           Text('Localisation : ${bien.code_localisation}',
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
                                         mainAxisAlignment: MainAxisAlignment.end,
                                         children: [
                                           
                                           TextButton.icon(
                                             style: TextButton.styleFrom(
                                              primary: Colors.white,
                                              backgroundColor: Colors.green
                                             ),
                                             onPressed: (){
                                                Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) =>  Update_Bien(bien: bien,),
                                                ),
                                              );

                                           },
                                            icon: Icon(Icons.edit), 
                                            label: Text("Modifier"))
                                         ],
                                       ),
                                ),
                             
                             
                                
                
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