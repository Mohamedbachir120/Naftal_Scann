

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:naftal/create_operation.dart';
import 'package:naftal/data/Localisation.dart';
import 'package:naftal/detail_operation.dart';
import 'package:dio/dio.dart';
import 'package:naftal/data/User.dart';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:naftal/history.dart';
import 'package:naftal/main.dart';
import 'package:naftal/operations.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';


void main() {
  
       runApp(const All_objects(
           

       )
       );
      
    

}

class All_objects extends StatelessWidget {
  const All_objects({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'All_objects',
      theme: ThemeData(
    
        primarySwatch: Colors.blue,
      ),
      home: const All_objectsPage(title: 'NaftalAppScann'),
    );
  }
}

class All_objectsPage extends StatefulWidget {
  const All_objectsPage({Key? key, required this.title}) : super(key: key);

 

  final String title ;

  @override
  State<All_objectsPage> createState() => _All_objectsPageState();
}

class _All_objectsPageState extends State<All_objectsPage> {
   List<Localisation> list = []; 
  
    var _currentIndex = 3;

   static const Color  blue = Color.fromRGBO(0, 73, 132, 1);
   static const Color yellow   =  Color.fromRGBO(255, 227,24, 1);

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
  Widget LocalisationWidget(Localisation loc){

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



      var connectivityResult = await (Connectivity().checkConnectivity());
      
        if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {

          try {
             User user  =  await User.auth();
          var dio = Dio();
          final response = await dio.get('${IP_ADDRESS}all_operations',
          queryParameters: {"token":user.token});
          var data = jsonDecode(response.data);
          for (var item in data) {
            Localisation localisation = Localisation(item["codeBar"],
            item["created_at"],
             1,
             item["matricule"]);

          list.add(localisation);
         
            }
           } 
          on DioError{

            return  List.empty();

          }
          
            
         

        }

   

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
                            Icon(Icons.storage ,  size: 30, color: blue),
                            Text("Toutes les opérations",
                            style: TextStyle(fontSize: 20,color: blue,fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      )
                    ]..addAll( list.map((e) => LocalisationWidget(e)))  ,

                  ),
                )),bottomNavigationBar: SalomonBottomBar(
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
              

                }else if(list.isEmpty && snapshot.connectionState == ConnectionState.done){

                  return    Scaffold(
                
                body :Container(
                      
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 240, 240, 240)
                      ),
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       

                       children: [
                          Container(
                           padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                           child: Center(
                               
                                  child: Icon(Icons.wifi_off_sharp,size: 40,
                                    color: blue,
                                  ),
                                  )
                                  ),
                         
                         Container(
                          alignment: Alignment.center, 
                          
                           padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                           child: Center(
                                
                                  child: Text("Aucune connexion internet",
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: blue
                                  ),
                                  )),
                         )
                       ],
                     ),
                    
                    
                    ),bottomNavigationBar: SalomonBottomBar(
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

                }
                else{

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
                    
                    
                    )
                    );
                }

            },
           );
     
  }
}