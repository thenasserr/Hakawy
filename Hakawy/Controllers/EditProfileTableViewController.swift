//
//  EditProfileTableViewController.swift
//  Hakawy
//
//  Created by Ibrahim Nasser Ibrahim on 30/10/2023.
//

import UIKit

class EditProfileTableViewController: UITableViewController, UITextFieldDelegate {

  //MARK: - IBOulets

  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var statusLabel: UILabel!


  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.tableFooterView = UIView()
    configureTextField()
    showUserInfo()

  }

  //MARK: - TableView Delegate

  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView()
    headerView.backgroundColor = UIColor(named: "ColorTableView")
    return headerView
  }

  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//    return section == 0 || section == 1 ? 0.0 : 30.0
    return 0
  }

  override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return nil
  }



  //MARK: - IBAction

  @IBAction func editButtonPressed(_ sender: Any) {

    
  }

  //MARK: - Show user info

  private func showUserInfo() {

    if let user = User.currentUser {
      usernameTextField.text = user.name
      statusLabel.text = user.status

      if user.avataLink != "" {
        //Set avatar Image
      }
    }
  }

  //MARK: - TextField Configration

  private func configureTextField() {
    usernameTextField.delegate = self
    usernameTextField.clearButtonMode = .whileEditing
  }

  //MARK: - Text Field Delegate

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == usernameTextField {
      if textField.text != "" {
        if var user = User.currentUser {
          user.name = usernameTextField.text!
          saveUserLocally(user)
          FirebaseUserListener.shared.saveUserToFirebase(user)
        }
      }
      textField.resignFirstResponder()
      return false
    }
    return true
  }

}
