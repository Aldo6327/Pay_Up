//
//  Transactions.swift
//  PayUp
//
//  Created by Aldo Ayala on 12/3/17.
//  Copyright © 2017 Aldo Ayala. All rights reserved.
//
// lets get it to work

import Foundation
import FirebaseDatabase

class Transactions {
    
     let ref: DatabaseReference?
    var creator: String
    var initialPayment: Float
    var splitAmount: Float
    var description: String?
    var users: [String]
    var timestamp: TimeInterval?
    
    init(creator: String, initialPayment: Float, splitAmount: Float, description: String?, users: [String], timestamp: TimeInterval?) {
        self.ref = nil
        self.creator = creator
        self.initialPayment = initialPayment
        self.splitAmount = splitAmount
        self.description = description
        self.users = users
        self.timestamp = timestamp
        
    }
    init(snapshot: DataSnapshot) {
        ref = snapshot.ref
        let snapshotValue = snapshot.value as! [String: AnyObject]
        creator = snapshotValue["creator"] as? String ?? "no creator"
        initialPayment = snapshotValue["initialPayment"] as? Float ?? 0.00
        splitAmount = snapshotValue["splitAmount"] as? Float ?? 0.00
        description = snapshotValue["description"] as? String ?? "Item To Split"
        users = snapshotValue["users"] as? [String] ?? ["No users"]
        timestamp = snapshotValue["timestamp"] as? Double
    }
    func toAnyObject() -> Any {
        return [
            //  "email": email ?? "no email",
            "creator": creator ?? "creator email",
            "initialPayment": initialPayment ?? "Initial Payment not Found",
            "splitAmount": splitAmount ?? "No Payment",
            "description": description ?? "description not Found",
            "users": users ?? "not users",
            "timeStamp": timestamp ?? 0.00
            
        ]
    }

}
