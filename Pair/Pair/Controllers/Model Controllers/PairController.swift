//
//  PairController.swift
//  Pair
//
//  Created by Josh Sparks on 10/25/19.
//  Copyright © 2019 Josh Sparks. All rights reserved.
//

import Foundation
import CloudKit

class PairController {
    
    
    static let shared = PairController()
    let publicDB = CKContainer.default().publicCloudDatabase
    var pairs: [Pair] = []
    
    func addName(with name: String, completion: @escaping (_ success: Bool) -> (Void)) {
        let newName = Pair(name: name)
        let nameRecord = CKRecord(name: newName)
        
        publicDB.save(nameRecord) { (record, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(false)
                return
            }
            
            guard let record = record,
                let savedName = Pair(ckRecord: record) else { completion(false) ; return }
            self.pairs.append(savedName)
            print("Saved name successfully")
            completion(true)
        }
        
    }
    
    func removeName(with name: Pair) {
        guard let nameIndex = pairs.firstIndex(of: name) else { return }
        pairs.remove(at: nameIndex)
    }
    
    func updateName(_ name: Pair, completion: @escaping (_ success: Bool) -> (Void)) {
        let recordToUpdate = CKRecord(name: name)
        let operation = CKModifyRecordsOperation(recordsToSave: [recordToUpdate], recordIDsToDelete: nil)
        
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { records, _, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            guard recordToUpdate == records?.first else {
                print("Unexpected record was updated")
                completion(false)
                return
            }
            
            print("Updated \(recordToUpdate.recordID) successfully in CloudKit")
            completion(true)
        }
        publicDB.add(operation)
    }
    
    func fetchName(completion: @escaping (_ success: Bool) -> (Void)) {
           let predicate = NSPredicate(value: true)
             
             let query = CKQuery(recordType: PairStrings.recordTypeKey, predicate: predicate)
             
             publicDB.perform(query, inZoneWith: nil) { (foundRecords, error) in
                 if let error = error {
                     print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                     completion(false)
                     return
                 }
                 
                 guard let records = foundRecords else { completion(false) ; return }
                 let pairs = records.compactMap( { Pair(ckRecord: $0) } )
                 self.pairs = pairs
                 completion(true)
             }
         }
    
    func randomize(pairs: Pair) -> [Pair] {
        var pairs = self.pairs
        return pairs.shuffled()
       }
    
} // end of class
