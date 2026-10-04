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
      // expression=expression.replaceAll('divide', '/');
      expression=expression.replaceAll(',', '');
      expression=expression.replaceAll('%', '/100');
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
      else if(value=='backspace')
        {
          if(UserInput.isNotEmpty)
            {
              UserInput=UserInput.substring(0,UserInput.length-1);
            }
        }
      else if(value=='%'){
        if(UserInput.isNotEmpty)
          {
            UserInput+='%';
          }
      }
      // else if(value==',') {
      //
      //   }
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
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(result,
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212121)
                        ),),
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
                      calculatorButton('C',backgroundColor: const Color(0xFFEEC2EE)),
                      calculatorButton('backspace',backgroundColor: Color(0xFFEEC2EE),icon: Icons.backspace),
                      calculatorButton('%',backgroundColor: Color(0xFFEEC2EE)),
                      calculatorButton('/',backgroundColor: Color(0xFF813B98),
                      foregroundColor: Colors.white,
                      icon: CupertinoIcons.divide),
                      calculatorButton('7'),
                      calculatorButton('8'),
                      calculatorButton('9'),
                      calculatorButton('X',backgroundColor: Color(0xFF813B98),foregroundColor: Colors.white,
                      icon: CupertinoIcons.multiply),
                      calculatorButton('4'),
                      calculatorButton('5'),
                      calculatorButton('6'),
                      calculatorButton('-',
                      backgroundColor: Color(0xFF813B98),
                      foregroundColor: Colors.white,
                      icon: CupertinoIcons.minus),
                      calculatorButton('1'),
                      calculatorButton('2'),
                      calculatorButton('3'),
                      calculatorButton('+',backgroundColor: Color(0xFF813B98),
                      foregroundColor: Colors.white,
                      icon: CupertinoIcons.plus),
                      calculatorButton(','),
                      calculatorButton('0'),
                      calculatorButton('.'),
                      calculatorButton('=',backgroundColor: Color(0xFF813B98),
                      foregroundColor: Colors.white,
                      icon: CupertinoIcons.equal),
                    ],
                  ),)
                )
          )
        ],
      )
    );
  }
  Widget calculatorButton(String value,{
        Color backgroundColor=Colors.white,
        Color foregroundColor=const Color(0xFF1D192B),
        IconData? icon,
  })
  {
    return ElevatedButton
      (onPressed: () {
      buttonPressed(value);
    },
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: CircleBorder(),
          elevation: 2,
        ),
        child: icon!=null? Icon(icon,size: 30):Text(value,style: TextStyle(fontSize: 30),)
    );
  }

}
