import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'DateTimePicker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async{
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:MainScreen(),
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



  initializeNotifications() async {
    var initializeAndroid = AndroidInitializationSettings('ic_launcher');
    var initializeIOS = IOSInitializationSettings();
    var initSettings = InitializationSettings(initializeAndroid, initializeIOS);
    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }


  Future singleNotification(
      DateTime datetime, String message, String subtext, int hashcode,
      {String? sound}) async {
    var androidChannel = AndroidNotificationDetails(
      'channel-id',
      'channel-name',
      'channel-description',
      playSound: false,
      sound: RawResourceAndroidNotificationSound('alarm_clock'),
      importance: Importance.Max,
      priority: Priority.Max,
    );

    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(androidChannel, iosChannel);
    flutterLocalNotificationsPlugin.schedule(
        hashcode, message, subtext, datetime, platformChannel,
        payload: hashcode.toString());
  }

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
    fabIndex = 0;
    initializeNotifications();

  }

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
                          MaterialPageRoute(builder: (context) => DateTimePicker(_dateController,_timeController,addDynamic,singleNotification,cardController1)));
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
          _Description(
            title: Text(
              cardCont1.text,
            ),
            description: Text(
              cardCont2.text,
            ),
            date: Text(
              dateController.text,
            ),
            time: Text(
              timeController.text,
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
class CustomListItem extends StatelessWidget {
  const CustomListItem({
    Key? key,
    required this.date,
    required this.time,
  }) : super(key: key);
  final Widget date;
  final Widget time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              flex: 2,
              child: date,
            ),
            Expanded(
              flex: 3,
              child: time,
            ),


        ],
      ),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description({
    Key? key,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
  }) : super(key: key);

  final Widget title;
  final Widget description;
  final Widget date;
  final Widget time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: title,),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
         Container(
            child:description,
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          Container(
            child:CustomListItem(
              date: date,
                time:time,
            ),
          ),
        ],
      ),
    );
  }
}

