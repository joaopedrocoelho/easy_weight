import 'package:flutter/material.dart';



class BigWeightHeadline extends StatelessWidget {
  final double weight;
    
    const BigWeightHeadline({Key? key, required this.weight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      
      child: Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                weight.toString(),
                                style: 
                                Theme.of(context).textTheme.bodyText1?.copyWith(
                                  fontSize: 70, 
                                  fontWeight: FontWeight.w300,
                                  
                                  textBaseline: TextBaseline.alphabetic,
                                  height:1
                                  ),
                              ),
                              Text('kg',
                                  style: Theme.of(context).textTheme.bodyText1)
                            ]),
    );
  }
}
