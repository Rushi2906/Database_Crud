import 'package:database_crud/Database/database.dart';
import 'package:database_crud/Model/citymodel.dart';
import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  AddPage(this.map ,{super.key});

  Map<String, Object?>? map;

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  bool isCitySelected = true;
  late CityModel _ddSelectedValue;
  TextEditingController nameController = TextEditingController();
  TextEditingController salaryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.map == null ? "" : widget.map!['EmployeeName'].toString();
    salaryController.text = widget.map == null ? "" : widget.map!["EmployeeSalary"].toString();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.map?["EmployeeID"] == null ? "Add User": "Update User"),
            backgroundColor: Colors.blue,
            leading: InkWell(onTap: () {
              Navigator.pop(context);
            }, child: Icon(Icons.arrow_back, size: 30,)),
          ),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: FutureBuilder<List<CityModel>>(
                  future: isCitySelected ? MyDatabase().getCity() : null,
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      if(isCitySelected){
                        _ddSelectedValue = snapshot.data![0];
                        isCitySelected=false;
                      }
                      return DropdownButton(
                        value: _ddSelectedValue,
                        items: snapshot.data!.map((CityModel e) {
                          return DropdownMenuItem(
                            value: e,
                              child: Text(
                                  e.City_Name.toString()
                              )
                          );
                        }).toList(),
                        onChanged: (value){
                          setState(() {
                            _ddSelectedValue = value!;
                          });
                        },
                      );
                    }else{
                      return Container();
                    }
                  },),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "Enter Employee Name",
                      labelText: "Employee Name"
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  child: TextFormField(
                    controller: salaryController,
                    decoration: InputDecoration(
                        hintText: "Enter Employee Salary",
                        labelText: "Employee Salary",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              Container(
                child: TextButton(
                  child: Text(widget.map?["EmployeeID"]==null ?"Add" : "Edit"),
                  onPressed: () {
                      setState(() {
                        if(widget.map==null){
                          insertEmployee().then((value) => Navigator.of(context).pop(true));  
                        }else{
                          updateUser(widget.map!["EmployeeID"]).then((value) => Navigator.of(context).pop());
                        }
                      });
                  },
                ),
              )
            ],
          ),
        )
    );
  }

  Future<int> insertEmployee() async {
    Map<String,dynamic> map = {};
    map['EmployeeName']=nameController.text;
    map['EmployeeSalary']=salaryController.text;
    map['CityID']=_ddSelectedValue.City_Id!;

    int userId = await MyDatabase().insertEmployeeInDb(map);
    return userId;
  }

  Future<int> updateUser(id) async {
    Map<String, dynamic> map = {};
    map["EmployeeName"] = nameController.text;
    map["EmployeeSalary"] = salaryController.text;
    map["CityID"] = _ddSelectedValue.City_Id!;

    int userID = await MyDatabase().updateUserDetails(map, id);
    return userID;
  }
}
