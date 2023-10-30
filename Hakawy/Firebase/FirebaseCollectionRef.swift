//
//  FirebaseCollectionRef.swift
//  Hakawy
//
//  Created by Ibrahim Nasser Ibrahim on 26/10/2023.
//

import Foundation
import Firebase

enum FirebaseColletionRef: String {
  case User
}

func FirestoreRefrence(_ collectionRefrence: FirebaseColletionRef) -> CollectionReference {
  return Firestore.firestore().collection(collectionRefrence.rawValue)
}
