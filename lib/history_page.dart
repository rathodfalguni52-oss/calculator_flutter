import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HistoryPage extends StatefulWidget{
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState()=>_HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
{
  List history=[];
  bool isLoading=true;

  final String baseUrl='http://127.0.0.1:5000';
  @override
  void initState(){
    super.initState();
    fetchHistory();
  }
  Future<void> deleteHistoryItem(int id) async{
    final response=await http.delete(
      Uri.parse('$baseUrl/history/$id'),
    );
    if(response.statusCode==200){
      await fetchHistory();
    }
  }
  Future<void> clearAllHistory() async{
    final response=await http.delete(
      Uri.parse('$baseUrl/history'),
    );
    if(response.statusCode==200){
      await fetchHistory();
    }
  }
  Future<void> fetchHistory() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/history'),
      );
      if (response.statusCode == 200) {
        setState(() {
          history = jsonDecode(response.body);
          isLoading = false;
        });
      }
      else {
        setState(() {
          isLoading = false;
        });
      }
    }
    catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

    @override
    Widget build(BuildContext context){
      return Scaffold(
        appBar: AppBar(
          title: Text('Calculation History'),
          backgroundColor: Color(0xFF813B98),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: history.isEmpty?null:() async{
                final confirm=await showDialog(
                    context: context,
                    builder: (context)=>AlertDialog(
                      title: Text('Clear History?'),
                      content: Text('Delete all calculation history?'),
                      actions: [
                        TextButton(
                            onPressed: ()=>Navigator.pop(context,false),
                            child: Text('Cancel'),
                        ),
                        TextButton(
                            onPressed: ()=>Navigator.pop(context,true),
                            child: Text('Delete All')
                        ),
                      ],
                    ),
                );
                if (confirm==true && mounted){
                  await clearAllHistory();
                }
              },
              icon: Icon(Icons.delete_sweep),
            tooltip: 'Clear All History',)
          ],
        ),
        body: isLoading? const Center(
          child: CircularProgressIndicator(),
        ):history.isEmpty?const Center(
          child: Text('No calculation history found'),
        ):ListView.builder(
          itemCount: history.length,
            itemBuilder: (context,index){
            final item=history[index];
            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              child: ListTile(
                leading: const Icon(Icons.calculate,color:Color(0xFF672AB7)
                ),
                title: Text(item['expression'].toString()),
                subtitle: Text('Date:${item['created_at']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('=${item['result']}',style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF813B98)
                    ),
                    ),
                    IconButton(
                        onPressed: () async{
                      final confirm=await showDialog(
                          context: context,
                          builder: (context)=>AlertDialog(
                            title: Text('Delete Calculation?'),
                            content: Text('Delete this calculation from history?'),
                            actions: [
                              TextButton(
                                  onPressed: ()=>Navigator.pop(context,false),
                                  child: Text('Cancel')
                              ),
                              TextButton(onPressed: ()=>Navigator.pop(context,true),
                                  child: Text('Delete')
                              )
                            ],
                          )
                      );
                      if(confirm==true && mounted){
                        await deleteHistoryItem(int.parse(item['id'].toString())
                        );
                      }
                    },
                        icon: Icon(Icons.delete_outline,color: Colors.red)
                    )
                  ],
                )
              ),
            );
            },
            ),
      );
    }
  }
