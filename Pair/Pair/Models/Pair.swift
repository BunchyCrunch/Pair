//
//  Pair.swift
//  Pair
//
//  Created by Josh Sparks on 10/25/19.
//  Copyright © 2019 Josh Sparks. All rights reserved.
//

import Foundation
import CloudKit

struct PairStrings {
    static let recordTypeKey = "Pair"
    fileprivate static let nameKey = "name"
}

class Pair {
    var name: String
    var ckRecordID: CKRecord.ID
    
    init(name: String, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.name = name
        self.ckRecordID = ckRecordID
    }
}

extension Pair {
    convenience init? (ckRecord: CKRecord) {
        guard let name = ckRecord[PairStrings.nameKey] as? String else { return nil }
        
        self.init(name: name)
    }
}

extension Pair: Equatable {
    static func == (lhs: Pair, rhs: Pair) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
}

extension CKRecord {
    convenience init(name: Pair) {
        self.init(recordType: PairStrings.recordTypeKey, recordID: name.ckRecordID)
        
        self.setValuesForKeys([
            PairStrings.nameKey : name.name
        ])
    }
}
