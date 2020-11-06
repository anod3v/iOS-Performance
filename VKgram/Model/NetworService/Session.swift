//
//  Session.swift
//  LoginForm
//
//  Created by Andrey on 24/09/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import Foundation

class Session {
    
    static let shared = Session()
    
    var token: String?
    var userId: Int?
    
    private init(){}
    
}
