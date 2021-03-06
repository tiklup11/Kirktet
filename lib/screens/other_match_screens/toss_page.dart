import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:umiperer/modals/CricketMatch.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/screens/matchDetailsScreens/matchDetailsHOME.dart';
import 'package:umiperer/services/database_updater.dart';
import 'package:umiperer/widgets/back_button_widget.dart';

//where actual counting happens
class TossScreen extends StatefulWidget {
  TossScreen({this.match, this.user});

  final CricketMatch match;
  final User user;
  @override
  _TossScreenState createState() => _TossScreenState();
}

class _TossScreenState extends State<TossScreen> {
  String tossWinner = "who";
  String batOrBall = "";
  Color unSelectedColor = Colors.black12;
  Color selectedColor = Colors.blueAccent;

  final double outerRadius = (40 * SizeConfig.oneW).roundToDouble();
  final double innerRadius = (26 * SizeConfig.oneW).roundToDouble();

  bool isTeam1Selected = false;
  bool isTeam2Selected = false;

  bool isBattingSelected = false;
  bool isBowlingSelected = false;

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: CustomBackButton(),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
            "${widget.match.getTeam1Name()} vs ${widget.match.getTeam2Name()}",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
          child: Column(
            children: [
              //Who won toss widget
              whoWonTossWidget(),
              //and choose
              andChooseToWidget(),

              continueButton(),
            ],
          ),
        ));
  }

  whoWonTossWidget() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black12, width: 2)),
      margin: EdgeInsets.symmetric(
          horizontal: (10 * SizeConfig.oneW).roundToDouble(),
          vertical: (10 * SizeConfig.oneH).roundToDouble()),
      padding: EdgeInsets.symmetric(
          horizontal: (20 * SizeConfig.oneW).roundToDouble(),
          vertical: (20 * SizeConfig.oneH).roundToDouble()),
      child: Column(
        // crossAxisAlignment: ,
        children: [
          Text("$tossWinner won toss"),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Bounce(
                duration: Duration(milliseconds: 150),
                onPressed: () {
                  setState(() {
                    isTeam1Selected = !isTeam1Selected;
                    isTeam2Selected = false;
                    if (isTeam1Selected) {
                      tossWinner = widget.match.getTeam1Name();
                    } else {
                      tossWinner = "who";
                    }
                  });
                },
                child: SizedBox(
                  width: SizeConfig.setWidth(140),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor:
                            isTeam1Selected ? selectedColor : unSelectedColor,
                        radius: outerRadius,
                        child: CircleAvatar(
                          radius: innerRadius,
                          child: Image.asset(
                            'assets/images/team1.png',
                            scale: (17 * SizeConfig.oneW).roundToDouble(),
                          ),
                        ),
                      ),
                      Text(
                        widget.match.getTeam1Name(),
                        maxLines: 3,
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                ),
              ),
              Bounce(
                duration: Duration(milliseconds: 150),
                onPressed: () {
                  setState(() {
                    isTeam2Selected = !isTeam2Selected;
                    isTeam1Selected = false;
                    if (isTeam2Selected) {
                      tossWinner = widget.match.getTeam2Name();
                    } else {
                      tossWinner = "who";
                    }
                  });
                },
                child: SizedBox(
                  width: SizeConfig.setWidth(140),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor:
                            isTeam2Selected ? selectedColor : unSelectedColor,
                        radius: outerRadius,
                        child: CircleAvatar(
                          radius: innerRadius,
                          child: Image.asset(
                            'assets/images/team2.png',
                            scale: (17 * SizeConfig.oneW).roundToDouble(),
                          ),
                        ),
                      ),
                      Text(
                        widget.match.getTeam2Name(),
                        maxLines: 3,
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  andChooseToWidget() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black12, width: 2)),
      margin: EdgeInsets.symmetric(
          horizontal: (10 * SizeConfig.oneW).roundToDouble(),
          vertical: (10 * SizeConfig.oneH).roundToDouble()),
      padding: EdgeInsets.symmetric(
          horizontal: (20 * SizeConfig.oneW).roundToDouble(),
          vertical: (20 * SizeConfig.oneH).roundToDouble()),
      child: Column(
        // crossAxisAlignment: ,
        children: [
          Text("and selected to $batOrBall"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Bounce(
                duration: Duration(milliseconds: 150),
                onPressed: () {
                  setState(() {
                    isBattingSelected = !isBattingSelected;
                    isBowlingSelected = false;
                    if (isBattingSelected) {
                      batOrBall = "Bat";
                    } else {
                      batOrBall = "";
                    }
                  });
                },
                child: SizedBox(
                  width: SizeConfig.setWidth(140),
                  child: CircleAvatar(
                    backgroundColor:
                        isBattingSelected ? selectedColor : unSelectedColor,
                    radius: outerRadius,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: innerRadius,
                      backgroundImage: AssetImage('assets/images/bat.png'),
                    ),
                  ),
                ),
              ),
              Bounce(
                duration: Duration(milliseconds: 150),
                onPressed: () {
                  setState(() {
                    isBowlingSelected = !isBowlingSelected;
                    isBattingSelected = false;
                    if (isBowlingSelected) {
                      batOrBall = "Bowl";
                    } else {
                      batOrBall = "";
                    }
                  });
                },
                child: SizedBox(
                  width: SizeConfig.setWidth(140),
                  child: CircleAvatar(
                    backgroundColor:
                        isBowlingSelected ? selectedColor : unSelectedColor,
                    radius: outerRadius,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: innerRadius,
                      backgroundImage: AssetImage('assets/images/ball.png'),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  continueButton() {
    return Container(
      margin: EdgeInsets.only(top: (10 * SizeConfig.oneH).roundToDouble()),
      padding: EdgeInsets.symmetric(
          horizontal: (10 * SizeConfig.oneW).roundToDouble()),
      child: Bounce(
        duration: Duration(milliseconds: 150),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black12, width: 2),
              color: Colors.blueAccent.withOpacity(0.6),
              borderRadius: BorderRadius.circular(10)),
          width: double.infinity,
          height: (40 * SizeConfig.oneH).roundToDouble(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("Continue"), Icon(Icons.arrow_forward)],
          ),
        ),
        onPressed: () {
          uploadTossDataToCloud();
        },
      ),
    );
  }

  uploadTossDataToCloud() {
    if (tossWinner != "who" && batOrBall != "") {
      widget.match.setBatOrBall(batOrBall);
      widget.match.setTossWinner(tossWinner);

      widget.match.setFirstInnings();

      DatabaseController.getGeneralMatchDoc(matchId: widget.match.getMatchId())
          .update({
        "whatChoose": widget.match.getChoosedOption(),
        "tossWinner": widget.match.getTossWinner(),
        "isMatchStarted": true,
      });

      DatabaseController.getScoreBoardDocRef(
        inningNo: 1,
        matchId: widget.match.getMatchId(),
      ).update({
        "battingTeam": widget.match.getFirstBattingTeam(),
        "bowlingTeam": widget.match.getFirstBowlingTeam()
      });

      DatabaseController.getScoreBoardDocRef(
        inningNo: 2,
        matchId: widget.match.getMatchId(),
      ).update({
        "battingTeam": widget.match.getSecondBattingTeam(),
        "bowlingTeam": widget.match.getSecondBowlingTeam(),
      });

      Navigator.pop(context);
      //TODO: navigate to counterPage
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return MatchDetails(
          match: widget.match,
          user: widget.user,
        );
      }));
    }
  }
}
