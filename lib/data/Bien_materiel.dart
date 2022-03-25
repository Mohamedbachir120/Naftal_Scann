import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Bien_materiel{

  late final  String code_bar;
  String ?designation;
  String ?date_scan;
  
  /*
  état 1 = mauvais 
  état 2 = moyen 
  état 3 = Bon 

  */ 

  int etat = 3;
  late String code_localisation ;

  Bien_materiel(String code_bar,String designation,int etat,String date_scan,String code_localisation){
    this.code_bar = code_bar;
    this.designation = designation;
    this.etat = etat;
    this.date_scan = date_scan;
    this.code_localisation =  code_localisation;

  }

    Map<String, dynamic> toMap() {
    return {
      'code_bar': code_bar,
      'designation': designation,
      'etat': etat,
      'date_scan': date_scan,
      'code_localisation':code_localisation
    };
  }

    Future<bool> exists() async{

   final database = openDatabase(
         join(await getDatabasesPath(), 'naftal_scan.db'));
         final db = await database;

           final List<Map<String, dynamic>> maps = await db.query("Bien_materiel where code_bar  = '$code_bar' ");

       

    
    return (maps.length > 0);


  }
  String get_state(){
    switch(this.etat){
      case 1: return "Mauvais";
      case 2: return "Moyen";
      case 3: return "Bon";

    }

    return "";

  }
  Store_Bien() async{

      try {

         final database = openDatabase(
         join(await getDatabasesPath(), 'naftal_scan.db'));
         final db = await database;
    
          bool exist = await this.exists();
         
          if(exist == false){

              db.insert('Bien_materiel', this.toMap(),conflictAlgorithm: ConflictAlgorithm.abort);
            return true;
          }else{
            return false;
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
    
          bool exist = await this.exists();
         

              db.insert('Bien_materiel', this.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
            return true;
          
      }
       catch (e) {
        return false;
      }
  }




  
}