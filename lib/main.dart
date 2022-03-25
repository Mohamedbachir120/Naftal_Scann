

import 'package:flutter/material.dart';
import 'package:naftal/data/User.dart';

import 'operations.dart';
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
void main() {
  
       runApp(const Login(

       )
       
       
       );
      
    

}

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      theme: ThemeData(
    
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(title: 'NaftalAppScann'),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);

 

  final String title ;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    
    initDatabase();


 
  
  }
 
  void initDatabase  () async{
    final database = openDatabase(
           join(await getDatabasesPath(), 'naftal_scan.db'),
      onCreate: (db, version) {
        db.execute(
          '''CREATE TABLE User(matricule TEXT PRIMARY KEY, 
           nom TEXT,
           prenom TEXT , 
           email TEXT , 
           mot_de_passe TEXT)''',
        );
        db.execute(
          '''CREATE TABLE Localisation(code_bar TEXT PRIMARY KEY,
           designation TEXT ,
           stockage INTEGER ,
           date_scan DATETIME ,
           user_matricule TEXT ,
           UNIQUE(code_bar),
           FOREIGN KEY(user_matricule) REFERENCES User(matricule)
           )''',
        );
       db.execute(
           '''CREATE TABLE Bien_materiel(code_bar TEXT PRIMARY KEY,
           designation TEXT ,
           etat INTEGER ,
           date_scan DATETIME ,
           code_localisation TEXT,
           UNIQUE(code_bar),
           FOREIGN KEY(code_localisation) REFERENCES Localisation(code_bar)
           )''',
        );

    
      },
      version: 1,
    );
    User user = User("1717", "moh", "bachir", "moh@email.com", "mdp");
    
    final db = await database;
      db.insert('User', user.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
    

  }
  Future <int> fetchUser(BuildContext context) async{

    int nb = await User.check_user();
    if(nb >0){

           Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) =>  MyApp()),
                          (Route<dynamic> route) => false
                        );

  }
    
    return nb;

   
  }

  @override
  Widget build(BuildContext context) {
  
     
    
  
    return FutureBuilder(
      
      
          
          future: fetchUser(context),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot)  { 
             
              if(snapshot.hasData && snapshot.data != 1){
              

              return 
              Scaffold( 
                body:SingleChildScrollView(
                child: 
               Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
              maxWidth: MediaQuery.of(context).size.width,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                // ignore: prefer_const_literals_to_create_immutables
                colors: [
              
                  Color.fromRGBO(0, 73, 132, 1),
                  Color.fromRGBO(0, 73, 132, 1),
                  Color.fromRGBO(0, 73, 132, 1),
                  Color.fromRGBO(0, 73, 132, 1),
                  
                  
        
              
        
        
        
                ],
                begin: Alignment.topLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                child:Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 34.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                                   // ignore: deprecated_member_use
                                   IconButton(
                                     onPressed: (){
                                   Navigator.pop(context);
                                     },
                                     icon: Icon(Icons.arrow_back,color: Colors.white,),
                                   ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                        ),
                        child: Text("Connectez-vous",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),),
                      ),
                    ],
        
                  ),
                )
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      
                      color:  Color.fromRGBO(255, 227,24, 1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
        
                      )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(25, 8, 25, 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image(image: AssetImage("assets/naftal.png",
                          ),
                          height: 170,
                          width: 170,),
                          SizedBox(height: 15,),
                          Container(
                             decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: new BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 3,
                                  blurRadius: 3,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child:  TextFormField(
                              decoration:  InputDecoration(
                                prefixIcon: Icon(Icons.mail,color: Colors.black,),
                                labelText: "Adresse email",
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
                          SizedBox(height: 20,),
                          Container(
                            
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:  BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 3,
                                  blurRadius: 3,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child:  TextFormField(
                             
                              decoration:  InputDecoration(
                                prefixIcon: Icon(Icons.lock,color: Colors.black,),
                                suffixIcon: IconButton(
                                  onPressed: (){
                                 
                                  },
                                  icon: Icon(Icons.remove_red_eye,color: Colors.black,),
                                ),
                                labelText: "Mot de passe",
                                fillColor: Colors.white,
                                 labelStyle: TextStyle(
                                  color:  Colors.black
                                ),
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
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
                          SizedBox(height: 20,),
                          FlatButton(
                            onPressed: () async{
                          
                            },
                            child: Text("Mot de passe oubliée?",
                          style: TextStyle(
                            color: const Color.fromRGBO(0, 73, 132, 1),
        
                          ),
                          ),
                          ),
                          SizedBox(height: 20,),
                          ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            primary: 
                               const Color.fromRGBO(0, 73, 132, 1),
        
                            onPrimary: Colors.white,
                          ),
                                onPressed: () async {
                                    Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>  MyApp()),
                                  );
        
                                                        
        
        
        
                                },                  
                                child: Padding(
                                  
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 12,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: <Widget>[
                                      Text('Connexion', 
                                      style: TextStyle(fontSize: 24.0,
                                      fontWeight: FontWeight.bold),),
                                      
                                    ],
                                  ),
                                ) 
                                  ),
                                
                               
                          
                        ],
                      ),
        
                    ),
                  ),)
              ],
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