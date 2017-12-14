//
//  File.swift
//  PayUp
//
//  Created by Aldo Ayala on 11/16/17.
//  Copyright © 2017 Aldo Ayala. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class UserInfo {
    
    let ref: DatabaseReference?
    
    var name: String?
    var uid: String?
    var email: String    
    //var groupId: [String?]
    var timestamp: TimeInterval?
    
    
    init(name: String, uid: String, email: String, timestamp: TimeInterval){
        self.ref = nil
        self.name = name
        self.uid = uid
        self.email = email
       // self.groupId = groupId
        self.timestamp = timestamp
    }

init(snapshot: DataSnapshot) {
    
    let snapshotValue = snapshot.value as! [String:AnyObject]
    name = snapshotValue["name"] as? String ?? "Name not Found"
    email = snapshotValue["email"] as! String
    uid = snapshotValue["uid"] as? String  ?? "Uid not Found"
    //groupId = snapshotValue["groupId"] as? [String?] ?? ["No Group Yet"]
    ref = snapshot.ref
}
    func toAnyObject() -> Any {
        return [
            "name": name ?? "Name not Found",
            "email": email,
            "uid": uid ?? "Uid not Found",
            //"groupId": groupId ?? ["Not Group Yet"],
            "timestamp": timestamp!
        ]
    }
}


struct AddedPayment {
    var title: String
    var amount = Float()
}


