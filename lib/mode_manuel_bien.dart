
import 'package:flutter/material.dart';
import 'package:naftal/data/Bien_materiel.dart';
import 'package:naftal/data/Localisation.dart';
import 'package:naftal/data/User.dart';

import 'package:naftal/detail_bien.dart';
import 'package:naftal/detail_operation.dart';
import 'package:naftal/main.dart';
import 'package:naftal/operations.dart';



class ModeManuelBien extends StatefulWidget {

   const ModeManuelBien({Key? key, required this.localisation}) : super(key: key);
  final Localisation localisation;
  @override
  _ModeManuelBienState createState() => _ModeManuelBienState(localisation: this.localisation);
}

class _ModeManuelBienState extends State<ModeManuelBien> {
  _ModeManuelBienState({required this.localisation});
  final Localisation localisation;
  TextEditingController codeBar =  TextEditingController();

   static const Color  blue = Color.fromRGBO(0, 73, 132, 1);
   static const Color yellow   =  Color.fromRGBO(255, 227,24, 1);
 

  
  @override
  void initState() {
    super.initState();


 
  }


  String formattedText(String text){

   String result  = text.replaceAll('-', "").replaceAll(" ", "").replaceAll("_","");

    return result.toUpperCase();
  }
  Future<void> Check_bien (BuildContext context) async {

    
   
    
  

  if(check_format(1,formattedText(codeBar.text)) == false){

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
             Row(
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 Icon(Icons.info,color: Colors.white,size: 25),
                 Text("Opération échouée objet non valide",
            style: TextStyle(fontSize: 17.0),
            ),
               ],
             ),
            backgroundColor: Colors.red,
          )
      );

        
  
  }else{
     
    Bien_materiel bien   =  Bien_materiel(formattedText(codeBar.text), MODE_SCAN, DateTime.now().toIso8601String(), localisation.code_bar,0);

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

      
       bool stored =  await bien.Store_Bien();

        if(stored == true){

                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  Detail_Bien(bien_materiel: bien,localisation: localisation,),
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
                  Text("une erreur est survenue veuillez réessayer",
              style: TextStyle(fontSize: 17.0),
              ),
                ],
              ),
              backgroundColor: Colors.red,
            )
        );
        }
      



    }

   
  

  }

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
                            margin: EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 10
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.add,
                                color: blue,),
                                Text(" Ajouter un Bien matériel",
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
                          
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Container(
                               decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.circular(7),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child:  TextFormField(
                                controller: codeBar,
                                decoration:  InputDecoration(
                                  prefixIcon: Icon(Icons.qr_code_2,color: Colors.black,),
                                  labelText: "Code bar",
                                   labelStyle: TextStyle(
                                    color:  Colors.black
                                  ),
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  fillColor: Colors.white,
                                  border:  OutlineInputBorder(
                                    borderRadius:  BorderRadius.circular(25.0),
                                  ),
                                  //fillColor: Colors.green
                                ),
                              
                                keyboardType: TextInputType.emailAddress,
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

                                     await Check_bien(context);

                                        


                                      
                                      

                                    },
                                  )
                                ],
                              ),
                          )
                                 ],
                               ),
                            ),
                          ),
                           
                         
                         
                       
                         
                      
                        ]),
                )
                 
                  
                      );
            }));
  }
}
// ignore_for_file: prefer_const_constructors