//
//  LoginService.swift
//  ChoppMe
//
//  Created by Rodrigo de Sousa Santos on 05/01/2019.
//  Copyright © 2019 Rodrigo de Sousa Santos. All rights reserved.
//

import Foundation
import FirebaseAuth

struct LoginService {
    
    static var isAuthenticated = false
    
    static func authenticatePub(pubEmail: String, pubPassword: String, completion: @escaping (Bool) -> Void){
        CustomExtensions.createAndShowSpinner()
        Auth.auth().signIn(withEmail: pubEmail, password: pubPassword, completion: { (user, error) in
            if let currentPub = user {
                LoginService.savePubLocally(currentPub: currentPub)
                isAuthenticated = true
                completion(true)
            }else{
                print("Error to login pub. Please, try again...")
                print(error!)
                completion(false)
            }
        })
        
    }
    
    static func signOutPub(completion: @escaping (Bool) -> ()){
        CustomExtensions.createAndShowSpinner()
        do{
            try Auth.auth().signOut()
            isAuthenticated = false
            completion(true)
        }catch let signOutError as NSError {
            print("Error signing out: ", signOutError)
            completion(false)
        }
    }
    
    static func verifyLogin() -> Bool{
        let userDefaults = UserDefaults.standard
        if let isAuthenticated = userDefaults.value(forKey: "isAuthenticated"){
            return isAuthenticated as! Bool
        }else{
            return false
        }
    }
    
}

extension LoginService {
    static func savePubLocally(currentPub: AuthDataResult){
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(true, forKey: "isAuthenticated")
        userDefaults.setValue(currentPub.user.uid, forKey: "pubUid")
        userDefaults.setValue(currentPub.user.email, forKey: "pubEmail")
        userDefaults.synchronize()
//        currentPub.user.getIDToken(completion: <#T##AuthTokenCallback?##AuthTokenCallback?##(String?, Error?) -> Void#>)
//        userDefaults.setValue(currentPub.user., forKey: "pubEmail")
    }
}
