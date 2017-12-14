//
//  InviteFriendsTVC.swift
//  PayUp
//
//  Created by Aldo Ayala on 11/30/17.
//  Copyright © 2017 Aldo Ayala. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import GoogleSignIn
import FirebaseInvites

class InviteFriendsTVC: UITableViewController, InviteDelegate {

    
    var myUser: UserInfo!
    var theGroup: Groups!
    let ref = Database.database().reference(withPath: "Users")
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
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
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InviteFriends", for: indexPath)

        // Configure the cell...

        return cell
    }
    
    func addNewUsersToGroup() {
        let time = theGroup.timeStamp
        let id = time
        ref.child("email").child("Groups").child("timeStamp")
        
        
    }
    @IBAction func inviteTapped(_ sender: AnyObject) {
        if let invite = Invites.inviteDialog() {
            invite.setInviteDelegate(self)
            
            // NOTE: You must have the App Store ID set in your developer console project
            // in order for invitations to successfully be sent.
            
            // A message hint for the dialog. Note this manifests differently depending on the
            // received invitation type. For example, in an email invite this appears as the subject.
            invite.setMessage("Try this out!\n -\(GIDSignIn.sharedInstance().currentUser.profile.name)")
            print("HERE... ", GIDSignIn.sharedInstance().currentUser.profile.name)
            // Title for the dialog, this is what the user sees before sending the invites.
            invite.setTitle("Invites Example")
            invite.setDeepLink("https://g2uqu.app.goo.gl/qbvQ")
            invite.setCallToActionText("Install!")
            invite.setCustomImage("https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png")
            invite.open()
        }
    }
    func inviteFinished(withInvitations invitationIds: [String], error: Error?) {
        if let error = error {
//            let alert = UIAlertController(title: "Error", message: "Message Not Sent", preferredStyle: .alert)
//            let okAction = UIAlertAction(
            print("Failed: " + error.localizedDescription)
        } else {
            print("\(invitationIds.count) invites sent")
        }
    }
 
}
