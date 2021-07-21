import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:new_app/widgets/neumorphic/neumorphic_border_container.dart';

class StatsContainer extends StatelessWidget {
  

  const StatsContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeuBorderContainer(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Current',
                          style: Theme.of(context).textTheme.bodyText1),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              "79.9",
                              style: 
                              Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 35, fontWeight: FontWeight.w800),
                            ),
                            Text('kg',
                                style: Theme.of(context).textTheme.bodyText1)
                          ]),
                      Text(
                        'Week ▲0.5kg',
                        style: TextStyle(fontSize: 14, ),
                      ),
                      Text(
                        'Month ▼0.8kg',
                        style: TextStyle(fontSize: 14,),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text('Goal',
                          style: TextStyle(
                              fontSize: 14,
                              
                              fontWeight: FontWeight.normal)),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              "77",
                              style: TextStyle(
                                  fontSize: 35,
                                 
                                  fontWeight: FontWeight.w900),
                            ),
                            Text('kg',
                                style: TextStyle(
                                    fontSize: 14,
                                   
                                    fontWeight: FontWeight.normal))
                          ]),
                      Text(
                        '78% Completed',
                        style: TextStyle(fontSize: 14, ),
                      ),
                      Text(
                        '2.5kg left',
                        style: TextStyle(fontSize: 14, ),
                      )
                    ],
                  )
                ],
              ),
            );
            
                      
       
      
  }
}
