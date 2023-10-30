//
//  User.swift
//  Hakawy
//
//  Created by Ibrahim Nasser Ibrahim on 26/10/2023.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct User: Codable {
  var id = ""
  var name: String
  var email: String
  var pushID = "" // for notifications
  var avataLink = ""
  var status: String

  static var currentUser: User? {
    if Auth.auth().currentUser != nil {
      if let data = userDefaults.data(forKey: CurrentUser) {
        let decoder = JSONDecoder()
        do {
          let userObject = try decoder.decode(User.self, from: data)
          return userObject
        } catch {
          print(error.localizedDescription)
        }
      }
    }
    return nil
  }
}


func saveUserLocally(_ user: User) {
  let encoder = JSONEncoder()
  do {
    let data = try encoder.encode(user)
    userDefaults.set(data, forKey: CurrentUser)
  } catch {
    print("error")
  }
}
