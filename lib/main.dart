

import 'package:flutter/material.dart';

import 'operations.dart';
void main() {
  runApp(const Login());
}

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(title: 'NaftalAppScann'),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title ;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              // ignore: prefer_const_literals_to_create_immutables
              colors: [
      
                Color.fromRGBO(0, 73, 132, 1),
                Color.fromRGBO(0, 73, 132, 0.9),
                Color.fromRGBO(0, 73, 132, 0.8),
                Color.fromRGBO(0, 73, 132, 0.7),
                
                

            



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
        ),
      ),
    
      
    );
   
  }
}