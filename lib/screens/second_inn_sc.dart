import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:umiperer/modals/Batsmen.dart';
import 'package:umiperer/modals/Bowler.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/modals/dataStreams.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/widgets/Bowler_stats_row.dart';
import 'package:umiperer/widgets/batsmen_score_row.dart';

///mqd
final usersRef = FirebaseFirestore.instance.collection('users');

class SecondInningScoreCard extends StatefulWidget {
  SecondInningScoreCard({this.creatorUID, this.match});
  final String creatorUID;
  final CricketMatch match;
  // final String matchUID;
  @override
  _SecondInningScoreCardState createState() => _SecondInningScoreCardState();
}

class _SecondInningScoreCardState extends State<SecondInningScoreCard> {
  List<Batsmen> currentBothBatsmen;
  DataStreams dataStreams;
  @override
  Widget build(BuildContext context) {
    final Batsmen dummyBatsmen = Batsmen(
        isClickable: false,
        isOnStrike: false,
        runs: "-",
        playerName: "--------",
        sR: "-",
        noOf6s: "-",
        noOf4s: "-",
        balls: "-");

    return Container(
      child: Column(
        children: [
          batsmenList(),
          bowlersList()
        ],
      ),
    );
  }
  bowlersList(){
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: (10 * SizeConfig.oneW).roundToDouble(),
          vertical: (10 * SizeConfig.oneH).roundToDouble()),
      margin: EdgeInsets.symmetric(
          horizontal: (10 * SizeConfig.oneW).roundToDouble(),
          vertical: (10 * SizeConfig.oneH).roundToDouble()),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
            (4 * SizeConfig.oneW).roundToDouble()),
      ),
      child: Column(
        children: [
          BowlerStatsRow(
            isThisSelectBowlerBtn: false,
            bowler: Bowler(
                playerName: "Bowler",
                runs: "R",
                wickets: "W",
                overs: "O",
                median: "M",
                economy: "E"),
          ),

          Container(
            color: Colors.black12,
            height: (4 * SizeConfig.oneH).roundToDouble(),
          ),

          //Batsman's data
          StreamBuilder<QuerySnapshot>(
              stream: usersRef
                  .doc(widget.creatorUID)
                  .collection('createdMatches')
                  .doc(widget.match.getMatchId())
                  .collection('2InningBowlingData')
                  .snapshots(),

              builder: (context, snapshot) {
                List<BowlerStatsRow> allBowlersList = [];

                if (!snapshot.hasData) {
                  return loadingData(msg: "Loading bowlers data");
                } else {


                  final bowlersData = snapshot.data.docs;

                  bowlersData.forEach((playerData) {
                    final maidens = playerData.data()['maidens'];
                    final wickets = playerData.data()['wickets'];
                    final overs = playerData.data()['overs'];
                    final ballOfThatOver = playerData.data()['ballOfTheOver'];
                    final playerName = playerData.data()['name'];
                    final runs = playerData.data()['runs'];
                    final isBowling = playerData.data()['isBowling'];
                    final totalBalls = playerData.data()['totalBalls'];
                    final overLengthToFinishTheOver = playerData.data()['overLength'];

                    double eco = 0;
                    try {
                      eco = (runs / ((overs) +(ballOfThatOver/6)));
                    } catch (e) {
                      eco = 0;
                    }

                    if (eco.isNaN) {
                      eco = 0;
                    }

                    allBowlersList.add(BowlerStatsRow(
                      isThisSelectBowlerBtn: false,
                      bowler: Bowler(
                          playerName: playerName,
                          runs: runs.toString(),
                          economy: eco.toStringAsFixed(1),
                          median: maidens.toString(),
                          overs: "$overs.$ballOfThatOver",
                          wickets: wickets.toString(),
                          totalBallBowled: totalBalls,
                          ballOfTheOver: ballOfThatOver),
                    ));
                  });
                }
                if(allBowlersList.isEmpty){
                  return zeroData(iconData: Icons.sports_handball,msg: "Bowlers data is shown here");
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: allBowlersList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return allBowlersList[index];
                  },
                );
              })
        ],
      ),
    );
  }

  batsmenList(){
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: (10 * SizeConfig.oneW).roundToDouble(),
          vertical: (10 * SizeConfig.oneH).roundToDouble()),
      margin: EdgeInsets.symmetric(
          horizontal: (10 * SizeConfig.oneW).roundToDouble(),
          vertical: (10 * SizeConfig.oneH).roundToDouble()),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
            (4 * SizeConfig.oneW).roundToDouble()),
      ),
      child: Column(
        children: [
          BatsmenScoreRow(
            isThisSelectBatsmenBtn: false,
            isOnStrike: false,
            batsmen: Batsmen(
                isOnStrike: false,
                isClickable: false,
                runs: "R",
                playerName: "Batsmen",
                sR: "SR",
                noOf6s: "6s",
                noOf4s: "4s",
                balls: "B"),
          ),

          Container(
            color: Colors.black12,
            height: (4 * SizeConfig.oneH).roundToDouble(),
          ),

          //Batsman's data
          StreamBuilder<QuerySnapshot>(
              stream: usersRef
                  .doc(widget.creatorUID)
                  .collection('createdMatches')
                  .doc(widget.match.getMatchId())
                  .collection('2InningBattingData')
                  .where('isOut', isEqualTo: true)
                  .snapshots(),

              builder: (context, snapshot) {
                List<BatsmenScoreRow> listOfBatsmen = [];

                if (!snapshot.hasData) {
                  return loadingData(msg: "Loading batsmen data");
                } else {
                  final batsmenData = snapshot.data.docs;

                  batsmenData.forEach((playerData) {
                    print("DATA::  ${playerData.data()}");
                    final ballsPlayed = playerData.data()['balls'];
                    final noOf4s = playerData.data()['noOf4s'];
                    final noOf6s = playerData.data()['noOf6s'];
                    final playerName = playerData.data()['name'];
                    final runs = playerData.data()['runs'];
                    final isOnStrike = playerData.data()['isOnStrike'];

                    double SR = 0;
                    try {
                      print(
                          "tryinggggggggggggggggggggggggggggggggggggggggggggggggggg");
                      SR = ((runs / ballsPlayed) * 100);
                      print(
                          "tryinggggggggggggggggggggggggggggggggggggggggggggggggggg ;;SR== $SR");
                    } catch (e) {
                      print("Failedddddddddddddddddddddd");
                      SR = 0;
                    }

                    if (SR.isNaN) {
                      SR = 0.0;
                    }

                    listOfBatsmen.add(BatsmenScoreRow(
                      isOnStrike: isOnStrike,
                      isThisSelectBatsmenBtn: false,
                      batsmen: Batsmen(
                          isClickable: false,
                          balls: ballsPlayed.toString(),
                          noOf4s: noOf4s.toString(),
                          noOf6s: noOf6s.toString(),
                          sR: SR.toStringAsFixed(0),
                          playerName: playerName,
                          runs: runs.toString(),
                          isOnStrike: isOnStrike),
                    ));
                  });
                }
                if(listOfBatsmen.isEmpty){
                  return zeroData(iconData: Icons.sports_cricket_outlined,msg: "Batsmen data is shown here");
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: listOfBatsmen.length,
                  itemBuilder: (BuildContext context, int index) {
                    return listOfBatsmen[index];
                  },
                );
              })
        ],
      ),
    );
  }

  loadingData({String msg}){
    return Container(
        height: (80*SizeConfig.oneH).roundToDouble(),
        child: Center(child: CircularProgressIndicator()));
  }

  zeroData({String msg, IconData iconData}){
    return Container(
      height: (80*SizeConfig.oneH).roundToDouble(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData),
          SizedBox(width: (4*SizeConfig.oneW).roundToDouble(),),
          Text(msg),
        ],
      ),
    );
  }
}