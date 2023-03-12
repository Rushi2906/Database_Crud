import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';

import '../Model/citymodel.dart';

class MyDatabase{
  Future<Database> initDatabase() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String databasePath = join(appDocDir.path, 'employee_demo.db');
    return await openDatabase(databasePath);
  }

  Future<bool> copyPasteAssetFileToRoot() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "employee_demo.db");

    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      ByteData data = await rootBundle.load(join('assets/Database', 'employee_demo.db'));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
      return true;
    }
    return false;
  }

  Future<List<CityModel>> getCity() async {
    Database db = await initDatabase();
    List<Map<String, Object?>> data =
    await db.rawQuery("Select * From CityMaster");
    print(data);
    List<CityModel> cityList = [];
    for(int i=0;i<data.length;i++){
      CityModel cityModel = CityModel();
      cityModel.City_Id = int.parse(data[i]['CityID'].toString());
      cityModel.City_Name = data[i]['CityName'].toString();
      cityList.add(cityModel);
    }
    print(cityList);
    return cityList;
  }

  Future<List<Map<String,dynamic?>>> getEmployee() async {
    Database db = await initDatabase();
    List<Map<String,dynamic?>> data = await db.rawQuery("select e.EmployeeName,e.EmployeeID,e.EmployeeSalary,c.CityName from EmployeeMaster e inner join CityMaster c on e.CityID=c.CityID");
    return data;
  }

  Future<int> deleteEmployeeInDb(id) async {
    Database db = await initDatabase();
    int userId = await db.delete("EmployeeMaster",where: "EmployeeID = ?",whereArgs: [id]);
    return userId;
  }

  Future<int> insertEmployeeInDb(map) async {
    Database db = await initDatabase();
    int userId = await db.insert("EmployeeMaster", map);
    return userId;
  }

  Future<int> updateUserDetails(map,id) async {
    Database db = await initDatabase();
    int userID =
    await db.update("EmployeeMaster", map, where: "EmployeeID = ?", whereArgs: [id]);
    return userID;
  }
}