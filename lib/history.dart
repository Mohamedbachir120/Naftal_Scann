

import 'package:flutter/material.dart';
import 'package:naftal/data/Localisation.dart';
import 'package:naftal/detail_operation.dart';

import 'data/User.dart';

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
              Icon(Icons.category),  
              SizedBox(width: 10,),
              Text("Type :",style: textStyle,),
              Text("${loc.designation}",style: textStyle,)
            ],),
          ),
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
                    MaterialPageRoute(builder: (context) =>  Detail_Operation(),
                    settings: RouteSettings(arguments: loc)
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
                      )
                    ] ..addAll(list.map((loc) => LocalisationWidget(loc))) ,

                  ),
                )));
              

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