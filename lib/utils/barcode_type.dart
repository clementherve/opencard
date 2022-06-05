import 'package:barcode_widget/barcode_widget.dart';

class BarcodeTypeUtil {
  static Barcode getBarcode(String type) {
    type = type.toLowerCase();
    switch (type) {
      case 'aztec':
        return Barcode.aztec();
      case 'code39':
        return Barcode.code39();
      case 'code93':
        return Barcode.code93();
      case 'code128':
        return Barcode.code128();
      case 'dataMatrix':
        return Barcode.dataMatrix();
      case 'ean8':
        return Barcode.ean8();
      case 'ean13':
        return Barcode.ean13();
      case 'qr':
        return Barcode.qrCode();
      case 'upce':
        return Barcode.upcE();
      default:
        return Barcode.codabar();
    }
  }
}
