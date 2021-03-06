import 'package:flutter/material.dart';
import 'package:umiperer/modals/Ball.dart';
import 'package:umiperer/modals/runUpdater.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/widgets/score_button_widget.dart';

class WideBallOptions extends StatefulWidget {

  WideBallOptions({this.ball,this.matchId,this.userUID,
    this.setWideToFalse,this.setUpdatingDataToTrue,this.setUpdatingDataToFalse,
  });

  final Ball ball;
  final String matchId;
  final String userUID;
  final Function setWideToFalse;
  final Function setUpdatingDataToTrue;
  final Function setUpdatingDataToFalse;

  @override
  _WideBallOptionsState createState() => _WideBallOptionsState();
}

class _WideBallOptionsState extends State<WideBallOptions> {

  final scoreSelectionAreaLength = (220*SizeConfig.oneH).roundToDouble();
  RunUpdater runUpdater;
  final double buttonWidth = (60*SizeConfig.oneW).roundToDouble();
  final btnColor = Colors.black12;


  @override
  void initState() {
    super.initState();
    runUpdater = RunUpdater(
        matchId: widget.matchId,
        context: context,setIsUploadingDataToFalse: widget.setUpdatingDataToFalse,
        // setWideToFalse: widget.setWideToFalse
    );
  }

  @override
  Widget build(BuildContext context) {
    return wideBallOptions();
  }
  ///this is placed at the bottom, contains many run buttons
  wideBallOptions() {

    final spaceBtwn = SizedBox(
      width: (4*SizeConfig.oneW).roundToDouble(),
    );

    return ListView(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: (10*SizeConfig.oneW).roundToDouble(), vertical: (6*SizeConfig.oneH).roundToDouble()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ///row one [0,1,2,3,4]
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customButton(runScored: 1,btnText: "Wide+0",toShowOnUI: "Wd+0"),
                  spaceBtwn,
                  customButton(runScored: 2,btnText: "Wide+1",toShowOnUI: "Wd+1"),
                ],
              ),

              ///row 2 [6,Wide,LB,Out,NB]
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customButton(runScored: 3,btnText: "Wide+2",toShowOnUI:"Wd+2" ),
                  spaceBtwn,
                  customButton(runScored: 4,btnText: "Wide+3",toShowOnUI: "Wd+3"),
                  spaceBtwn,
                  customButton(runScored: 5,btnText: "Wide+4",toShowOnUI: "Wd+4"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScoreButton(
                  onPressed: () {
                    widget.setUpdatingDataToTrue();
                    widget.ball.runScoredOnThisBall=1;
                    widget.ball.runToShowOnUI="Wd+W";
                    runUpdater.updateWidePlusStump(ballData: widget.ball);
                    // widget.setIsWideToFalse();
                  },
                  btnText:"Wide+Stump"),
                ],
              ),
            ],
          ),
        ),
        IconButton(
            icon: Icon(Icons.close),
            onPressed:() {
              ///set isWide to false
              widget.setWideToFalse();
            } )
      ],
    );
  }

  ///this is the wideCustom btn
  customButton({int runScored,String btnText,String toShowOnUI}){
    return ScoreButton(
        btnText: btnText,
        onPressed: () {
          widget.setUpdatingDataToTrue();
          widget.ball.runScoredOnThisBall=runScored;
          widget.ball.runToShowOnUI=toShowOnUI;
          runUpdater.updateWideAndOverThrowRuns(ballData: widget.ball);
          // widget.setIsWideToFalse();
        });
  }
}
