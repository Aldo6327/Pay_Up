//
//  HistoryTVC.swift
//  PayUp
//
//  Created by Aldo Ayala on 11/21/17.
//  Copyright © 2017 Aldo Ayala. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HistoryTVC: UITableViewController {
    
    var transaction: [Transactions] = []
   
    
    
    let refTransaction = Database.database().reference(withPath: "Transactions")
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        if ConnectionCheck.isConnectedToNetwork() {
            print("Network is Reachable :-)")
        } else {
            //                        ConnectionCheck.isConnectedToNetwork()
            print("Network is NOT Reachable :-(")
            let alertController = UIAlertController(title: "Network Issue",
                                                    message: "NOT CONNECTED TO INTERNET",
                                                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK",
                                                    style: .default,
                                                    handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        self.updateCell()
        //self.trythis()
        //self.checkIfItWorks()
       // self.hope()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return transaction.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryTVCell
        let floatValueT = String(transaction[indexPath.row].splitAmount)
        let stringTotal = String(transaction[indexPath.row].initialPayment)
        cell.titleOfTransaction.text = transaction[indexPath.row].description
        cell.finalAmount.text = floatValueT
        cell.createdBy.text = transaction[indexPath.row].creator
        cell.totalAmount.text = stringTotal
        return cell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func updateCell() {
        let currentUserEmail = Auth.auth().currentUser?.email
//        refTransaction.queryOrdered(byChild: "users").queryEqual(toValue: currentUserEmail)
//        refTransaction.queryOrdered(byChild: "description").observe(.value, with: { snapshot in
//
//            self.refTransaction.queryOrdered(byChild: "users/0").queryEqual(toValue: "\(currentUserEmail ?? "uid not found")").observe(.value, with: { snapshot in
       
        refTransaction.queryOrdered(byChild: "timeStamp").observe(.value, with: { snapshot in
            self.transaction = []
            print(snapshot)
            for item in snapshot.children {
                print(item)
                let group = Transactions(snapshot: item as! DataSnapshot)
                print(group)
                if group.users != nil {
                    for bidder in group.users {
                        if (bidder == currentUserEmail) {
                            print(self.transaction.description)
                            self.transaction.append(group)
                        }
                    }
                }
                //self.transaction.append(group)
                self.tableView.reloadData()
            }
            
        })
    }
    
//    func trythis() {
//        let current = Auth.auth().currentUser?.email
//        self.refTransaction.queryOrdered(byChild: "creator").observe(.value, with: { snapshot in
//            let user = self.refTransaction.queryOrdered(byChild: "user").queryEqual(toValue: current)
//            print(user)
//            if user == nil {
//                return
//            } else {
//                print("yes")
//            }
//        })
//        //self.refTransaction.queryOrderd
//    }
    
    
//    func hope() {
//    var ref: DatabaseReference!
//    ref = Database.database().reference()
//    var membersArray = [String]()
//
//
//    ref.child("Transactions").observeSingleEvent(of: .value, with: { (snapshot) in
//    if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
//    print(snapshots)
//    for snap in snapshots
//    {
//        let teacher = Auth.auth().currentUser?.email as! String
//        print(teacher)
//    //let teacher = snap.childSnapshot(forPath: "creator").value as! String
//    ref.child("Transactions").child(snap.key).child("users").observeSingleEvent(of: .value, with: { (member) in
//    if let members = member.children.allObjects as? [DataSnapshot] {
//    print(member)
//    for mem in members
//    {
//    print(mem.value as! String)
//    let currentMember = mem.value as! String
//    membersArray.append(currentMember)
//    }
//    }
//
//    if(membersArray.contains(teacher))
//    {
//    print(membersArray)
//    }
//    })
//    }
//    if product.bidders != nil {
//    for bidder in product.bidders! {
//    if (bidder == "Wassay") {
//    print(product.name)
//    self.productList.append(product)
//    }
//    }
//    }
//    }
//    })
//    }
}
