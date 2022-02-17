import 'package:easy_weight/utils/logger_instace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class UserOfferings extends ChangeNotifier {
  late Offering _availableOfferings;
 
  bool _isPro = false;

  Offering get  availableOfferings => _availableOfferings;
  
  bool get isPro => _isPro;
  

  UserOfferings() {
    loadAvailableOfferings();
  }

  loadAvailableOfferings() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null) {
        _availableOfferings = offerings.current!;
        
        logger.i("UserOfferings: ${_availableOfferings.toString()}",
            _availableOfferings);
        notifyListeners();
      }
    } on PlatformException catch (e) {
      logger.e("couldn't load offerings", e);
    }
  }

  getPurchases() async {
    try {
      PurchaserInfo purchaserInfo = await Purchases.getPurchaserInfo();
      if (purchaserInfo
          .entitlements.all[_availableOfferings.lifetime!.identifier]!.isActive) {
        logger.i("Pro user",purchaserInfo);
        _isPro = true;
        notifyListeners();
      }
    } on PlatformException catch (e) {
      logger.e("couldn't get purchases", e);
      // Error fetching purchaser info
    }
  }

  purchasePro() async {
    try {
      PurchaserInfo purchaserInfo =
          await Purchases.purchasePackage(_availableOfferings.lifetime!);
      if (purchaserInfo.entitlements
          .all[_availableOfferings.lifetime!.identifier]!.isActive) {
        _isPro = true;
        notifyListeners();
      }
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        logger.e('purchase failed', e);
      }
    }
  }

}
