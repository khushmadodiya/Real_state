import 'package:cloud_firestore/cloud_firestore.dart';

import '../global.dart';

class firestoreMethos {
  Future<String> delete(String customerId) async {
    String res = "Some error occurred";
    try {
      await FirebaseFirestore.instance
          .collection('admin')
          .doc(adminuid)
          .collection('customers')
          .doc(customerId)
          .delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
