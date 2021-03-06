import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:provider/provider.dart';
import 'package:umiperer/main.dart';
import 'package:umiperer/modals/CategoryController.dart';
import 'package:umiperer/modals/CricketMatch.dart';
import 'package:umiperer/modals/size_config.dart';

///MQD

class CreateNewCategoryDialog extends StatefulWidget {
  CreateNewCategoryDialog(
      {this.match, this.user, @required this.areWeAddingBatsmen});

  final CricketMatch match;
  final User user;
  final bool areWeAddingBatsmen;
  @override
  _CreateNewCategoryDialogState createState() =>
      _CreateNewCategoryDialogState();
}

class _CreateNewCategoryDialogState extends State<CreateNewCategoryDialog> {
  String playerName;
  bool isCatAlreadyExists = false;
  String newCatName;

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular((20 * SizeConfig.oneW).roundToDouble()),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.only(
              top: (0 * SizeConfig.oneH).roundToDouble(),
              left: (20 * SizeConfig.oneW).roundToDouble(),
              right: (20 * SizeConfig.oneW).roundToDouble(),
              bottom: (20 * SizeConfig.oneW).roundToDouble()),
          height: (380 * SizeConfig.oneH).roundToDouble(),
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular((8 * SizeConfig.oneW).roundToDouble()),
            color: Colors.white,
          ),
          child: dialogContent(context),
        ));
  }

  topAppName() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular((8 * SizeConfig.oneW).roundToDouble()),
            topRight: Radius.circular((8 * SizeConfig.oneW).roundToDouble())),
        color: Colors.blueGrey,
      ),
      padding: EdgeInsets.symmetric(
          horizontal: (20 * SizeConfig.oneW).roundToDouble()),
      // alignment: Alignment.centerLeft,
      height: 40,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "ADD YOUR CATEGORY",
            style: TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
          Text("Kirket"),
        ],
      ),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 0,
        ),
        hintTextTop(),
        enterForm(),
        // radioButtonPublicOrPrivate(),
        // SizedBox(
        //   height: 16,
        // ),
        // isCatAlreadyExists ? errorText() : Container(),
        endBtns()
      ],
    );
  }

  void createNewCategoryOnCloud() {
    categoryRef.doc(newCatName).set({
      "catName": newCatName.toUpperCase(),
      // "isPublic": selectedState=="Public"? true:false,
      "creatorUid": widget.user.uid,
      "count": 0,
    });
  }

  hintTextTop() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ADD YOUR CATEGORY",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: SizeConfig.setHeight(10),
        ),
        Text(
            "Category can be your Tournament name, Location etc. Next time you create a similar new match, you can put it in same category."),
        // SizedBox(
        //   height: SizeConfig.setHeight(8),
        // ),
        // Text("Public : Other users can also use your category")
      ],
    ));
  }

  String selectedState = "Private";

  radioButtonPublicOrPrivate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Radio(
          value: "Public",
          groupValue: selectedState,
          onChanged: (value) {
            setState(() {
              selectedState = value;
            });
          },
        ),
        new Text(
          'Public',
        ),
        new Radio(
          value: "Private",
          groupValue: selectedState,
          onChanged: (value) {
            setState(() {
              selectedState = value;
            });
          },
        ),
        new Text(
          'Private',
        ),
      ],
    );
  }

  enterForm() {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: "category name",
        labelText: "New Category",
      ),
      onChanged: (value) {
        newCatName = value.toUpperCase();
      },
    );
  }

  onCreateButtonPressed() async {
    if (newCatName != null) {
      final catDoc = await categoryRef.doc(newCatName).get();
      if (catDoc.exists) {
        setState(() {
          isCatAlreadyExists = true;
        });
      } else {
        createNewCategoryOnCloud();
      }
    }
  }

  endBtns() {
    return Consumer<CategoryController>(
      builder: (_, cc, child) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Bounce(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: Text("Cancel"),
            ),
          ),
          // ignore: missing_required_param
          Bounce(
            onPressed: () async {
              final catDoc = await categoryRef.doc(newCatName).get();

              if (!catDoc.exists) {
                final String ncn = newCatName;
                if (newCatName != null && ncn.trim().length != 0) {
                  onCreateButtonPressed();
                  cc.setSelectedCategory(to: newCatName);
                  Navigator.pop(context,cc.selectedCategory);
                }
              } else {
                showInSnackBar("Category already exist, enter new name");
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black12, width: 2)),
              child: Text("Create"),
            ),
          ),
        ],
      ),
    );
  }

  errorText() {
    return Text(
      "Use other category name",
      style: TextStyle(color: Colors.red),
    );
  }
}
