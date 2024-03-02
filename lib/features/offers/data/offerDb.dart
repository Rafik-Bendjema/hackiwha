import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackiwha/features/offers/domain/entities/Offer.dart';

abstract class OfferDb {
  Future<bool> addOffer(Offer o);
  Future<bool> deleteOffer(Offer o);
  Future<bool> validateOffer(Offer o);
}

class OfferDb_impl implements OfferDb {
  FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  Future<bool> addOffer(Offer o) async {
    try {
      await db.collection("offers").doc(o.id).set(o.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteOffer(Offer o) async {
    try {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection("offer").doc(o.id);

      // Delete the document
      await documentReference.delete();
      return true;
    } on Exception catch (e) {
      return false;
    }
  }

  @override
  Future<bool> validateOffer(Offer o) async {
    try {
      await db.collection("offers").doc(o.id).update({'isAvailable': false});
      return true;
    } catch (e) {
      return false;
    }
  }
}
