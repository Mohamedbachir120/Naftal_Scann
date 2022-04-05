import 'package:naftal/main.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class User {
  late String matricule;
  late  String nom;
  late String COP_ID;
  late  String INV_ID; 

   User (String matricule,String nom,String COP_ID,String INV_ID){

     this.matricule = matricule;
     this.nom = nom;
     this.COP_ID = COP_ID;
     this.INV_ID = INV_ID;
   }

   Map<String, dynamic> toMap() {
    return {
      'matricule': matricule,
      'nom': nom,
      'COP_ID': COP_ID,
      'INV_ID': INV_ID
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

          List<User> users = List.generate(maps.length, (i) {
            return User(
                  maps[i]['matricule'] ,
                  maps[i]['nom'] ,
                  maps[i]['COP_ID'] ,
                  maps[i]['INV_ID'] ,
                );
          });
          
          return users[0];


    }

  @override
  String toString() {
    return 'User{matricule: $matricule, name: $nom}';
  }
}