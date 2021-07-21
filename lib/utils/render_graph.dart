import 'package:flutter/material.dart';

import 'package:new_app/models/graph_model.dart';
import 'package:new_app/models/weight_record.dart';

import 'package:new_app/utils/format_weight.dart';
import 'package:new_app/utils/indexed_iterables.dart';
import 'package:new_app/widgets/custom_graph/gradient_fill.dart';
import 'package:new_app/widgets/custom_graph/horizontal_lines.dart';
import 'package:new_app/widgets/custom_graph/lines.dart';
import 'package:new_app/widgets/custom_graph/spots.dart';

double setMinDisplayedWeight(double minWeight, double maxDisplayedWeight) {
  double minYPos = (3 * minWeight - maxDisplayedWeight) / 2;

  return minYPos;
}

double setMaxDisplayedWeight(double range, double maxWeight) {
  double maxDispWeight;
  if (range > 100) {
    maxDispWeight = maxWeight;
  } else {
    maxDispWeight = maxWeight + 5;
  }

  //"maxDisplayedWeight: $maxDispWeight");
  return maxDispWeight;
}

double yPos(double weight, /*double yPxPerKg,*/ double yHeight,
    double maxDisplayedWeight) {
  double newFormula = (weight * yHeight) / maxDisplayedWeight;
  //double oldformula = weight * yPxPerKg;
  //print('weight: $weight , yPos: $result');
  //print('weight: $weight , AlternateFormula: $newFormula');
  return limitDecimals(newFormula, 2);
}

double findWeight(double yPos, double maxDisplayedWeight, double yHeight) {
  return (yPos * maxDisplayedWeight) / yHeight;
}

//add the Y coordinates for Spots!
List<Map<String, dynamic>> addYPos(
    List<WeightRecord> records, double yHeight, double maxDisplayedWeight) {
  List<Map<String, dynamic>> spotsYPos =
      records.map((record) => record.toJson()).toList();

  spotsYPos.forEachIndexed((record, index) {
    record['yPos'] =
        yPos(record[RecordFields.weight], yHeight, maxDisplayedWeight);
  });

  return spotsYPos;
}

//draw the horizontal guidelines
List<DrawHorizontalLines> renderHorizontalLines(double xWidth, double yHeight,
    double maxDisplayedWeight, List<int> sideTitleWeights) {
  List<DrawHorizontalLines> horizontalLines =
      sideTitleWeights.mapIndexed((weight, index) {
    return DrawHorizontalLines(
        graphWidth: xWidth,
        lineHeight:
            (yHeight - yPos(weight.toDouble(), yHeight, maxDisplayedWeight)));
  }).toList();

  return horizontalLines;
}

//render the spots of the graph
List<GraphSpot> renderSpots(
    List<WeightRecord> records,
    double yHeight,
    double maxDisplayedWeight,
    int paddingLeft,
    int? selectedIndex,
    void Function(int listIndex) callback) {
  List<Map> spotsYPos = addYPos(records, yHeight, maxDisplayedWeight);

  List<Map> spotsXPos = spotsYPos; //add the X coordinates
  spotsXPos.forEachIndexed((record, index) {
    if (index == 0) {
      record['xPos'] = paddingLeft.toDouble(); //padding

    } else {
      record['xPos'] =
          (spotsXPos[index - 1]['xPos'] + 50); //distance between dates;
    }
  });

  List<GraphSpot> spots = spotsXPos.mapIndexed<GraphSpot>((record, index) {
    return GraphSpot(
        x: record['xPos'],
        y: record['yPos'],
        date: DateTime.parse(record['record_date']),
        weight: record['weight'],
        note: record['note'],
        id: index,
        selected: index == selectedIndex ? true : false,
        onGraphSpotTap: callback);
  }).toList();

  return spots;
}

//render the lines that connect the spots
List<DrawLines> renderLines(double yHeight, double xWidth, List<GraphSpot> spots) {
  List pairs = splitPairs(spots);
  List<DrawLines> lines = [];

  pairs.forEach((pair) {
    if (pair.length == 2) {
      lines.add(DrawLines(
          lineCoordinates: Coordinates(
              startCoords: CoordValues(x: pair[0].x, y: pair[0].y),
              endCoords: CoordValues(x: pair[1].x, y: pair[1].y)),
          yHeight: yHeight,
          xWidth: xWidth));
    }
  });

  //print("lines: $lines");
  return lines;
}

//render the gradient fill under the lines
List<GFCoordinates> renderGradientFill(List spots) {
  List<GFCoordinates> fill = [];

  if (spots.length == 1) {
    print("only one spot!");
    return fill;
  } else {
    List pairs = splitPairs(spots);

    pairs.forEach((pair) {
      if (pair.length == 2) {
        fill.add(
          GFCoordinates(
              startCoords: GFCoordValues(x: pair[0].x, y: pair[0].y),
              endCoords: GFCoordValues(x: pair[1].x, y: pair[1].y)),
        );
      }
    });

    // add the last two lines:
    //this add a vertical line from the last spot
    fill.add(GFCoordinates(
        startCoords: GFCoordValues(x: pairs.last[1].x, y: pairs.last[1].y),
        endCoords: GFCoordValues(x: pairs.last[1].x, y: 0)));

    //this is a line to connect to the first point
    fill.add(GFCoordinates(
        startCoords: GFCoordValues(x: pairs.last[1].x, y: 0),
        endCoords: GFCoordValues(x: 0, y: 0)));

    return fill;
  }
}
