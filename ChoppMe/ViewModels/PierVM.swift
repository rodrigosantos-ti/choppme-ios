//
//  PierVM.swift
//  ChoppMe
//
//  Created by Rodrigo de Sousa Santos on 22/12/2018.
//  Copyright © 2018 Rodrigo de Sousa Santos. All rights reserved.
//

import Foundation
import Firebase

class PierVM {
//    private var pier: Pier //= Pier()
//    let apiService: APIServiceProtocol
    var dbRef: DocumentReference!
    
//    var satellites: [Satellite] {
//        return pier.satellites
//    }
//    var status: Bool {
//        return pier.status
//    }
    
    
//    init( apiService: APIServiceProtocol = APIService()) {
//        self.apiService = apiService
//    }
}

// MARK: Public Methods
extension PierVM {
    
    // MARK -> Database Methods:
    func fetchCurrentData(completion: @escaping (Bool, Double?, Double?, Double?) -> ()){
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
    
    func saveData(updatedQuantity350: Double, updatedQuantity500: Double, updatedTotal: Double){
        let dataToSave: [String: Any] = [
            "qtde350": updatedQuantity350,
            "qtde500": updatedQuantity500,
            "total": updatedTotal
        ]
        dbRef.setData(dataToSave, merge: true, completion: { (error) in
            if let error = error{
                print("Erro ao salvar os dados!", error.localizedDescription)
            }else{
                // TODO: Probably reload tableview data!
                print("Dados salvos com sucesso!!")
            }
        })
    }
    
    func addChopp350(pierId: String, satellitte: String, quantity: Int){
        var updatedQuantity350 = 0.0
        var updatedQuantity500 = 0.0
        var updatedTotal = 0.0
        self.fetchCurrentData(completion: {(hasSuccess, fetchedQuantity350, fetchedQuantity500, fetchedTotal) in
            switch(hasSuccess){
            case true:
                updatedQuantity350 = fetchedQuantity350! + (Double(quantity) * 0.35)
                updatedQuantity500 = fetchedQuantity500!
                updatedTotal = fetchedTotal! + (Double(quantity) * 0.35)
                self.saveData(updatedQuantity350: updatedQuantity350, updatedQuantity500: updatedQuantity500, updatedTotal: updatedTotal)
            case false:
                print("Erro ao recuperar dados do servidor")
            default:
                print("Erro de servidor")
            }
        })
    }
    
    func addChopp500(pierId: String, satellitte: String, quantity: Int){
        var updatedQuantity350 = 0.0
        var updatedQuantity500 = 0.0
        var updatedTotal = 0.0
        self.fetchCurrentData(completion: {(hasSuccess, fetchedQuantity350, fetchedQuantity500, fetchedTotal) in
            switch(hasSuccess){
            case true:
                updatedQuantity350 = fetchedQuantity350!
                updatedQuantity500 = fetchedQuantity500! + (Double(quantity) * 0.5)
                updatedTotal = fetchedTotal! + (Double(quantity) * 0.5)
                self.saveData(updatedQuantity350: updatedQuantity350, updatedQuantity500: updatedQuantity500, updatedTotal: updatedTotal)
            case false:
                print("Erro ao recuperar dados do servidor")
            default:
                print("Erro de servidor")
            }
        })
    }
}
