//
//  Friend.swift
//  WillChenFriendsDemo
//
//  Created by Will on 2024/1/16.
//

import Foundation

struct Friend: Decodable {
    let name: String
    let status: Int
    let isTop: String
    let fid: String
    var updateDate: String
}
