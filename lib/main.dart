import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String UserInput='';
  String result='0';

  void calculateResult(){
    try{
      String expression=UserInput;
      expression=expression.replaceAll('X', '*');
      expression=expression.replaceAll('divide', '/');
      Parser parser=Parser();
      Expression exp=parser.parse(expression);
      ContextModel contextModel=ContextModel();
      double answer=exp.evaluate(EvaluationType.REAL, contextModel);
      setState(() {
        result=answer.toString();
      });
    }
    catch(e){
      setState(() {
        result='Error';
      });
    }
  }
  void buttonPressed(String value){
    setState(() {
      if (value=='C'){
        UserInput='';
        result='0';
      }
      else if(value=='='){
        calculateResult();
      }
      else if(value=='%'){
        // UserInput=value;
      }
      else{
        UserInput+=value;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF813B98),
        elevation: 0,
        leading: Icon(Icons.calculate,color: Colors.white,size: 40),
        title: Text('Calculator',style: TextStyle(
          color: Colors.white,
        ),),
        actions: [
          Padding(padding: EdgeInsetsGeometry.all(10),
          child: Icon(Icons.menu,color: Colors.white))
        ],
      ),
      body:Column(
        children: [
          Expanded(
            flex: 1,
            child:
            Container(
              //height: 100,
              width: double.infinity,
              color: Color(0xFFE7CFE7),
              child: Padding(
                  padding: EdgeInsetsGeometry.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(UserInput,style: const TextStyle(fontSize: 24,color: Colors.grey),),
                      SizedBox(height: 10,),
                      Text(result,style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF212121)
                      ),
                      )
                    ],
                  )
              ),
            ),
          ),
          Expanded(
            flex: 3,
              child: Container(
                  color: Color(0xFFF6E3F6),
                  height: 200,
                  width: double.infinity,
                  // color: Color(0xFFF3EDF7),
                  child: Padding(padding: EdgeInsetsGeometry.all(15),
                  child: GridView.count(crossAxisCount: 4,
                    mainAxisSpacing: 35,
                    crossAxisSpacing: 20,
                    children: [
                      ElevatedButton(onPressed: (){
                        buttonPressed('C');
                      },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFEEC2EE),
                              foregroundColor: Color(0xFF1D192B),
                              shape: CircleBorder(),
                              elevation: 2
                          ),
                          child: Text('C',style: TextStyle(
                              fontSize: 30
                          ),)
                      ),
                      ElevatedButton(onPressed: (){
                        buttonPressed('<');
                      },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFEEC2EE),
                              foregroundColor: Color(0xFF1D192B),
                              shape: CircleBorder(),
                              elevation: 2
                          ),
                          child: Icon(Icons.backspace,size: 30)
                      ),
                      ElevatedButton(onPressed: (){
                        buttonPressed('%');
                      },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFEEC2EE),
                              foregroundColor: Color(0xFF1D192B),
                              shape: CircleBorder(),
                              elevation: 2
                          ),
                          child: Text('%',style: TextStyle(
                              fontSize: 30
                          ),)
                      ),
                      ElevatedButton(onPressed: (){
                        buttonPressed('divide');
                      },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF813B98),
                              foregroundColor: Colors.white,
                              shape: CircleBorder(),
                              elevation: 2
                          ),
                          child: Icon(CupertinoIcons.divide,size: 30)),
                      ElevatedButton(onPressed: (){
                        buttonPressed('7');
                      },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF1D192B),
                              shape: CircleBorder(),
                              elevation: 2
                          ),
                          child: Text('7',style: TextStyle(
                              fontSize: 30
                          ),)
                      ),
                      ElevatedButton(onPressed: (){
                        buttonPressed('8');
                      },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF1D192B),
                              shape: CircleBorder(),
                              elevation: 2
                          ),
                          child: Text('8',style: TextStyle(fontSize: 30))
                      ),
                      ElevatedButton(onPressed: (){
                        buttonPressed('9');
                      },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF1D192B),
                              shape: CircleBorder(),
                              elevation: 2
                          ),
                          child: Text('9',style: TextStyle(
                              fontSize: 30
                          ),)
                      ),
                      ElevatedButton(onPressed: (){
                        buttonPressed('X');
                      },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF813B98),
                              foregroundColor: Colors.white,
                              shape: CircleBorder(),
                              elevation: 2
                          ),
                          child: Icon(CupertinoIcons.multiply,size: 30)),
                      ElevatedButton(onPressed: (){
                        buttonPressed('4');
                      },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF1D192B),
                              shape: CircleBorder(),
                              elevation: 2
                          ),
                          child: Text('4',style: TextStyle(
                              fontSize: 30
                          ),)
                      ),
                      ElevatedButton(onPressed: (){
                        buttonPressed('5');
                      },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF1D192B),
                              shape: CircleBorder(),
                              elevation: 2
                          ),
                          child: Text('5',style: TextStyle(fontSize: 30))
                      ),
                      ElevatedButton(onPressed: (){
                        buttonPressed('6');
                      },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF1D192B),
                              shape: CircleBorder(),
                              elevation: 2
                          ),
                          child: Text('6',style: TextStyle(
                              fontSize: 30
                          ),)
                      ),
                      ElevatedButton(onPressed: (){
                        buttonPressed('-');
                      },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF813B98),
                              foregroundColor: Colors.white,
                              shape: CircleBorder(),
                              elevation: 2
                          ),
                          child: Icon(CupertinoIcons.minus,size: 30)),
                      ElevatedButton(onPressed: (){
                        buttonPressed('1');
                      },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF1D192B),
                              shape: CircleBorder(),
                              elevation: 2
                          ),
                          child: Text('1',style: TextStyle(
                              fontSize: 30
                          ),)
                      ),
                      ElevatedButton(onPressed: (){
                        buttonPressed('2');
                      },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF1D192B),
                              shape: CircleBorder(),
                              elevation: 2
                          ),
                          child: Text('2',style: TextStyle(fontSize: 30),)
                      ),
                      ElevatedButton(onPressed: (){
                        buttonPressed('3');
                      },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF1D192B),
                              shape: CircleBorder(),
                              elevation: 2
                          ),
                          child: Text('3',style: TextStyle(
                              fontSize: 30
                          ),)
                      ),
                      ElevatedButton(onPressed: (){
                        buttonPressed('+');
                      },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF813B98),
                              foregroundColor: Colors.white,
                              shape: CircleBorder(),
                              elevation: 2
                          ),
                          child: Icon(CupertinoIcons.plus,size: 30)),
                      ElevatedButton(onPressed: (){
                        buttonPressed('0');
                      },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF1D192B),
                              shape: CircleBorder(),
                              elevation: 2
                          ),
                          child: Text('0',style: TextStyle(
                              fontSize: 30
                          ),)
                      ),
                      ElevatedButton(onPressed: (){
                        buttonPressed('0');
                      },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Color(0xFF1D192B),

                          ),
                          child: Text('0',style: TextStyle(
                              fontSize: 30
                          ),)
                      ),
                      ElevatedButton(onPressed: (){
                        buttonPressed('.');
                      },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF1D192B),
                              shape: CircleBorder(),
                              elevation: 2
                          ),
                          child: Text('.',style: TextStyle(
                              fontSize: 30
                          ),)
                      ),
                      ElevatedButton(onPressed: (){
                        buttonPressed('=');
                      },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF813B98),
                              foregroundColor: Colors.white,
                              shape: CircleBorder(),
                              minimumSize: Size(72, 72),
                              elevation: 0
                          ),
                          child: Icon(CupertinoIcons.equal,size: 30)),
                    ],
                  ),)
                )
          )
        ],
      )
    );
  }
}
