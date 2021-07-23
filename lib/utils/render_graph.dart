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
  //according to https://chezvoila.com/blog/yaxis/
  double minDisp = (3 * minWeight - maxDisplayedWeight) / 2;
  print('minDisplayedWeight: $minDisp');
  return minDisp;
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

double yPos(double weight, /*double yPxPerKg,*/ double graphHeight,
    double maxDisplayedWeight, double minDisplayedWeight) {
  
  double results =
      ((weight - minDisplayedWeight) * graphHeight) / (maxDisplayedWeight - minDisplayedWeight);

  //print('weight: $weight , AlternateFormula: $results');
  
  return limitDecimals(results, 2);
}

double findWeight(double yPos, double maxDisplayedWeight, double graphHeight) {
  return (yPos * maxDisplayedWeight) / graphHeight;
}

//add the Y coordinates for Spots!
List<Map<String, dynamic>> addYPos(List<WeightRecord> records,
    double graphHeight, double maxDisplayedWeight, double minDisplayedWeight) {
  List<Map<String, dynamic>> spotsYPos =
      records.map((record) => record.toJson()).toList();

  spotsYPos.forEachIndexed((record, index) {
    record['yPos'] = yPos(record[RecordFields.weight], graphHeight,
        maxDisplayedWeight, minDisplayedWeight);
  });

  return spotsYPos;
}

//render side Titles
List<int> renderSideTitleWeights(
    double minDisplayedWeight, double maxDisplayedWeight) {
  List<int> sideTitleWeights = [];

  sideTitleWeights.add(minDisplayedWeight.ceil());

  int fator = ((maxDisplayedWeight - minDisplayedWeight) / 4).ceil();
  print('fator: $fator');

  //this was causing a memory leak somehow
  /* for (var i = fator; i < maxDisplayedWeight.ceil(); i + fator) {
    sideTitleWeights.add((minDisplayedWeight + i).ceil());
  }  */

  sideTitleWeights.add(minDisplayedWeight.ceil() + fator);
  sideTitleWeights.add(minDisplayedWeight.ceil() + fator * 2);
  sideTitleWeights.add(minDisplayedWeight.ceil() + fator * 3);
  sideTitleWeights.add(maxDisplayedWeight.ceil());

  print('sideTitleWeights: $sideTitleWeights');

  return sideTitleWeights;
}

//draw the horizontal guidelines
List<DrawHorizontalLines> renderHorizontalLines(
    double graphWidth,
    double graphHeight,
    double paddingTop,
    double maxDisplayedWeight,
    double minDisplayedWeight,
    List<int> sideTitleWeights) {
  List<DrawHorizontalLines> horizontalLines =
      sideTitleWeights.mapIndexed((weight, index) {
    return DrawHorizontalLines(
        graphWidth: graphWidth,
        lineHeight: (graphHeight -
                yPos(weight.toDouble(), graphHeight, maxDisplayedWeight,
                    minDisplayedWeight)) +
            paddingTop);
  }).toList();

  return horizontalLines;
}

//render the spots of the graph
List<GraphSpot> renderSpots(
    List<WeightRecord> records,
    double graphHeight,
    double maxDisplayedWeight,
    double minDisplayedWeight,
    int paddingLeft,
    int? selectedIndex,
    void Function(int listIndex) callback) {
  List<Map> spotsYPos =
      addYPos(records, graphHeight, maxDisplayedWeight, minDisplayedWeight);

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
List<DrawLines> renderLines(
    double graphHeight, double graphWidth, List<GraphSpot> spots) {
  List pairs = splitPairs(spots);
  List<DrawLines> lines = [];

  pairs.forEach((pair) {
    if (pair.length == 2) {
      lines.add(DrawLines(
          lineCoordinates: Coordinates(
              startCoords: CoordValues(x: pair[0].x, y: pair[0].y),
              endCoords: CoordValues(x: pair[1].x, y: pair[1].y)),
          graphHeight: graphHeight,
          graphWidth: graphWidth));
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
