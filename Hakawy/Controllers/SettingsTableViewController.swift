//
//  SettingsTableViewController.swift
//  Hakawy
//
//  Created by Ibrahim Nasser Ibrahim on 28/10/2023.
//

import UIKit

class SettingsTableViewController: UITableViewController {

  //MARK: - IBOutlets

  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var appVersionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

      tableView.tableFooterView = UIView()

    }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    showUserInfo()
  }

  //MARK: - IBAction

  @IBAction func tellAFriendPressed(_ sender: UIButton) {

  }

  @IBAction func termsAndConditionPressed(_ sender: UIButton) {

  }

  @IBAction func logOutPressed(_ sender: UIButton) {
    FirebaseUserListener.shared.logOutUser { error in
      if error == nil {
        let loginView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginView")
        DispatchQueue.main.async {
          loginView.modalPresentationStyle = .fullScreen
          self.present(loginView, animated: true)
        }
      }
    }
  }

  //MARK: - TableView Delegate

  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView()
    headerView.backgroundColor = UIColor(named: "ColorTableView")
    return headerView
  }

  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return section == 5 ? 10.0: 0.0
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 0 && indexPath.row == 0 {
      performSegue(withIdentifier: "EditProfileSegue", sender: self)
    }
  }

  //MARK: - Show User Information

  private func showUserInfo() {
    if let user = User.currentUser {
      usernameLabel.text = user.name
      statusLabel.text = user.status
      
      if user.avataLink != nil {
        //TODO:- Download Image
      }
    }
  }

}
