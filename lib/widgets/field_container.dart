
import 'package:flutter/material.dart';


class FieldContainer extends StatelessWidget {
  final text;
  final Icon? icon;
  FieldContainer({
    Key? key,
    required this.text,  this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 65,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),

      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Card(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                children:[ Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      text,style: TextStyle(color: Colors.grey,fontSize: 15),
                    ),
                  ),
                ),
                 icon != null ? Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                   child: icon!,
                 ) : Container()
              ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}
