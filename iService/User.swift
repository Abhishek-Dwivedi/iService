//
//  User.swift
//  iService
//
//  Created by Abhishek Dwivedi on 19/06/16.
//  Copyright © 2016 Abhishek Dwivedi. All rights reserved.
//

import Foundation

//User Model
struct User {
    private var _isCustomer: Bool?
    private var _userId: String?
    
    var isCustomer: Bool {
        return _isCustomer!
    }
    
    var userId: String {
        return _userId!
    }
    
    init(userId: String, dict: [String: AnyObject]) {
        self._userId = userId
        if let isCustomer = dict["isCustomer"] as? Bool {
            self._isCustomer = isCustomer
        }
    }
}
