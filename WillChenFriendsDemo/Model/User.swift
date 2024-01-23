//
//  User.swift
//  WillChenFriendsDemo
//
//  Created by Will on 2024/1/16.
//

import Foundation

struct APIResponse<T: Decodable>: Decodable {
    let response: [T]
}

struct User: Decodable {
    let name: String
    let kokoid: String
}
