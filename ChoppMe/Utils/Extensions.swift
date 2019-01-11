//
//  Extensions.swift
//  ChoppMe
//
//  Created by Rodrigo de Sousa Santos on 07/01/2019.
//  Copyright © 2019 Rodrigo de Sousa Santos. All rights reserved.
//

import Foundation
import SVProgressHUD

struct CustomExtensions {
    static func createAndShowSpinner(){
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.colorTransparent())
        SVProgressHUD.show()
    }
    
    static func showAlertView(alertMessage: String) -> UIAlertController{
        SVProgressHUD.dismiss()
        let alert = UIAlertController(title: "Alerta", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        let defaultAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        alert.addAction(defaultAction)
        return alert
    }
    
}

public extension UIColor {
    static func colorTransparent() -> UIColor {
        return UIColor(white: 0xFFFFFF, alpha: 0.00)
    }
}
