import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:umiperer/modals/CricketMatch.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/screens/matchDetailsScreens/dialog_custom.dart';
import 'package:umiperer/services/database_updater.dart';

///MQD
///
class SelectAndCreateBatsmenPage extends StatefulWidget {
  SelectAndCreateBatsmenPage({this.match});

  final CricketMatch match;
  @override
  _SelectAndCreateBatsmenPageState createState() =>
      _SelectAndCreateBatsmenPageState();
}

class _SelectAndCreateBatsmenPageState
    extends State<SelectAndCreateBatsmenPage> {
  bool isPlayerSelected = false;
  HashMap<String, bool> checkBoxMap = HashMap();
  int maximumCheckBox = 2;
  int selectedCheckBox;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          "Select Batsmen (${widget.match.getCurrentBattingTeam()})",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [batsmensList(), addNewPlayerBtn(), saveBtn()],
      ),
    );
  }

  Widget batsmensList() {
    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseController.getBatsmenCollRef(
              inningNo: widget.match.getInningNo(),
              matchId: widget.match.getMatchId())
          .snapshots(),
      builder: (context, snapshot) {
        selectedCheckBox = 0;
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          final playersData = snapshot.data.docs;
          print("PlayerData :: $playersData");

          List<Widget> playerNames = [];

          if (playersData.isEmpty) {
            return addNewPlayerIcon();
          }

          ///getting isBatting data and filling checkboxes depending upon them
          playersData.forEach((player) {
            if (player.data()['isBatting'] == false) {
              checkBoxMap[player.id] = false;
            }
            if (player.data()['isBatting'] == true) {
              checkBoxMap[player.id] = true;
              selectedCheckBox++;
            }
            playerNames.add(selectPlayerWidget(playerName: player.id));
          });

          print("XXXXXXXXXXXXXXXXXXXXD $selectedCheckBox");

          print(checkBoxMap);
          return Expanded(
            child: ListView(
              cacheExtent: 11,
              shrinkWrap: true,
              children: playerNames,
            ),
          );
        }
      },
    );
  }

  Widget selectPlayerWidget({String playerName}) {
    return Container(
      margin:
          EdgeInsets.symmetric(vertical: (2 * SizeConfig.oneH).roundToDouble()),
      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("   >  $playerName"),
          Checkbox(
            value: checkBoxMap[playerName],
            onChanged: (bool value) {
              if (selectedCheckBox < maximumCheckBox || !value) {
                updateIsBatting(playerName: playerName, value: value);

                setState(() {
                  checkBoxMap[playerName] = value;
                  if (!value) {
                    selectedCheckBox--;
                  }
                });
              }
            },
          ),
        ],
      ),
    );
  }

  void updateIsBatting({String playerName, bool value}) {
    if (selectedCheckBox == 0) {
      DatabaseController.getBatsmenDocRef(
              batsmenName: playerName,
              inningNo: widget.match.getInningNo(),
              matchId: widget.match.getMatchId())
          .update({
        "isBatting": value,
        "isOnStrike": true,
      });

      DatabaseController.getScoreBoardDocRef(
              inningNo: widget.match.getInningNo(),
              matchId: widget.match.getMatchId())
          .update({"strikerBatsmen": playerName});
    }

    if (selectedCheckBox == 1) {
      DatabaseController.getBatsmenDocRef(
              batsmenName: playerName,
              inningNo: widget.match.getInningNo(),
              matchId: widget.match.getMatchId())
          .update({
        "isBatting": value,
      });

      DatabaseController.getScoreBoardDocRef(
              inningNo: widget.match.getInningNo(),
              matchId: widget.match.getMatchId())
          .update({"nonStrikerBatsmen": playerName});
    }

    if (!value) {
      DatabaseController.getBatsmenDocRef(
              batsmenName: playerName,
              inningNo: widget.match.getInningNo(),
              matchId: widget.match.getMatchId())
          .update({
        "isBatting": value,
        "isOnStrike": value,
      });
    }
  }

  Widget addNewPlayerIcon() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "ADD NEW PLAYER",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Icon(Icons.keyboard_arrow_down_rounded)
        ],
      ),
    );
  }

  Widget addNewPlayerBtn() {
    return Bounce(
      onPressed: () {
        //TODO: update current batsmen name and other related stuff
        openDialog();
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.6),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12, width: 2)),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12),
        margin: EdgeInsets.only(
            left: (30 * SizeConfig.oneW).roundToDouble(),
            right: (30 * SizeConfig.oneW).roundToDouble(),
            bottom: (10 * SizeConfig.oneH).roundToDouble()),
        child: Center(child: Text("ADD NEW PLAYER")),
      ),
    );
  }

  Widget saveBtn() {
    return Bounce(
      onPressed: () {
        //TODO: update current batsmen name and other related stuff
        // onSaveBtnPressed();
        Navigator.pop(context);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.6),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12, width: 2)),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12),
        margin: EdgeInsets.only(
            left: (30 * SizeConfig.oneW).roundToDouble(),
            right: (30 * SizeConfig.oneW).roundToDouble(),
            bottom: (10 * SizeConfig.oneH).roundToDouble()),
        child: Center(child: Text("CONTINUE..")),
      ),
    );
  }

  openDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AddPlayerDialog(
            areWeAddingBatsmen: true,
            match: widget.match,
          );
        });
  }
}
