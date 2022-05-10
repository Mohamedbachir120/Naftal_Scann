import 'package:dio/dio.dart';
import 'package:naftal/data/LoginInfos.dart';
import 'package:naftal/main.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class User {
  late String matricule;
  late  String nom;
  late String COP_ID;
  late  String INV_ID; 
  late String validity;

   User (String matricule,String nom,String COP_ID,String INV_ID,String validity){

     this.matricule = matricule;
     this.nom = nom;
     this.COP_ID = COP_ID;
     this.INV_ID = INV_ID;
     this.validity = validity;
   }

   Map<String, dynamic> toMap() {
    return {
      'matricule': matricule,
      'nom': nom,
      'COP_ID': COP_ID,
      'INV_ID': INV_ID,
      "validity":validity

    };
  }

    static  check_user() async{

        try{
           final database = openDatabase(
          join(await getDatabasesPath(), DBNAME)
          
          );
          final db = await database;

         final List<Map<String, dynamic>> maps = await db.query('User');

        
          
          return maps.length;


        }catch(e){
         
         return 0;

        }

        

    }

  static Future<User> auth() async{

       final database = openDatabase(
          join(await getDatabasesPath(), DBNAME)
          
          );
          final db = await database;

         final List<Map<String, dynamic>> maps = await db.query('User');

          return User(
                  maps[0]['matricule'] ,
                  maps[0]['nom'] ,
                  maps[0]['COP_ID'] ,
                  maps[0]['INV_ID'] ,
                  maps[0]["validity"]
                );


    }
      Future<String> getToken() async {
    try {
    var dio = Dio();
    final response = await dio.post(
      '${IP_ADDRESS}api/auth/signin',
      data: LoginInfo(username: this.matricule, password: "a").toJson(),
    );

    final data = response.data;
    return(data["accessToken"]).toString();
      
    } catch (e) {
      return "";
    }
  }

  @override
  String toString() {
    return 'User{matricule: $matricule, name: $nom}';
  }
}