import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:naftal/all_objects.dart';
import 'package:naftal/data/Bien_materiel.dart';
import 'package:naftal/data/Localisation.dart';
import 'package:naftal/data/User.dart';
import 'package:naftal/detail_bien.dart';
import 'package:naftal/detail_operation.dart';
import 'package:naftal/history.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:naftal/mode_manuel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'main.dart';

void main() => runApp(MyApp());

bool check_format(int type, String value) {
  if (type == 0) {
    // Expression réguliére pour les localisations

    final localisation = RegExp(r'^([A-Z]|[0-9]){4}L[0-9]{6,8}$');
    final localisation2 = RegExp(r'^K[0-9]{4}L[0-9]{5}$');

    return localisation.hasMatch(value) || localisation2.hasMatch(value);
  } else if (type == 1) {
    // Expression réguliére pour les bien Matériaux

    final BienMateriel = RegExp(r'^[A-Z]([0-9]|[A-Z]){9,14}$');

    return BienMateriel.hasMatch(value);
  }
  return true;
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  String _scanBarcode = '';

  static const Color blue = Color.fromRGBO(0, 73, 132, 1);
  static const Color yellow = Color.fromRGBO(255, 227, 24, 1);

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print('Couldn\'t check connectivity status' + e.toString());
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  Future<void> scanBarcodeNormal(BuildContext context) async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });

    if (check_format(0, _scanBarcode) == false) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.info, color: Colors.white, size: 25),
            Text(
              "Opération échouée objet non valide",
              style: TextStyle(fontSize: 17.0),
            ),
          ],
        ),
        backgroundColor: Colors.red,
      ));
    } else {
      User user = await User.auth();
      Localisation loc = Localisation(
          _scanBarcode, DateTime.now().toIso8601String(), " ", user.COP_ID);

      loc.exists().then((exist) async {
        if (exist == true) {
          Localisation localisation =
              await Localisation.get_localisation(_scanBarcode);

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Detail_Operation(
                      localisation: localisation,
                    ),
                settings: RouteSettings()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.info, color: Colors.white, size: 25),
                Text(
                  "Localité inexistante",
                  style: TextStyle(fontSize: 17.0),
                ),
              ],
            ),
            backgroundColor: Colors.red,
          ));
        }
      });
    }
  }

  Future<void> poursuivre_operation(BuildContext context) async {
    List<Bien_materiel> biens = await Bien_materiel.history();

    if (biens.length >= 1) {
      Localisation localisation =
          await Localisation.get_localisation(biens.last.code_localisation);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Detail_Bien(
            bien_materiel: biens.last,
            localisation: localisation,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.info, color: Colors.white, size: 25),
            Text(
              "Vous n'avez aucune opération précédente",
              style: TextStyle(fontSize: 17.0),
            ),
          ],
        ),
        backgroundColor: Colors.red,
      ));
      scanBarcodeNormal(context);
    }
  }

  void synchronize(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.sync, color: Colors.black87, size: 25),
          Text(
            "Synchronisation en cours",
            style: TextStyle(fontSize: 17.0, color: Colors.black87),
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 214, 214, 214),
    ));
    List<Bien_materiel> objects = await Bien_materiel.synchonized_objects();
    Dio dio = Dio();
    final response =
        await dio.post('${IP_ADDRESS}save_many', data: jsonEncode(objects));

    if (response.toString() == "true") {
      final database = openDatabase(join(await getDatabasesPath(), DBNAME));
      final db = await database;
      await db.rawUpdate(
          "UPDATE Bien_materiel SET stockage = 1 where stockage = 0");

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.check, color: Colors.white, size: 25),
            Text(
              "Synchronisation effectuée avec succès",
              style: TextStyle(fontSize: 17.0, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.green,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.info, color: Colors.white, size: 25),
            Text(
              "une erreur est survenue veuillez réessayer",
              style: TextStyle(fontSize: 17.0),
            ),
          ],
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context1) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Naftal Scanner',
            style: TextStyle(color: yellow),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Builder(builder: ((context) {
                switch (_connectionStatus) {
                  case ConnectivityResult.mobile:
                    return IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    TextButton.icon(
                                        style: TextButton.styleFrom(
                                            backgroundColor: Colors.green),
                                        onPressed: () {
                                          Navigator.pop(dialogContext);
                                          synchronize(context1);
                                        },
                                        icon: Icon(Icons.sync_sharp,
                                            size: 20, color: Colors.white),
                                        label: Text(
                                          "synchroniser les données",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ))
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.network_cell),
                    );
                  case ConnectivityResult.wifi:
                    return IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              return AlertDialog(
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      TextButton.icon(
                                          style: TextButton.styleFrom(
                                              backgroundColor: Colors.green),
                                          onPressed: () {
                                            Navigator.pop(dialogContext);
                                            synchronize(context1);
                                          },
                                          icon: Icon(Icons.sync_sharp,
                                              size: 20, color: Colors.white),
                                          label: Text(
                                            "synchroniser les données",
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ))
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.wifi));
                  default:
                    return Icon(Icons.wifi_off_sharp);
                }
              })),
            )
          ],
          backgroundColor: blue,
        ),
        body: Builder(builder: (BuildContext context) {
          return SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Icon(
                          Icons.list_alt,
                          color: blue,
                        ),
                        Text(
                          "  MES OPÉRATIONS",
                          style: TextStyle(color: blue, fontSize: 20.0),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.circular(7),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 3,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () => scanBarcodeNormal(context),
                      child: Column(children: [
                        Icon(
                          Icons.camera_alt,
                          size: 30,
                          color: blue,
                        ),
                        Text(
                          'Scanner localité',
                          style: TextStyle(color: blue, fontSize: 18.0),
                        )
                      ]),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.circular(7),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 3,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ModeManuel()),
                        );
                      },
                      child: Column(children: [
                        Icon(
                          Icons.edit,
                          size: 30,
                          color: blue,
                        ),
                        Text(
                          'Saisir code bar',
                          style: TextStyle(color: blue, fontSize: 18.0),
                        )
                      ]),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.circular(7),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 3,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: TextButton(
                      child: Column(
                        children: [
                          Icon(
                            Icons.arrow_circle_right_outlined,
                            color: blue,
                            size: 30,
                          ),
                          Text(
                            'Poursuivre la derniére opération',
                            style: TextStyle(color: blue, fontSize: 18.0),
                          )
                        ],
                      ),
                      onPressed: () {
                        poursuivre_operation(context);
                      },
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.circular(7),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 3,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: TextButton(
                      child: Column(children: [
                        Icon(
                          Icons.history,
                          color: blue,
                          size: 30,
                        ),
                        Text(
                          'Historique des opérations',
                          style: TextStyle(color: blue, fontSize: 18),
                        )
                      ]),
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => History()),
                        )
                      },
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.circular(7),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 3,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: TextButton(
                      child: Column(children: [
                        Icon(
                          Icons.library_books,
                          color: blue,
                          size: 30,
                        ),
                        Text(
                          'Consulter toutes les localités',
                          style: TextStyle(color: blue, fontSize: 18.0),
                        )
                      ]),
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => All_objects()),
                        );
                      },
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.circular(7),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 3,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: TextButton(
                      child: Column(children: [
                        Icon(
                          Icons.refresh,
                          color: blue,
                          size: 30,
                        ),
                        Text(
                          'Réinitialiser',
                          style: TextStyle(color: blue, fontSize: 18.0),
                        )
                      ]),
                      onPressed: () async {
                        final database = openDatabase(
                            join(await getDatabasesPath(), DBNAME));
                        final db = await database;
                        await db.execute("DELETE FROM Bien_materiel;");
                        await db.execute("DELETE FROM User;");

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.check, color: Colors.white, size: 25),
                              Text(
                                "Données réinitialisées avec succès",
                                style: TextStyle(
                                    fontSize: 17.0, color: Colors.white),
                              ),
                            ],
                          ),
                          backgroundColor: Colors.green,
                        ));

                        // Navigator.pushAndRemoveUntil(
                        //   context,
                        //   MaterialPageRoute(builder: (context) =>  ChoixStructure()),
                        //   ModalRoute.withName('/operations'),
                        // );
                      },
                    ),
                  ),
                ]),
          ));
        }));
  }
}
// ignore_for_file: prefer_const_constructors