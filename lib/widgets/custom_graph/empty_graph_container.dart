
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:easy_weight/models/records_model.dart';
import 'package:provider/provider.dart';

class EmptyGraphContainer extends StatelessWidget {
  const EmptyGraphContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);

    return Consumer<RecordsListModel>(builder: (context, records, child) {
      return Container(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: records.isLoading
              ? SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    color: Color(0xff12A3F8),
                    backgroundColor: theme.shadowDarkColor,
                    strokeWidth: 10,
                  ),
                )
              : Text(
                  AppLocalizations.of(context)!.addCurrentWeight,
                  style: theme.textTheme.headline3,
                  textAlign: TextAlign.center,
                ),
        ),
      );
    });
  }
}
