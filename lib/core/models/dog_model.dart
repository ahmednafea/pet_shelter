import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:pet_shelter/firebase_auth/firestore_util.dart';

class DogRecord extends FirestoreRecord {
  String? userId;
  String? image;
  String? description;
  String? adoptionUserId;

  DogRecord._(super.reference, super.data) {
    _initializeFields();
  }

  void _initializeFields() {
    userId = snapshotData['user_id'] as String?;
    image = snapshotData['image'] as String?;
    description = snapshotData['description'] as String?;
    adoptionUserId = snapshotData['adoption_user_id'] as String?;
  }

  static CollectionReference get collection => FirebaseFirestore.instance.collection('dogs');

  static Stream<DogRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => DogRecord.fromSnapshot(s));

  static Future<DogRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => DogRecord.fromSnapshot(s));

  static DogRecord fromSnapshot(DocumentSnapshot snapshot) =>
      DogRecord._(snapshot.reference, snapshot.data() as Map<String, dynamic>);

  @override
  String toString() => 'Dog(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is DogRecord && reference.path.hashCode == other.reference.path.hashCode;
}
Map<String, dynamic> createDogRecordData({
  String? userId,
  String? image,
  String? description,
  String? adoptionUserId
}) {
  final firestoreData = <String, dynamic>{
    'user_id': userId,
    'image': image,
    'description': description,
    'adoption_user_id': adoptionUserId
  };

  return firestoreData;
}