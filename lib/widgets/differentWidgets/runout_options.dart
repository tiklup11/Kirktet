import 'package:flutter/material.dart';
import 'package:umiperer/modals/Ball.dart';
import 'package:umiperer/modals/CricketMatch.dart';
import 'package:umiperer/modals/runUpdater.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/widgets/score_button_widget.dart';

class RunOutOptions extends StatefulWidget {
  RunOutOptions(
      {this.ball,
      this.match,
      this.userUID,
      this.setRunOutToFalse,
      this.setUpdatingDataToTrue,
      this.setUpdatingDataToFalse,
      this.nonStriker,
      this.striker});

  final Ball ball;
  final CricketMatch match;
  final String userUID;
  final Function setRunOutToFalse;
  final Function setUpdatingDataToTrue;
  final Function setUpdatingDataToFalse;
  final String striker, nonStriker;

  @override
  _RunOutOptionsState createState() => _RunOutOptionsState();
}

class _RunOutOptionsState extends State<RunOutOptions> {
  final scoreSelectionAreaLength = (220 * SizeConfig.oneH).roundToDouble();
  RunUpdater runUpdater;
  final double buttonWidth = (60 * SizeConfig.oneW).roundToDouble();
  final btnColor = Colors.black12;

  String selectedRunOutBatsmen;
  List<DropdownMenuItem<String>> playersList = [];

  @override
  void initState() {
    super.initState();

    print("BS ; ${widget.nonStriker}");
    print("BS ; ${widget.striker}");

    if (widget.striker != null) {
      widget.ball.scoreBoardData.strikerName = widget.striker;
      selectedRunOutBatsmen = widget.ball.scoreBoardData.strikerName;
      playersList.add(
        DropdownMenuItem(
          child: Text(widget.striker),
          value: widget.striker,
        ),
      );
    }
    if (widget.nonStriker != null) {
      widget.ball.scoreBoardData.nonStrikerName = widget.nonStriker;
      playersList.add(
        DropdownMenuItem(
          child: Text(widget.nonStriker),
          value: widget.nonStriker,
        ),
      );
    }
    runUpdater = RunUpdater(
      matchId: widget.match.getMatchId(),
      context: context,
      setIsUploadingDataToFalse: widget.setUpdatingDataToFalse,
      // setWideToFalse: widget.setWideToFalse
    );
  }

  @override
  Widget build(BuildContext context) {
    return runOutOptions();
  }

  ///this is placed at the bottom, contains many run buttons
  runOutOptions() {
    final spaceBtwn = SizedBox(
      width: (4 * SizeConfig.oneW).roundToDouble(),
    );

    return ListView(
      children: [
        Container(
          // padding: EdgeInsets.symmetric(horizontal: (10*SizeConfig.oneW).roundToDouble(), vertical: (6*SizeConfig.oneH).roundToDouble()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ///Radio Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Select Batsmen  ---    "),
                  dropDownListOfBatsmen(),
                ],
              ),

              ///row one [0,1,2,3,4]
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customButton(
                      runScored: 0, btnText: "RunOut+0", toShowOnUI: "W"),
                  spaceBtwn,
                  customButton(
                      runScored: 1, btnText: "RunOut+1", toShowOnUI: "W+1"),
                  spaceBtwn,
                  customButton(
                      runScored: 2, btnText: "RunOut+2", toShowOnUI: "W+2"),
                ],
              ),

              ///row 2 [6,Wide,LB,Out,NB]
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customButton(
                      runScored: 3, btnText: "RunOut+3", toShowOnUI: "W+3"),
                  spaceBtwn,
                  customButton(
                      runScored: 4, btnText: "RunOut+4", toShowOnUI: "W+4"),
                  customButton(
                      runScored: 1, btnText: "RunOut+NB", toShowOnUI: "W"),
                ],
              ),
            ],
          ),
        ),
        IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              ///set isWide to false
              widget.setRunOutToFalse();
            })
      ],
    );
  }

  dropDownListOfBatsmen() {
    return DropdownButton(
        value: selectedRunOutBatsmen,
        items: playersList,
        onChanged: (value) {
          setState(() {
            selectedRunOutBatsmen = value;
          });
        });
  }

  ///this is the wideCustom btn
  customButton({int runScored, String btnText, String toShowOnUI}) {
    return ScoreButton(
        onPressed: () {
          widget.ball.scoreBoardData.strikerName = widget.striker;
          widget.ball.scoreBoardData.nonStrikerName = widget.nonStriker;
          widget.setUpdatingDataToTrue();
          widget.ball.runScoredOnThisBall = runScored;
          widget.ball.runToShowOnUI = toShowOnUI;
          widget.ball.outBatsmenName = selectedRunOutBatsmen;
          runUpdater.updateRunOut(ballData: widget.ball);
          widget.setRunOutToFalse();
        },
        btnText: btnText);
  }
}
