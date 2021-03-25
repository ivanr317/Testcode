//
//  SessionStore.swift
//  UnderDog Prototype
//
//  Created by John Lee on 3/11/21.
//

import SwiftUI
import Firebase
import Combine
import FirebaseDatabase //Storing items to database 

class SessionStore: ObservableObject { 
    var ref:FIRDatabaseReference!  
        ref = FIRbaseDatabase.database().Reference()//Storing items to database    
    var didChange = PassthroughSubject<SessionStore, Never>()
    @Published var session: User? {didSet {self.didChange.send(self) }}
    var handle: AuthStateDidChangeListenerHandle?
    func listen() {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let user = user {
                self.session = User(uid: user.uid, email: user.email)
            } else {
                self.session = nil
            }
        })
    }
    func signUp(email: String, password: String, handler: @escaping AuthDataResultCallback){
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    func signIn(email: String, password: String, handler: @escaping AuthDataResultCallback){
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    func resetPassword(email: String){
        Auth.auth().sendPasswordReset(withEmail: email)
    }
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.session = nil
        } catch {
            print("Error signing out")
        }
    }
    func unbind(){
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    deinit {
        unbind()
    }
}

    self.ref.child("Users").child(user.uid).setValue(["Email": Email]) //Otherway to store data into realtime database
struct User {
    var uid: String
    var email: String?
    init(uid: String, email: String?) {
        self.uid = uid
        self.email = email
    }
}
