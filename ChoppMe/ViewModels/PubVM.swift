//
//  PubVM.swift
//  ChoppMe
//
//  Created by Rodrigo de Sousa Santos on 08/01/2019.
//  Copyright © 2019 Rodrigo de Sousa Santos. All rights reserved.
//

import Foundation
import SVProgressHUD

enum PubValidationState {
    case Valid
    case Invalid(String)
}

class PubVM {
    private let minPasswordLength = 7
    private var pub = Pub()
    
    init(pub: Pub = Pub()) {
        self.pub = pub
    }
}

extension PubVM {
    
    func updatePubEmail(pubEmail: String){
        self.pub.pubEmail = pubEmail
    }
    
    func updatePubPassword(pubPassword: String){
        self.pub.pubPassword = pubPassword
    }
    
    func validate() -> PubValidationState {
        if pub.pubEmail.isEmpty || pub.pubPassword.isEmpty {
            return .Invalid("E-mail e senha são obrigatórios.")
        }
        
        if pub.pubPassword.count < minPasswordLength {
            return .Invalid("A senha requer no mínimo \(minPasswordLength) caracteres.")
        }
        
        return .Valid
    }
    
    func login(completion: @escaping (String?) -> Void) {
        LoginService.authenticatePub(pubEmail: pub.pubEmail, pubPassword: pub.pubPassword, completion: { isAuthenticated in
            if isAuthenticated {
                SVProgressHUD.dismiss()
                completion(nil)
            }else{
                completion("Erro de autenticação! Credenciais inválidas.")
            }
        })
    }
    
    func logout(completion: @escaping (String?) -> Void){
        LoginService.signOutPub(completion: { isLoggedOut in
            if isLoggedOut {
                SVProgressHUD.dismiss()
                completion(nil)
            }else{
                completion("Erro ao tentar desconectar a conta. Por favor, tente novamente!")
            }
        })
    }
    
    func verifyLogin(completion: @escaping (Bool) -> Void){
        let isAuthenticated = LoginService.verifyLogin()
        completion(isAuthenticated)
    }
    
}
