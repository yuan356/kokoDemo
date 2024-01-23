//
//  UserViewModel.swift
//  WillChenFriendsDemo
//
//  Created by Will on 2024/1/17.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class UserViewModel {

    let username: Driver<String>
    
    let kokoid: Driver<String>
    
    let userService = Service()
    
    init() {
        let userObservable = userService.getUser()
            .asObservable().share(replay: 1)
        self.username = userObservable
            .map { $0.name }
            .asDriver(onErrorJustReturn: "")

        self.kokoid = userObservable
            .map { "KOKO ID：\($0.kokoid)" }
            .asDriver(onErrorJustReturn: "設定 KOKO ID")
    }
}

