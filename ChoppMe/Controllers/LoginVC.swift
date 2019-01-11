//
//  LoginVC.swift
//  ChoppMe
//
//  Created by Rodrigo de Sousa Santos on 07/01/2019.
//  Copyright © 2019 Rodrigo de Sousa Santos. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var pubEmailTextField: UITextField!
    @IBOutlet weak var pubPasswordTextField: UITextField!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backgroundViewConstraint: NSLayoutConstraint!
    
    private var pubViewModel = PubVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activateKeyboardListeners()
        
        pubViewModel.verifyLogin(completion: { isAuthenticated in
            if isAuthenticated {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "segueToMain", sender: self)
                }
            }
        })
    }
    
    deinit {
        deactivateKeyboardListeners()
    }

    @IBAction func authenticate(_ sender: UIButton) {
        guard let pubEmailText = self.pubEmailTextField.text else{
            let alert = CustomExtensions.showAlertView(alertMessage: "Por favor, digite seu e-mail!")
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard let pubPasswordText = self.pubPasswordTextField.text else{
            let alert = CustomExtensions.showAlertView(alertMessage: "Por favor, insira sua senha!")
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        pubViewModel.updatePubEmail(pubEmail: pubEmailText)
        pubViewModel.updatePubPassword(pubPassword: pubPasswordText)
        
        switch pubViewModel.validate() {
        case .Valid:
            self.pubViewModel.login(completion: { errorMessage in
                if let errorMessage = errorMessage{
                    let errorAlert = CustomExtensions.showAlertView(alertMessage: errorMessage)
                    self.present(errorAlert, animated: true, completion: nil)
                }else{
                    self.performSegue(withIdentifier: "segueToMain", sender: self)
                }
            })
        case .Invalid(let errorMessage):
            let alert = CustomExtensions.showAlertView(alertMessage: errorMessage)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // Unwind after logout
    @IBAction func unwindToLoginVC(segue: UIStoryboardSegue){}
    
    // Keyboard listeners:
    func activateKeyboardListeners(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    func deactivateKeyboardListeners(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc func keyboardWillChange(notification: Notification){
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if notification.name == Notification.Name.UIKeyboardWillShow ||
            notification.name == Notification.Name.UIKeyboardWillChangeFrame{
            
            UIView.animate(withDuration: 3, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.backgroundView.layoutIfNeeded()
                self.backgroundViewConstraint.constant = -keyboardRect.height
            },completion: nil)
            
        }else{
            UIView.animate(withDuration: 3, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.backgroundView.layoutIfNeeded()
                self.backgroundViewConstraint.constant = 0
            },completion: nil)
        }
    }
    
}

