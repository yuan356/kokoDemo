//
//  FriendService.swift
//  WillChenFriendsDemo
//
//  Created by Will on 2024/1/16.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

enum ApiUrl: String {
    case user = "https://dimanyen.github.io/man.json" // 使用者資料
    
    // 只有好友畫面
    case friend1 = "https://dimanyen.github.io/friend1.json" // 好友列表1
    case friend2 = "https://dimanyen.github.io/friend2.json" // 好友列表2
    
    // 好友列表含邀請列表
    case friend3 = "https://dimanyen.github.io/friend3.json"

    // 無資料邀請/好友列表
    case friend4 = "https://dimanyen.github.io/friend4.json"
}



class Service {
    
    func getUser() -> Single<User> {
        return request(ApiUrl.user.rawValue).map({ $0.first ?? User(name: "", kokoid: "") })
    }
    
    func getFriends(api: ApiUrl) -> Single<[Friend]> {
        return request(api.rawValue)
    }
    
    func request<T: Decodable>(_ url: String) -> Single<[T]> {
        
        return Single<[T]>.create { single in
            AF.request(url)
                .responseDecodable(of: APIResponse<T>.self) { response in
                    switch response.result {
                    case .success(let data):
//                        print("call api: \(url)")

                        single(.success(data.response))
                    case .failure(let error):
                        single(.failure(error))
                    }
                }
            return Disposables.create()
        }
    }
}

