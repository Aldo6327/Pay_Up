//
//  HomePageTVC.swift
//  PayUp
//
//  Created by Aldo Ayala on 11/15/17.
//  Copyright © 2017 Aldo Ayala. All rights reserved.
//
import FirebaseDatabase
import UIKit
import FirebaseAuth

class HomePageTVC: UITableViewController {

    var groupNames: [Groups] = []
    var myUser: UserInfo?
    var groupInstance: Groups!

    let refGroups = Database.database().reference(withPath: "Groups")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.upateGroupsInTableView()
       // self.UpdateTV()
       // self.updateTableview()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
       // self.update()
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
       // self.isThisUserHere()
        self.hopefully()
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groupNames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupcell", for: indexPath)
//        let groupsName = groupName[indexPath.row]
        //print(placeholder)
        cell.textLabel?.text = groupNames[indexPath.row].groupName
        // Configure the cell...

        return cell
    }
    func isThisUserHere(){
        let currentUser = Auth.auth().currentUser?.uid
       let ref1 = Database.database().reference()
        ref1.observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot.childrenCount) // I got the expected number of items
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
               print(rest.value)
//                for i in rest.value{
//
//                }
                 let dictionary = rest.value as? [String:Any]
                let user = dictionary!["u"]
                    print(user)
                    
                
            }
        })
    }
    func hopefully() {
        let currentUser = Auth.auth().currentUser?.uid
        let groupUser = refGroups.queryOrdered(byChild: "users").queryEqual(toValue: currentUser)
        print(groupUser)
       // groupInstance.users = groupUser as [String]
        if refGroups.queryOrdered(byChild: "user").queryEqual(toValue: currentUser) != nil {
            refGroups.queryOrdered(byChild: "groupName").observe(.value, with: { snapshot in
                self.groupNames = []
                for item in snapshot.children {
                    let group = Groups(snapshot: item as! DataSnapshot)
                    self.groupNames.append(group)
                    self.tableView.reloadData()
                }
                
            })
        }
//        for i in groupUser {
//            if currentUser == i {
//                print(i)
//            } else {
//                print("Didnt work dummie")
//            }
//        }
    }
    func upateGroupsInTableView() {
        let currentUser = Auth.auth().currentUser?.uid
//        for i in refGroups {
//
//        }
        let userRef = refGroups.queryOrdered(byChild: "users").queryEqual(toValue: currentUser )
        print(userRef)
      
            refGroups.queryOrdered(byChild: "groupName").observe(.value, with: { snapshot in
                self.groupNames = []
                for item in snapshot.children {
                    let group = Groups(snapshot: item as! DataSnapshot)
                    self.groupNames.append(group)
                    self.tableView.reloadData()
                }
                
            })
        
     
    }


//    func update () {
//        let userId = Auth.auth().currentUser?.uid
//        self.refGroups.child("groupName").child(userId!).observeSingleEvent(of: .value, with: { (snapshot) in
//            let snapshotValue: Dictionary = snapshot.value as! Dictionary {
//                for snapDict in snapshotValue {
//                    let dict = snapDict as! Dictionary <String, Any>
//                    print(dict)
//                }
//            }
//        })
//    }
//    func updateTableview() {
//        refGroups.queryOrdered(byChild: "users").observe(.value) { (snapshot) in
//            print(snapshot.value)
//            let usersValue = snapshot.value
//
//            if Auth.auth().currentUser?.uid == snapshot.value as? String {
//                self.refGroups.queryOrdered(byChild: "groupName").observe(.value, with: { (snapshot) in
//                    self.groupNames = []
//                    for item in snapshot.children {
//                        let group = Groups(snapshot: item as! DataSnapshot)
//                        self.groupNames.append(group)
//                        self.tableView.reloadData()
//                    }
//                })
//            } else {
//
//    //            groupNames.append("No groups Yet")
//            }
//        }
//    }

    @IBAction func addButtonDidTouch(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Add Group",
                                      message: "Group Name",
                                      preferredStyle: .alert)
        
        
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Group Name"
            textField.textColor = UIColor.black
            textField.font = UIFont(name: "Helvetica", size: 18)
        }

        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Group ID"
            textField.textColor = UIColor.black
            textField.font = UIFont(name: "Helvetica", size: 18)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
                                        guard let textField0 = alert.textFields?[0],
                                            var nameOfNewGroup = textField0.text else { return }
                                        if nameOfNewGroup.isEmpty {
                                            nameOfNewGroup = "New Group"
                                            //saveAction.resignFirstResponder()
                                            
                                            
                                        }
                                        guard let textField1 = alert.textFields?[1],
                                            var customGroupId = textField1.text else { return }
                                        if customGroupId.isEmpty {
                                            customGroupId = "DefaultID"
                                        }
                                        
                                        let timestamp =  NSDate().timeIntervalSinceReferenceDate
                                        var myusers = Auth.auth().currentUser?.uid
                                        let newListedItemRef = self.refGroups.child((nameOfNewGroup.lowercased()))
                                        
                                        let newGroup = Groups(groupName: nameOfNewGroup, groupId: customGroupId, timeStamp: timestamp, users: [myusers!])
                                        
                                        //self.refGroups.setValue(newGroup.toAnyObject())
                                        //.append(nameOfNewGroup)
                                        newListedItemRef.setValue(newGroup.toAnyObject())
                                        self.tableView.reloadData()
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func signoutButton(_ sender: AnyObject) {
        do {
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            
        }
    }
//    func appendUserToGroup() {
//        var myusers = Auth.auth().currentUser?.email
//        var myArray = groupInstance.users
//        myArray.append(myusers)
//    }
}
