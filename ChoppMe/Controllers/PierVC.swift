//
//  PierVC.swift
//  ChoppMe
//
//  Created by Rodrigo de Sousa Santos on 22/12/2018.
//  Copyright © 2018 Rodrigo de Sousa Santos. All rights reserved.
//

import UIKit

class PierVC: UIViewController {
    
    @IBOutlet weak var ordersTableView: UITableView!
    
    
    private var pierVM = PierVM()
    private var pubViewModel = PubVM()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func logoutPub(_ sender: UIButton) {
        
        self.pubViewModel.logout(completion: { errorMessage in
            if let errorMessage = errorMessage{
                let errorAlert = CustomExtensions.showAlertView(alertMessage: errorMessage)
                self.present(errorAlert, animated: true, completion: nil)
            }else{
                // TODO: Redirect user to Login Screen
                let userDefaults = UserDefaults.standard
                userDefaults.setValue(false, forKey: "isAuthenticated")
                self.performSegue(withIdentifier: "unwindToLogin", sender: nil)
            }
        })
        
//        self.pubViewModel.login(completion: { errorMessage in
//            if let errorMessage = errorMessage{
//                let errorAlert = CustomExtensions.showAlertView(alertMessage: errorMessage)
//                self.present(errorAlert, animated: true, completion: nil)
//            }else{
//                self.performSegue(withIdentifier: "segueToMain", sender: nil)
//            }
//        })
    }
}
