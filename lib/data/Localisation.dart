
import 'package:naftal/data/Bien_materiel.dart';
import 'package:naftal/data/User.dart';
import 'package:naftal/main.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class Localisation {


  late final  String code_bar;
  String ?date_scan;
  // Par défaut le fichier sera stocké localement
  // 0 localement 
  // 1 Sur serveur
  
  int stockage = 0;
  late final String user_matricule; 


  // Constructeur
  Localisation(String code_bar,String date_scan,int stockage,String user_matricule){
    this.code_bar = code_bar;
    this.date_scan = date_scan;
    this.stockage = stockage;
    this.user_matricule = user_matricule;
  }

  static Future<Localisation>  get_localisation(String code_bar)async{

 var connectivityResult = await (Connectivity().checkConnectivity());

        if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {

            var user  = await User.auth();
          var dio = Dio();
          final response = await dio.get('${IP_ADDRESS}detail_operation',
          queryParameters: {"token":user.token,"codeBar":code_bar});
          var data = jsonDecode(response.data);

          return Localisation(code_bar, data["created_at"], 1, data["matricule"]);
          
          }else{

          
        final database = openDatabase(
        join(await getDatabasesPath(), 'naftal_scan.db'));
        final db = await database;

        final List<Map<String, dynamic>> maps = await db.query("Localisation where code_bar  = '$code_bar' ");

          return Localisation(
                    maps[0]['code_bar'],
                    maps[0]['date_scan'],
                    maps[0]['stockage'],
                    maps[0]['user_matricule'],

                );
      }



  }
  //to Json
    Map<String, dynamic> toJson() => {
        'code_bar': code_bar,
      };
  // Maping pour l'insertion dans la base de donnés
   Map<String, dynamic> toMap() {
    return {
      'code_bar': code_bar,
      'date_scan': date_scan,
      'stockage': stockage,
      'user_matricule':user_matricule
    };
  }

  Future<bool> local_check()async{

    final database = openDatabase(
                join(await getDatabasesPath(), 'naftal_scan.db'));
                final db = await database;

                  final List<Map<String, dynamic>> maps = await db.query("Localisation where code_bar  = '$code_bar' ");

              

            
            return (maps.length > 0);
  }
  Future<bool> exists() async{


       var connectivityResult = await (Connectivity().checkConnectivity());
      
        if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {

          try{
          User user  =  await User.auth();
          var dio = Dio();

          final response = await dio.get('${IP_ADDRESS}check_operation',
          queryParameters: {"token":user.token,"codeBar":this.code_bar});
          var data = jsonDecode(response.data);

          var  val  =  (data == true) ? true :await local_check();

            return val;




        } on DioError{

          return false;
        }
        
        }
       
        
        else{

        return await local_check();

          
        }

  }
  static show_localisations() async{


  User user = await User.auth();
  final database = openDatabase(
  join(await getDatabasesPath(), 'naftal_scan.db'));
  final db = await database;

    final List<Map<String, dynamic>> maps = await db.query("Localisation where user_matricule  = '${user.matricule}' ");

       
       return List.generate(maps.length, (i) {
            return Localisation(
               maps[i]['code_bar'],
               maps[i]['date_scan'],
               maps[i]['stockage'],
               maps[i]['user_matricule'],



            );
          });


  }
   static Future<List<Localisation>> synchonized_objects() async{


  User user = await User.auth();
  final database = openDatabase(
  join(await getDatabasesPath(), 'naftal_scan.db'));
  final db = await database;

    final List<Map<String, dynamic>> maps = await db.query("Localisation where stockage  = 0 ");

       
       return List.generate(maps.length, (i) {
            return Localisation(
               maps[i]['code_bar'],
               maps[i]['date_scan'],
               maps[i]['stockage'],
               maps[i]['user_matricule'],



            );
          });


  }




   Soft_Store_Localisation() async{

      try {

           var connectivityResult = await (Connectivity().checkConnectivity());
            final database = openDatabase(
            join(await getDatabasesPath(), 'naftal_scan.db'));
            final db = await database;
    
      
        if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {

          try {
            
         
          User user  =  await User.auth();
          var dio = Dio();

          final response = await dio.get('${IP_ADDRESS}store_operation',
          queryParameters: {"token":user.token,"codeBar":this.code_bar});
          var data = jsonDecode(response.data);
          if(data == "true"){
              
              this.stockage =1;
              db.insert('Localisation', this.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
            

            return true;

          }else{

            this.stockage =0;
            db.insert('Localisation', this.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
            


          }




        }on DioError {

          return false;


          }
        
         } 
        else{

        

        
       
              this.stockage = 0;
              db.insert('Localisation', this.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
            return true;
          
          }
        
        

      }
      
       catch (e) {
        return false;
      }
       
         

  }

  Future<List<Bien_materiel>> get_linked_Object()async{

      final database = openDatabase(
      join(await getDatabasesPath(), 'naftal_scan.db'));
      final db = await database;

      final List<Map<String, dynamic>> maps = await db.query("Bien_materiel where code_localisation  = '${this.code_bar}' ");

        
        return List.generate(maps.length, (i) {
              return Bien_materiel(
                maps[i]['code_bar'],
                maps[i]['etat'],
                maps[i]['date_scan'],
                maps[i]['code_localisation'],
                maps[i]['stockage']


              );
            });
  }
  Future<int> count_linked_object()async{
    List<Bien_materiel> list = await get_linked_Object() ;
    return  list.length;
  }
    @override
  String toString() {
    return 'Localisationcode bar: ${code_bar}';
  }


}