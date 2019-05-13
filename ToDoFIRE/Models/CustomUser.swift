//
//  User.swift
//  ToDoFIRE
//
//  Created by Игорь on 5/13/19.
//  Copyright © 2019 Igor Zhyzhyrii. All rights reserved.
//

import Foundation
import Firebase

struct CustomUser {
    
    let uid: String
    let email: String
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email!
    }
}
