import 'package:naftal/main.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'User.dart';
class Bien_materiel{

  late final  String code_bar;
  String ?date_scan;
  
  /*
  état 1 = mauvais 
  état 2 = moyen 
  état 3 = Bon 

  */ 

  int etat = 3;
  int stockage = 0;
  late String code_localisation ;

  Bien_materiel(String code_bar,int etat,String date_scan,String code_localisation,int stockage){
    this.code_bar = code_bar;
    this.etat = etat;
    this.date_scan = date_scan;
    this.code_localisation =  code_localisation;
    this.stockage = stockage;

  }

    Map<String, dynamic> toMap() {
    return {
      'code_bar': code_bar,
      'etat': etat,
      'date_scan': date_scan,
      'code_localisation':code_localisation,
      'stockage':stockage
    };
  }
  Future<bool> local_check() async{

    final database = openDatabase(
          join(await getDatabasesPath(), 'naftal_scan.db'));
          final db = await database;

            final List<Map<String, dynamic>> maps = await db.query("Bien_materiel where code_bar  = '$code_bar' ");

       

        print(maps.length);
        return (maps.length > 0);
  }
  Future<bool> exists() async{


      var connectivityResult = await (Connectivity().checkConnectivity());
      
        if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
          try {
            
          
                  User user  =  await User.auth();
                  var dio = Dio();

                  final response = await dio.get('${IP_ADDRESS}check_bien',
                  queryParameters: {"token":user.token,"codeBar":this.code_bar});
                  var data = jsonDecode(response.data);


                 var val  =   (data == true) ?  true: await local_check();
                 return val;
          
          } 
          on Dio {

            return false;

          }
        }
        else{

           return await local_check();


        
        }


  }
  String get_state(){
    switch(this.etat){
      case 1: return "Bon";
      case 2: return "Hors service";
      case 3: return "A réformer";

    }

    return "";

  }
  Store_Bien() async{

      try {

          
         final database = openDatabase(
         join(await getDatabasesPath(), 'naftal_scan.db'));
         final db = await database;
           var connectivityResult = await (Connectivity().checkConnectivity());


         if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {

           try {
             
           
          User user  =  await User.auth();

          var dio = Dio();

          final response = await dio.get('${IP_ADDRESS}store_bien',
          queryParameters: {
          "token":user.token,
          "codeBar":this.code_bar,
          "etat":this.etat,
          "operation_codeBar":this.code_localisation
          });

          var data = jsonDecode(response.data);
          if(data == "true"){
            this.stockage = 1;

          }
           
             db.insert('Bien_materiel', this.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
            

            return true;
              

                  
          } 
          on DioError{
            return false ;

          } 



        }else{

              db.insert('Bien_materiel', this.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
            return true;

        }
    




         

      }
       catch (e) {
        return false;
      }
  }
   Store_Bien_Soft() async{

      try {

         final database = openDatabase(
         join(await getDatabasesPath(), 'naftal_scan.db'));
         final db = await database;
           if(this.stockage == 0){

        
    
         

              db.rawUpdate('UPDATE Bien_materiel SET etat = ${MODE_SCAN} where code_bar = \'${this.code_bar}\' ');
            return true;
          }
          else{
            var connectivityResult = await (Connectivity().checkConnectivity());
            if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {

            try {
              
              
            User user  =  await User.auth();
            var dio = Dio();
            

            final response = await dio.get('${IP_ADDRESS}update_bien',
            queryParameters: {
            "token":user.token,
            "codeBar":this.code_bar,
            "etat":this.etat,
            });
            var data = jsonDecode(response.data);
            
            if(data == "true"){
              
              db.rawUpdate('UPDATE Bien_materiel SET etat = ${MODE_SCAN} where code_bar = \'${this.code_bar}\' ');
            

            return true;
            }else{

                return false;

            }
             } 
             on DioError {
               return false;
            }
            

              

         




        }



          }
      }
       catch (e) {
        return false;
      }
  }




  
}