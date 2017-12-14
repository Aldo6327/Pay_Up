///
//  ViewController.swift
//  PayUp
//
//  Created by Aldo Ayala on 11/15/17.
//  Copyright © 2017 Aldo Ayala. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
  
    // MARK: Constants
    let refUsers = Database.database().reference(withPath: "Users")
    var myUser: UserInfo!
    var groupInstance: Groups!
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    // MARK: Outlets
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    
    // MARK: Actions
    @IBAction func loginDidTouch(_ sender: AnyObject) {
         Auth.auth().signIn(withEmail: textFieldLoginEmail.text!, password: textFieldLoginPassword.text!)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            // ...
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                // ...
                return
            }
           self.makeGoogleUser()
        }
    }
    func makeGoogleUser() {
       // let defaultId = "No Group Yet"
    let gmailuser = Auth.auth().currentUser?.email
        //print(gmailuser)
        let guid = Auth.auth().currentUser?.uid
        let formatedEmail = gmailuser?.replacingOccurrences(of: ".", with: "_")
          let timestamp1 =  NSDate().timeIntervalSinceReferenceDate
        let newUser = UserInfo(name: formatedEmail!, uid: guid!, email: gmailuser!, timestamp: timestamp1)
        print(newUser)
        self.refUsers.child(formatedEmail!).setValue(newUser.toAnyObject())

    }
    
    @IBAction func signUpDidTouch(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Register",
                                      message: "Register",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
                            let emailField = alert.textFields![0]
                            let passwordField = alert.textFields![1]
                            //let groupIdTextField = alert.textFields![2]
                            Auth.auth().createUser(withEmail: emailField.text!,
                            password: passwordField.text!) { user, error in
                                guard (error == nil) else {
                            print(error?.localizedDescription ?? "a sign-up error occured")
                            return
                        }
                    Auth.auth().signIn(withEmail: self.textFieldLoginEmail.text!,
                    password: self.textFieldLoginPassword.text!)
                   let defaultId = "No Gorup Yet"
                    let timestamp =  NSDate().timeIntervalSinceReferenceDate
                                let newUser = UserInfo(name: (user?.email)!, uid: (user?.uid)!,
                                                       email: (user?.email)!,
                                                       timestamp: timestamp)
                               let formatedEmail = user?.email?.replacingOccurrences(of: ".", with: "_")
                                self.refUsers.child(formatedEmail!).setValue(newUser.toAnyObject())
                }
        }
      //  self.groupInstance.groupId as! String ?? "no Group Yet"
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .emailAddress
            textField.autocorrectionType = .no
            textField.placeholder = "Enter Email"
            textField.textColor = UIColor.black
            textField.font = UIFont(name: "Helvetica", size: 18)
        }
        
        alert.addTextField { textPassword in
            
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
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
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
      
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                // Get Current User Info
                self.findCurrentUserObject()
               // self.makeGoogleUser()
                print(self.findCurrentUserObject())
            }
        }
    }

    func findCurrentUserObject() {
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            
            guard (user != nil) else {
                print("Nobody is loggded in...")
                // push login view
                return
            }
            
            
            // Run the query...Check all uid's and return the one that matches the logged in user?uid
            self.refUsers.queryOrdered(byChild: "uid").queryEqual(toValue: "\(user?.uid  ?? "uid missing")").observe(.value, with: { snapshot in
                
                guard !(snapshot.value is NSNull) else {
                    print("Database Query of User did not Find a Matching User")
                    // push login view
                    return
                }
                
                // Capture the found User Object into the Users Model Instance
                print(snapshot.children.allObjects)
                self.myUser = UserInfo(snapshot: snapshot.children.nextObject() as! DataSnapshot)
                
                // Check that the uid of User Object Instance matches uid of the logged In User
                guard (self.myUser.uid == user?.uid) else {
                    print("User ID (uid) Match Failed")
                    print("Found user id:\n\(self.myUser.uid ?? "missing") \nDoes not match logged in user id: \n\(user?.uid ?? "missing")")
                    return
                }
                
                // Let the console know data from the User Object is now ready
                print("User ID (uid) Matched....\nFound uid: \n\(self.myUser.uid ?? "missing") \nMatches the logged in uid \n\(user?.uid ?? "missing")")
                print("\n***\nUser Data is Ready for:\n \(self.myUser.email)\n***\n")
                
                // Push the Home Screen
                self.performSegue(withIdentifier: "LoginToList", sender: nil)
                
            })
            
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginToList" {
        let tabBarController = segue.destination as! UITabBarController
            let navContoller = tabBarController.viewControllers![0] as! UINavigationController
            let destinationcontroller = navContoller.topViewController as! SplitAmount
            destinationcontroller.userData = myUser
        }
//        if segue.identifier == "LoginToList" {
//            let navController = segue.destination as! UINavigationController
//            let tabBarController = navController as! UITabBarController
//            //            let detailController = tabBarController.viewControllers![0] as! HistoryTVC
//            let detailController = navController.topViewController as! HistoryTVC
//            detailController.userData = myUser
//        }
    }
    
}


extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldLoginEmail {
            textFieldLoginPassword.becomeFirstResponder()
        }
        if textField == textFieldLoginPassword {
            textField.resignFirstResponder()
        }
        return true
    }
    
}

