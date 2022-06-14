import 'package:flutter/material.dart';
import 'package:flutter_pokedex/app/presentation/components/common/common_widgets.dart';
import 'package:flutter_pokedex/app/presentation/components/form/input.dart';

class TeamNameDialog extends StatelessWidget {
  final Function()? onPressed;
  final Function()? onClosed;
  final Function(String)? onSaved;
  final FocusNode? focusNode;

  const TeamNameDialog(
      {Key? key, this.onPressed, this.onClosed, this.onSaved, this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 6), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: onClosed,
                        child: Chip(
                          labelPadding: EdgeInsets.all(0.0),
                          avatar: CircleAvatar(
                              backgroundColor: Colors.white70,
                              child: Text(
                                "x",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w800),
                              )),
                          label: Text(
                            "",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: Colors.white,
                          elevation: 6.0,
                          shadowColor: Colors.grey[60],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    "Team Name",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: ConstValues.primaryColor,
                        fontSize: 32,
                        fontWeight: FontWeight.w800),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Input(
                    backgroundColor: ConstValues.secondaryColor,
                    color: ConstValues.primaryColor,
                    labelText: "Enter a team name",
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onSave: (String? value) {
                      onSaved!(value!);
                    },
                    focusNode: focusNode!,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                  onPressed: onPressed,
                  child: Text("Enter"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
