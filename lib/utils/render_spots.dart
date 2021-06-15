import 'package:new_app/utils/indexed_iterables.dart';
import 'package:new_app/utils/database.dart';
import 'package:new_app/utils/format_date.dart';
import 'package:new_app/utils/format_weight.dart';
import 'package:new_app/widgets/custom_graph/spots.dart';

List<GraphSpot> renderSpots(
  List<Map<String, dynamic>> records,
  double yHeight,
) {
  double minWeight = findMinWeight(records);
  double maxWeight = findMaxWeight(records);
  int getMinWeightIndex = minWeightIndex(records);
  //int getMaxWeightIndex = maxWeightIndex(records);

  int getAverageWeight() {
    double averageWeight = 0;

    records.forEach((record) => {averageWeight += record['weight']});
    averageWeight = averageWeight / records.length;
    print("averageWeight: $averageWeight");
    return averageWeight.ceil();
  }

  int fator = ((maxWeight - minWeight) / 6).ceil();
  int paddingTop = fator;
  int paddingBottom =
      ((fator - minWeight).ceil() > 10) ? (fator - minWeight).ceil() : 10;

  double yPxPerKg =
      yHeight / ((maxWeight + paddingTop) - (minWeight - paddingBottom));
  double yPos(double weight) {
    double result = (weight - (minWeight - paddingBottom)) * yPxPerKg;
    //print('yPos: $result');
    return limitDecimals(result, 2);
  }

  /* double xPos(String formattedString) {
      DateTime date1 = DateTime.parse(widget.records[0]['record_date']);
      DateTime date2 = DateTime.parse(formattedString);

      double recordXPosition = daysInBetween * widget.scaleX;

      return limitDecimals(recordXPosition, 2);
    } */

  List<Map> spotsYPos = makeModifiableResults(records);
  //add the Y coordinates
  spotsYPos.forEachIndexed((record, index) {
    /* if (index == getMinWeightIndex) {
      record['yPos'] =
          5.0; //because of the centering in the spots widget we need to add 5
      //print('MinWeightIndex: $record');
    } */
    /* else if (index == getMaxWeightIndex) {
      record['yPos'] =
          (limitDecimals(yHeight, 2) - 5); // minus the height of the spot
      // print('MaxWeightIndex: $record');
    } */
    /* else { */
    record['yPos'] = yPos(record['weight']);
    //print("otherRecords: $record");
    /* } */
  });

  //print("spotsYPos: $spotsYPos");

  List<Map> spotsXPos = spotsYPos; //add the X coordinates
  spotsXPos.forEachIndexed((record, index) {
    if (index == 0) {
      record['xPos'] = 20.0; //padding

    } else {
      record['xPos'] =
          (spotsXPos[index - 1]['xPos'] + 50); //distance between dates;
    }
  });

  //print("spotsXPos: $spotsXPos");

  List<GraphSpot> spots = spotsXPos.mapIndexed<GraphSpot>((record, index) {
    return GraphSpot(
      x: record['xPos'],
      y: record['yPos'],
      date: record['record_date'],
      weight: record['weight'],
    );
  }).toList();

  //print('spots: $spotsXPos');

  return spots;
}
