import 'dart:isolate';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'DateTimePicker.dart';

void main() => runApp(MyApp());



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Home(),
    );
  }
}
class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text("Remind Me"),
        backgroundColor:Colors.green[600],
      ),
      body:Center(
        child:Column(
            mainAxisAlignment:MainAxisAlignment.center,crossAxisAlignment:CrossAxisAlignment.center,
            children: <Widget>[
              Container(

                child:ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=>LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green[600],
                    padding:EdgeInsets.symmetric(horizontal:25.0,vertical:5.0),
                  ),
                  child: Text('Login'),
                ),
              ),

            ]
        ),
      ),
    );
  }
}




class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final  myController = TextEditingController();
  final myController2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text("Remind Me"),
        backgroundColor:Colors.green[600],
      ),
      body:Center(
        child:Column(
            mainAxisAlignment:MainAxisAlignment.center,
            crossAxisAlignment:CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding:EdgeInsets.symmetric(horizontal:15.0,vertical:5.0),
                child:TextField(
                  controller: myController,
                  decoration:InputDecoration(
                    labelText:'Enter Email',
                  ),

                ),
              ),
              Container(
                padding:EdgeInsets.symmetric(horizontal:15.0,vertical:5.0),
                child:TextField(
                  controller: myController2,
                  decoration:InputDecoration(
                    labelText:'Enter Password',
                  ),
                ),
              ),
              Container(

                child:ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=>MainScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green[600],
                    padding:EdgeInsets.symmetric(horizontal:25.0,vertical:5.0),
                  ),
                  child: Text('Login'),
                ),
              ),
            ]
        ),
      ),
    );
  }
}



class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final cardController1 = TextEditingController();
  final cardController2 = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  List<CardView> dynamicWidget =[];
  var fabIndex;
  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'Tasks'),
    Tab(text: 'Feed'),
    Tab(text: 'Clubs'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this, initialIndex: 0);
    _tabController.addListener(updateIndex);
    fabIndex = 0;}
  void removeCard(index)
  {
    setState(() {
      dynamicWidget.remove(index);
    });
  }

  addDynamic(_dateController, _timeController){
    setState((){ });
    dynamicWidget.add(new CardView(cardController1,cardController2,_dateController,_timeController,dynamicWidget,removeCard));

  }
  @override
  void dispose() {
    _tabController.removeListener(updateIndex);
    _tabController.dispose();
    cardController2.dispose();
    cardController1.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }


  Widget getFab() {
    if (fabIndex == 0) {
      return FloatingActionButton(
        onPressed:(){
          showDialog(
            context:context,
            builder:(BuildContext context)
            {
              return AlertDialog(
                scrollable: true,
                title: Text('Add Task'),
                content: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: cardController1,
                          decoration: InputDecoration(
                            labelText: 'Title',
                          ),
                        ),
                        TextFormField(
                          controller: cardController2,
                          decoration: InputDecoration(
                            labelText: 'Description',
                          ),

                        ),

                      ],
                    ),
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: ()
                    {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DateTimePicker(_dateController,_timeController,addDynamic)));
                      Navigator.pop(context);
                    },
                    child: Text('Continue'),
                  ),
                ],
              );

            },
          );
        },
        child: Icon(Icons.add),
      );
    }
    else {
      return Container();
    }
  }

  void updateIndex() {
    setState(() {
      fabIndex = _tabController.index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        bottom:TabBar(
          controller:_tabController,
          tabs: myTabs,
        ),


        title: Text("Remind Me"),
        backgroundColor: Colors.green[600],
      ) ,
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Container(
              child:ListView.builder(
                itemCount: dynamicWidget.length,
                itemBuilder: (_,index) => dynamicWidget[index],
              )


          ),
          Container(),
          Container(),
        ],
      ),
      floatingActionButton: getFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }


}

class CardView extends StatelessWidget {
  CardView( this.cardCont1, this.cardCont2,this.dateController,this.timeController, this.dynList, this.removeCard, {Key? key}) : super(key: key);
  final TextEditingController cardCont1 ;
  final TextEditingController cardCont2 ;
  final TextEditingController dateController ;
  final TextEditingController timeController ;
  final List<CardView> dynList ;
  final Function(CardView) removeCard;

  @override
  Widget build(BuildContext context) {

    return Card(
      child:Column(
        children:<Widget>[
          ListTile(
            title: Text(
              cardCont1.text,
            ),
            subtitle: Text(
              cardCont2.text,
            ),
            trailing: Text(
              dateController.text,
            ),
          ),
          Container(
            child: IconButton(
              icon:Icon(Icons.delete,
              ),
              onPressed: (){
                removeCard(this);

              },
            ),
          ),
        ],

      ),
    );
  }
}
class FunctionClass extends StatelessWidget {
  const FunctionClass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

