import 'package:database_crud/Database/database.dart';
import 'package:database_crud/Pages/add_page.dart';
import 'package:flutter/material.dart';

class DisplayPage extends StatefulWidget{
  const DisplayPage({super.key});

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Display Employee Detail"),
          backgroundColor: Colors.blue,
          actions: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: InkWell(onTap:() async{
                await Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddPage(null),)).then((value) {
                  setState(() {
                    MyDatabase().getEmployee();
                  });
                });
              },child: Icon(Icons.add,size: 30,)),
            )
          ],
        ),
        body: FutureBuilder<bool>(
          future: MyDatabase().copyPasteAssetFileToRoot(),
          builder: (context,snapshot1) {
            if(snapshot1.hasData){
              return FutureBuilder<List<Map<String,dynamic?>>>(
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      return ListView.builder(
                          itemBuilder: (context, index) {
                            return  Container(
                              height: 50,
                              child: Card(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text((snapshot.data![index]["EmployeeName"]).toString()),
                                    Text((snapshot.data![index]["EmployeeSalary"]).toString()),
                                    Text((snapshot.data![index]["CityName"]).toString()),
                                    Text((snapshot.data![index]["EmployeeID"]).toString()),
                                    InkWell(onTap:() async{
                                      await Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddPage(snapshot.data![index]),)).then((value){
                                        setState(() {

                                        });
                                      });
                                    },child: Icon(Icons.edit,size: 30,)),
                                    InkWell(onTap:() async{
                                      print(snapshot.data![index]["EmployeeID"]);
                                      await deleteEmployee(snapshot.data![index]["EmployeeID"]).then((value) {
                                        setState(() {

                                        });
                                      });
                                    },child: Icon(Icons.delete,size: 30,))
                                  ],
                                ),
                              ),
                            );
                          },
                        itemCount: snapshot.data!.length
                      );
                    }else{
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                  future: MyDatabase().getEmployee(),
              );
            }else{
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Future<int> deleteEmployee(id) async {
    int userId = await MyDatabase().deleteEmployeeInDb(id);
    print("Database : $userId");
    return userId;
  }
}