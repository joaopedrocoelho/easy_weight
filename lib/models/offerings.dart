import 'package:easy_weight/utils/logger_instace.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class UserOfferings extends ChangeNotifier {
  late Offering _availableOfferings;

  bool _isPro = false;
  bool _hasError = false;
  int? errorNumber;
  String? _errorMsg;

  Offering get availableOfferings => _availableOfferings;

  bool get isPro => _isPro;
  bool get hasError => _hasError;
  String? get errorMsg => _errorMsg;

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
        getPurchases();
      }
    } on PlatformException catch (e) {
      logger.e("couldn't load offerings", e);
      _hasError = true;
      _errorMsg = e.message;
      
    }
  }

  Future<bool> getPurchases() async {
    try {
      PurchaserInfo purchaserInfo = await Purchases.getPurchaserInfo();

      logger.i('purchaserInfo', purchaserInfo);
      if (purchaserInfo.entitlements.active.isNotEmpty) {
        _isPro = true;
        notifyListeners();
        logger.i('User is pro', _isPro);
      }
    } on PlatformException catch (e) {
      logger.e("couldn't get purchases", e);

      // Error fetching purchaser info
    }
    return _isPro;
  }

  Future<bool> purchasePro() async {
    try {
      PurchaserInfo purchaserInfo =
          await Purchases.purchasePackage(_availableOfferings.lifetime!);

      if (purchaserInfo.entitlements.active.isNotEmpty) {
        _isPro = true;
        notifyListeners();
              }
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        logger.e('purchase failed', e);
        errorNumber = int.parse(e.code);
        notifyListeners();
        
      }
    }
    return _isPro;
  }
}
