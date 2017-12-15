//
//  SplitAmount.swift
//  PayUp
//
//  Created by Aldo Ayala on 11/19/17.
//  Copyright © 2017 Aldo Ayala. All rights reserved.
// checkout

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class SplitAmount: UIViewController {
    
    // User Info Passed in from LoginVC
    var userData: UserInfo!
    

    
    
    let currentUserEmail = Auth.auth().currentUser?.email
    var userEmailArray: [String] = []

    @IBOutlet weak var paymentDesc: UITextField!
    var transactionHistory: Transactions!
    @IBOutlet weak var finalAmount: UILabel!
    @IBOutlet weak var price: UITextField!
    
    let refTransaction = Database.database().reference(withPath: "Transactions")
    let currentUserUid = Auth.auth().currentUser?.uid
    
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func splitWithUserInput(amount: UITextField, splitby: Float) -> Float {
        let userPrice = price.text 
        let priceFloat = Float(userPrice!)
        let timestamp =  NSDate().timeIntervalSinceReferenceDate
//        let usersTosplit = TotalPeople.text
//        let users = Float(usersTosplit!)
      //  userEmailArray.append(currentUserEmail!)
        let amountOfUsers = Float(userEmailArray.count)
        let userDesc = paymentDesc.text
        
        let newListedItemRef = self.refTransaction.child((userDesc?.lowercased())!)
        let newTransaction = Transactions(creator: currentUserEmail!, initialPayment: priceFloat!, splitAmount: priceFloat!/amountOfUsers, description: userDesc, users: userEmailArray, timestamp: timestamp)
        newListedItemRef.setValue(newTransaction.toAnyObject())
        print(priceFloat as Any)
        return priceFloat! / amountOfUsers
    }
        @IBAction func splitEvenly(_ sender: Any) {
            if paymentDesc.text! == "" || price.text == "" {
                let alert = UIAlertController(title: "Error",
                                              message: "Please Fill Out All Fields",
                                              preferredStyle: .alert)
                let oKAction = UIAlertAction(title: "OK",
                                                 style: .default)
                alert.addAction(oKAction)
                present(alert, animated: true, completion: nil)
            } else {
                let current = Auth.auth().currentUser?.email
                userEmailArray.append(current!)
                let splitBy = Float(userEmailArray.count)
                print(splitBy)
          var money = self.splitWithUserInput(amount: price, splitby: splitBy)
          
            
           let thefinalAmount = String("$\(money)")
           finalAmount.text = thefinalAmount
            
            price.resignFirstResponder()
            price.text = ""
           // TotalPeople.text = ""
            paymentDesc.text = ""
            userEmailArray = []
            }
            
    }

    @IBAction func addFriends(_ sender: Any) {
        let alert = UIAlertController(title: "Add Friends Email",
                                      message: "Add Friends To Split",
                                      preferredStyle: .alert)
        
        
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .emailAddress
            textField.autocorrectionType = .no
            textField.autocorrectionType = .default
            textField.placeholder = "Friend Email"
            textField.textColor = UIColor.black
            textField.font = UIFont(name: "Helvetica", size: 18)
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
      //  let cancelAction1 = UIAlertAction(title: "Cancel",
                                       //   style: .default)
        
        let saveAction = UIAlertAction(title: "Add",
                                       style: .default) { action in
                                        guard let textField0 = alert.textFields?[0],
                                            var emailOfNewUser = textField0.text else { return }
                                        print(emailOfNewUser)
                                        if emailOfNewUser == "" {
//                                            let alert1 = UIAlertController(title: "Error",
//                                                                           message: "Invalid Entry",
//                                                                           preferredStyle: .actionSheet)
//                                            //let cancelAction1 = UIAlertAction(title: "Cancel",
//                                                                            // style: .default)
//                                            alert.addAction(cancelAction)
//
//                                            self.present(alert1, animated: true, completion: nil)
                                            self.userEmailArray = []
                                        } else {
                                            print(self.userEmailArray)
                                        self.userEmailArray.append(emailOfNewUser)
                                        print(self.userEmailArray.count)
                                        }
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
}
