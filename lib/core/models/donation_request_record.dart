import 'dart:async';

import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:pet_shelter/firebase_auth/firestore_util.dart';

class DonationRequestRecord extends FirestoreRecord {
  DonationRequestRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "User Id" field.
  String? _userId;

  String get id => _userId ?? '';

  bool hasID() => _userId != null;


  // "amount" field.
  String? _amount;

  String get amount => _amount ??"";

  bool hasAmount() => _amount != null;


  void _initializeFields() {
    _userId = snapshotData['user_id'] as String?;
    _amount = snapshotData['amount'] as String?;

  }

  static CollectionReference get collection => FirebaseFirestore.instance.collection('donations_requests');

  static Stream<DonationRequestRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => DonationRequestRecord.fromSnapshot(s));

  static Future<DonationRequestRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => DonationRequestRecord.fromSnapshot(s));

  static DonationRequestRecord fromSnapshot(DocumentSnapshot snapshot) =>
      DonationRequestRecord._(
        snapshot.reference,
        snapshot.data() as Map<String, dynamic>,
      );

  static DonationRequestRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      DonationRequestRecord._(reference, data);

  @override
  String toString() => 'Donation Request(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is DonationRequestRecord && reference.path.hashCode == other.reference.path.hashCode;
}
Map<String, dynamic> createDonationRequestRecordData({
  String? userId,
  String? amount
}) {
  final firestoreData = <String, dynamic>{
    'user_id': userId,
    'amount': amount
  };

  return firestoreData;
}