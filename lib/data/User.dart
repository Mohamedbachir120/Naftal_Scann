import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class User {
  late String matricule;
   String ?nom;
   String ?prenom;
   String ?email;
   String ?token; 

   User (String matricule,String nom,String prenom,String email,String ?token){

     this.matricule = matricule;
     this.nom = nom;
     this.prenom = prenom;
     this.email = email;
     this.token = token;
   }

   Map<String, dynamic> toMap() {
    return {
      'matricule': matricule,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'token': token
    };
  }

    static  check_user() async{

        try{
           final database = openDatabase(
          join(await getDatabasesPath(), 'naftal_scan.db')
          
          );
          final db = await database;

         final List<Map<String, dynamic>> maps = await db.query('User');

          List<User> users = List.generate(maps.length, (i) {
            return User(
                  maps[i]['matricule'] ,
                  maps[i]['nom'] ,
                  maps[i]['prenom'] ,
                  maps[i]['email'] ,
                  maps[i]['token'] ,
                );
          });
          
          return users.length;


        }catch(e){
         
         return 0;

        }

        

    }

  static Future<User> auth() async{

       final database = openDatabase(
          join(await getDatabasesPath(), 'naftal_scan.db')
          
          );
          final db = await database;

         final List<Map<String, dynamic>> maps = await db.query('User');

          List<User> users = List.generate(maps.length, (i) {
            return User(
                  maps[i]['matricule'] ,
                  maps[i]['nom'] ,
                  maps[i]['prenom'] ,
                  maps[i]['email'] ,
                  maps[i]['token'] ,
                );
          });
          
          return users[0];


    }

  @override
  String toString() {
    return 'User{matricule: $matricule, name: $nom, prenom: $prenom}';
  }
}