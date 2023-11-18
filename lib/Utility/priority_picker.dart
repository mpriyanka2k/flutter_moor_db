import 'package:flutter/material.dart';

class PriorityPicker extends StatefulWidget {
  int index;
  Function(int) onTap;

  PriorityPicker(this.index, this.onTap, {super.key});

  @override
  State<StatefulWidget> createState() => PriorityPickerState();
}

class PriorityPickerState extends State<PriorityPicker> {
  List<String> nameList = ['Low', 'High', 'Very High'];
  List<Color> colorList = [
    Colors.green,
    Colors.teal,
    Colors.red,
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: nameList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              widget.index = index;
              widget.onTap(index);
              setState(() {});
            },
            child: Container(
              margin: EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color:
                      widget.index == index ? colorList[index] : Colors.white,
                  border: Border.all(
                    color: Colors.black,
                  )),
              width: MediaQuery.of(context).size.width / 3.3,
              child: Center(
                  child: Text(
                nameList[index],
                style: TextStyle(
                    color: widget.index == index ? Colors.white : Colors.black),
              )),
            ),
          );
        },
      ),
    );
  }
}
