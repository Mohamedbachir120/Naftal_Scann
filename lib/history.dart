

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:naftal/all_objects.dart';
import 'package:naftal/create_operation.dart';
import 'package:naftal/data/Localisation.dart';
import 'package:naftal/detail_operation.dart';
import 'package:naftal/operations.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:sqflite/sqflite.dart';

import 'data/User.dart';
import 'main.dart';
import 'package:path/path.dart';


void main() {
  
       runApp(const History(
           

       )
       );
      
    

}

class History extends StatelessWidget {
  const History({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'History',
      theme: ThemeData(
    
        primarySwatch: Colors.blue,
      ),
      home: const HistoryPage(title: 'NaftalAppScann'),
    );
  }
}

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key, required this.title}) : super(key: key);

 

  final String title ;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late List<Localisation> list;
  late User user;
   static const Color  blue = Color.fromRGBO(0, 73, 132, 1);
   static const Color yellow   =  Color.fromRGBO(255, 227,24, 1);
     String _scanBarcode="";
    var _currentIndex = 1;


  @override
  void initState() {
    super.initState();
    


 
  
  }

  
  TextStyle textStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    

  );
  String date_format(String date){

    DateTime day = DateTime.parse(date);

    return "${day.day}/${day.month}/${day.year}    ${day.hour}:${day.minute}";

  }
  Widget LocalisationWidget(Localisation loc,BuildContext context){

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
                Icon(Icons.qr_code),
                SizedBox(width: 10,),
                Text("Code bar :",style: textStyle,),
                Text(loc.code_bar,style: textStyle,)
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
                    MaterialPageRoute(builder: (context) =>  Detail_Operation(localisation: loc,),
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
 
 Future <List> fetchLocalisations(BuildContext context) async{

    user  = await User.auth();
    list = await Localisation.show_localisations();
    list = list.reversed.toList();

    return list;

   
  }

  @override
  Widget build(BuildContext context) {
  
     
    
  
    return FutureBuilder(
      
      
          
          future: fetchLocalisations(context),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot)  { 
             
              if(snapshot.hasData ){
              

              return 
              Scaffold( 

                appBar: AppBar(
                  title: const Text('Naftal Scanner',style: TextStyle(
                    color: yellow
                
                  )
                  )
                  ,backgroundColor:     blue,
                   
                ),
                body:SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10,20,20,20),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0,10,10,10),
                        child: Row(
                          
                          children: [
                            Icon(Icons.history ,  size: 30, color: blue),
                            Text("Historique des opérations",
                            style: TextStyle(fontSize: 20,color: blue,fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                         
                        ),
                        Container(
                        margin: EdgeInsets.fromLTRB(0,10,10,10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.green
                              ),
                              onPressed: ()async{
                                ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content:
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Icon(Icons.sync,color: Colors.black87,size: 25),
                                                Text("Synchronisation en cours",
                                            style: TextStyle(fontSize: 17.0,color: Colors.black87),
                                            ),
                                              ],
                                            ),
                                            backgroundColor: Color.fromARGB(255, 214, 214, 214),
                                          )
                                      );
                               List<Localisation> objects =  await Localisation.synchonized_objects();
                               Dio dio = Dio();
                               final response = await dio.get('${IP_ADDRESS}synchronize',
                               queryParameters: {"token":user.token ,"objects":jsonEncode(objects)});
                               
                              if(jsonDecode( response.data) == "true"){
                                final database = openDatabase(
                                join(await getDatabasesPath(), 'naftal_scan.db'));
                                final db = await database;
                                int nb =await db.rawUpdate("UPDATE Localisation SET stockage = 1 where stockage = 0");

                                  ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content:
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Icon(Icons.check,color: Colors.white,size: 25),
                                                Text("Synchronisation effectuée avec succès",
                                            style: TextStyle(fontSize: 17.0,color: Colors.white),
                                            ),
                                              ],
                                            ),
                                            backgroundColor: Colors.green,
                                          )
                                      );
                              }else{


                                ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content:
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Icon(Icons.info,color: Colors.white,size: 25),
                                                Text("une erreur est survenue veuillez réessayer",
                                            style: TextStyle(fontSize: 17.0),
                                            ),
                                              ],
                                            ),
                                            backgroundColor: Colors.red,
                                          )
                                      );
                              }

                                
                                 
                                   
                               
                               
                              },
                             icon: Icon(Icons.sync_sharp ,  size: 20, color: Colors.white), 
                             label:  Text("synchroniser les données",
                            style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),
                            ))
                            
                           
                          ],
                        ),
                         
                        ),
                       
                      
                    ] ..addAll(list.map((loc) => LocalisationWidget(loc,context))) ,

                  ),
                )),       bottomNavigationBar: SalomonBottomBar(
                              currentIndex: _currentIndex,
                              onTap: (i) {
                                
                                switch(i){
                                  case 0:   Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(builder: (context) =>  MyApp()),
                                              ModalRoute.withName('/'),

                                            );break;
              
                                  case 1:     Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) =>  History()),
                                            );break; 
                                  case 2:      Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) =>  All_objects()),
                                               ); break;                                          
                                                              
                              }
                            } ,
                            items: [
                              /// Home
                              SalomonBottomBarItem(
                                icon: Icon(Icons.home),
                                title: Text("Accueil"),
                                selectedColor: Color.fromARGB(255, 4, 50, 88),
                              ),
                              /// Search
                              SalomonBottomBarItem(
                                icon: Icon(Icons.history),
                                title: Text("Historique"),
                                selectedColor: Color.fromARGB(255, 4, 50, 88),
                              ),

                              /// Profile
                              SalomonBottomBarItem(
                                icon: Icon(Icons.storage),
                                title: Text("Serveur"),
                                selectedColor: Color.fromARGB(255, 4, 50, 88),
                              ),
                            ],
                          ),
                );
              

                }else{

                  return 
                  Scaffold(
                
                body :Container(
                      

                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       

                       children: [
                         
                         Padding(
                           padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                           child: SizedBox(
                                  height: 5,
                                  width: double.infinity,
                                  child: LinearProgressIndicator( )),
                         )
                       ],
                     ),
                    
                    
                    ));
                }

            },
           );
     
  }
}