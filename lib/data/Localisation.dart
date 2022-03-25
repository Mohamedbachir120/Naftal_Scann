
import 'package:naftal/data/Bien_materiel.dart';
import 'package:naftal/data/User.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Localisation {


  late final  String code_bar;
  String ?designation;
  String ?date_scan;
  // Par défaut le fichier sera stocké localement
  // 0 localement 
  // 1 Sur serveur
  
  int stockage = 0;
  late final String user_matricule; 


  // Constructeur
  Localisation(String code_bar,String designation,String date_scan,int stockage,String user_matricule){
    this.code_bar = code_bar;
    this.designation = designation;
    this.date_scan = date_scan;
    this.stockage = stockage;
    this.user_matricule = user_matricule;
  }
  // Maping pour l'insertion dans la base de donnés
   Map<String, dynamic> toMap() {
    return {
      'code_bar': code_bar,
      'designation': designation,
      'date_scan': date_scan,
      'stockage': stockage,
      'user_matricule':user_matricule
    };
  }

  Future<bool> exists() async{

   final database = openDatabase(
         join(await getDatabasesPath(), 'naftal_scan.db'));
         final db = await database;

           final List<Map<String, dynamic>> maps = await db.query("Localisation where code_bar  = '$code_bar' ");

       

    
    return (maps.length > 0);


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
               maps[i]['designation'],
               maps[i]['date_scan'],
               maps[i]['stockage'],
               maps[i]['user_matricule'],


            );
          });


  }

   Store_Localisation() async{

      try {

         final database = openDatabase(
         join(await getDatabasesPath(), 'naftal_scan.db'));
         final db = await database;
    
          bool exist = await this.exists();
         
          if(exist == false){

              db.insert('Localisation', this.toMap(),conflictAlgorithm: ConflictAlgorithm.abort);
            return true;
          }else{
            return false;
          }
         

        
        

      }
      
       catch (e) {
        return false;
      }

  }


   Soft_Store_Localisation() async{

      try {

         final database = openDatabase(
         join(await getDatabasesPath(), 'naftal_scan.db'));
         final db = await database;
    
       

              db.insert('Localisation', this.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
            return true;
          

        
        

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
                maps[i]['designation'],
                maps[i]['etat'],
                maps[i]['date_scan'],
                maps[i]['code_localisation'],


              );
            });
  }
  Future<int> count_linked_object()async{
    List<Bien_materiel> list = await get_linked_Object() ;
    return  list.length;
  }
    @override
  String toString() {
    return 'Localisation{code bar: $code_bar, designation: $designation}';
  }


}