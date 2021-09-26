import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';



class DateTimePicker extends StatefulWidget {
  const DateTimePicker(this._dateController,this._timeController,this.addDynamic,this.singleNotification,this.title, {Key? key}) : super(key: key);
  final TextEditingController _dateController;
  final TextEditingController _timeController;
  final Function addDynamic;
  final Function singleNotification;
  final TextEditingController title;

  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  late double _height = 0;
  late double _width= 0;
  late String _hour, _minute, _time;
  late String dateTime;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour:00, minute:00);
  Future<Null> _selectDate(BuildContext context) async{
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2020),
        lastDate: DateTime(2101));
    if(picked!= null)
      setState((){
        selectedDate = picked;
        widget._dateController.text= DateFormat.yMd().format(selectedDate);
      });
  }
  Future<Null> _selectTime(BuildContext context) async{
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedTime);
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ':' + _minute ;
        widget._timeController.text = formatDate(
            DateTime(2019,08,1, selectedTime.hour,
                selectedTime.minute),
            [hh, ':',nn ,"", am]
        ).toString();
      });
  }

  @override
  void initState(){
    widget._dateController.text = DateFormat.yMd().format(DateTime.now());
    widget._timeController.text= formatDate(DateTime(2019,08,1,DateTime.now().hour, DateTime.now().minute),
        [hh, ':' , nn, "", am]).toString();
    super.initState();
  }
  @override
  Widget build(BuildContext context){
    String? _setTime, _setDate;
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    dateTime = DateFormat.yMd().format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        title:Text("Remind Me"),
        backgroundColor:Colors.green[600],
      ),
      body: Container(
        width: _width,
        height: _height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text('Choose Date'),
                InkWell(
                  onTap: (){
                    _selectDate(context);
                  },
                  child: Container(
                    width: _width/1.7,
                    height: _height/9,
                    margin: EdgeInsets.only(top:30),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.grey[200]
                    ),
                    child: TextFormField(
                      style: TextStyle(fontSize: 30),
                      textAlign: TextAlign.center,
                      onSaved: (String? val){
                        _setDate = val;
                      },
                      enabled: false,

                      keyboardType: TextInputType.text,
                      controller: widget._dateController,
                      decoration: InputDecoration(
                        disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        labelText: 'Date',
                        contentPadding: EdgeInsets.all(5),
                      ),
                    ),
                  ),
                ),
                Text('Choose Time'),
                InkWell(
                  onTap: (){
                    _selectTime(context);
                  },
                  child: Container(
                    width: _width/1.7,
                    height: _height/9,
                    margin: EdgeInsets.only(top:30),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.grey[200]
                    ),
                    child: TextFormField(
                      style: TextStyle(fontSize: 30),
                      textAlign: TextAlign.center,
                      onSaved: (String? val){
                        _setTime = val;
                      }, enabled: false,

                      keyboardType: TextInputType.text,
                      controller: widget._timeController,
                      decoration: InputDecoration(
                        disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        labelText: 'Time',
                        contentPadding: EdgeInsets.all(5),
                      ),
                    ),
                  ),
                ),
                Container(
                  child:ElevatedButton(
                    onPressed: ()
                    async { DateTime now = DateTime(selectedDate.year,selectedDate.month,selectedDate.day,selectedTime.hour,selectedTime.minute).toUtc().add(
                      Duration(seconds: 10),
                    );
                    await widget.singleNotification(
                         now,
                        "Notification",
                        widget.title.text,
                        98123871,
                    );
                      Navigator.of(context).pop(
                          {"dateController":widget._dateController,"timeController":widget._timeController}
                      );
                      widget.addDynamic(widget._dateController,widget._timeController);
                    },
                    child: Text('Add'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
