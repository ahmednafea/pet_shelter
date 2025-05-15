import 'dart:async';

import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:pet_shelter/firebase_auth/firestore_util.dart';

class AdoptionRequestRecord extends FirestoreRecord {
  AdoptionRequestRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "User Id" field.
  String? _userId;

  String get userId => _userId ?? '';

  bool hasUserID() => _userId != null;

  // "Dog Id" field.
  String? _dogId;

  String get dogId => _dogId ?? '';

  bool hasDogID() => _dogId != null;

  // "address" field.
  String? _address;

  String get address => _address ?? '';

  bool hasAddress() => _address != null;

  void _initializeFields() {
    _userId = snapshotData['user_id'] as String?;
    _address = snapshotData['address'] as String?;
    _dogId = snapshotData['dog_id'] as String?;
  }

  static CollectionReference get collection => FirebaseFirestore.instance.collection('adoption_requests');

  static Stream<AdoptionRequestRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => AdoptionRequestRecord.fromSnapshot(s));

  static Future<AdoptionRequestRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => AdoptionRequestRecord.fromSnapshot(s));

  static AdoptionRequestRecord fromSnapshot(DocumentSnapshot snapshot) =>
      AdoptionRequestRecord._(
        snapshot.reference,
        snapshot.data() as Map<String, dynamic>,
      );

  static AdoptionRequestRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      AdoptionRequestRecord._(reference, data);

  @override
  String toString() => 'Adoption Request(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is AdoptionRequestRecord && reference.path.hashCode == other.reference.path.hashCode;
}
Map<String, dynamic> createAdoptionRequestRecordData({
  String? userId,
  String? dogId,
  String? address
}) {
  final firestoreData = <String, dynamic>{
    'user_id': userId,
    'address': dogId,
    'dog_id': address
  };

  return firestoreData;
}