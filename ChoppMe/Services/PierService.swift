//
//  PierService.swift
//  ChoppMe
//
//  Created by Rodrigo de Sousa Santos on 05/01/2019.
//  Copyright © 2019 Rodrigo de Sousa Santos. All rights reserved.
//

import Foundation
import Firebase

protocol PierServiceProtocol {
    func fetchCurrentOrders(dbRef: DocumentReference, completion: @escaping (Bool, Double?, Double?, Double?) -> ())
}

class PierService: PierServiceProtocol {
    var dbRef: DocumentReference!
    
    // Mock path:
    let db = Firestore.firestore()
    //dbRef = db.document("/clientes/barTeste/core/piers/pierA/mesa1")
    
    func fetchCurrentOrders(dbRef: DocumentReference, completion: @escaping (Bool, Double?, Double?, Double?) -> ()) {
        
        self.dbRef = dbRef
        var current350quantity = 0.0
        var current500quantity = 0.0
        var currentTotal = 0.0
        
        dbRef.getDocument(completion: { (docSnapshot, error) in
            guard let docSnapshot = docSnapshot, docSnapshot.exists
                else{
                    completion(false, nil, nil, nil)
                    return
            }
            let serverData = docSnapshot.data()
            current350quantity = serverData!["qtde350"]! as! Double
            current500quantity = serverData!["qtde500"]! as! Double
            currentTotal = serverData!["total"]! as! Double
            
            completion(true, current350quantity, current500quantity, currentTotal)
        })
    }
}
