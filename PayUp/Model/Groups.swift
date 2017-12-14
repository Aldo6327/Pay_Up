//
//  Groups.swift
//  PayUp
//
//  Created by Aldo Ayala on 11/27/17.
//  Copyright © 2017 Aldo Ayala. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Groups {
   // var myUsers: [UserInfo]
    
    
    let ref: DatabaseReference?
    //var email: String?
    var groupName: String?
    var groupId: String?
    var timeStamp: TimeInterval?
    var users: [String]
    
    init(groupName: String, groupId: String, timeStamp: TimeInterval, users: [String]) {
      //  self.email = email
        self.groupName = groupName
        self.groupId = groupId
        self.timeStamp = timeStamp
        self.users = users
        self.ref = nil
    }
    init(snapshot: DataSnapshot){
        ref = snapshot.ref
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
       // email = snapshotValue["email"] as? String ?? "no email"
        groupName = snapshotValue["groupName"] as? String ?? "No Group"
        groupId = snapshotValue["groupId"] as? String ?? "No GroupId"
        timeStamp = snapshotValue["timeStamp"] as? Double
        users = snapshotValue["users"] as? [String] ?? ["No user yet"]
    }
    
    func toAnyObject() -> Any {
        return [
          //  "email": email ?? "no email",
            "groupName": groupName ?? "Group Name not Found",
            "groupId": groupId ?? "Group Id not Found",
            "timeStamp": timeStamp ?? 0.00,
            "users": users ?? "no users yet"
         
        ]
    }

}
