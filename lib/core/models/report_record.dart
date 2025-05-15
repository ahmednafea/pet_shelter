import 'dart:async';

import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:pet_shelter/firebase_auth/firestore_util.dart';

class ReportRecord extends FirestoreRecord {
  ReportRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "User Id" field.
  String? _userId;

  String get userId => _userId ?? '';

  bool hasID() => _userId != null;

  // "Picture" field.
  String? _picture;

  String get picture => _picture ?? '';

  bool hasPicture() => _picture != null;

  // "description" field.
  String? _description;

  String get description => _description ?? '';

  bool hasDescription() => _description != null;

  // "location" field.
  String? _location;

  String get location => _location ?? '';

  bool hasLocation() => _location != null;

  void _initializeFields() {
    _userId = snapshotData['user_id'] as String?;
    _picture = snapshotData['picture'] as String?;
    _description = snapshotData['description'] as String?;
    _location = snapshotData['location'] as String?;
  }

  static CollectionReference get collection => FirebaseFirestore.instance.collection('reports');

  static Stream<ReportRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ReportRecord.fromSnapshot(s));

  static Future<ReportRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ReportRecord.fromSnapshot(s));

  static ReportRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ReportRecord._(
        snapshot.reference,
        snapshot.data() as Map<String, dynamic>,
      );

  static ReportRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ReportRecord._(reference, data);

  @override
  String toString() => 'Report(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ReportRecord && reference.path.hashCode == other.reference.path.hashCode;
}
Map<String, dynamic> createReportRecordData({
  String? userId,
  String? picture,
  String? description,
  String? location
}) {
  final firestoreData = <String, dynamic>{
    'user_id': userId,
    'picture': picture,
    'description': description,
    'location': location
  };

  return firestoreData;
}