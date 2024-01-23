//
//  FriendViewModel.swift
//  WillChenFriendsDemo
//
//  Created by Will on 2024/1/18.
//

import Foundation
import RxCocoa
import RxSwift

enum FriendType {
    case noFriend
    case friends
    case friendWithInvite
}

class FriendViewModel {
    
    var friends: Driver<[Friend]>
    
    var friendsForTable = PublishSubject<[Friend]>()
    
    var friendsInvited: Driver<[Friend]> = Driver.empty()
    
    var friendStatus2Count: Driver<String>
    
    var friendStatus2IsHidden: Driver<Bool>
        
    let searchSubject = PublishSubject<String>()
    
    var originalFriends = [Friend]()

    init(fetchFriendsTrigger: Observable<Void>, friendType: FriendType, searchTextObservable: Observable<String>) {
        
        let service = Service()
                
        switch friendType {
        case .noFriend, .friendWithInvite:
            let apiType: ApiUrl = (friendType == .noFriend) ? .friend4 : .friend3
            self.friends = fetchFriendsTrigger
                .startWith(())
                .flatMapLatest {
                    service.getFriends(api: apiType)
                }
                .asDriver(onErrorJustReturn: [])
            
            if friendType == .friendWithInvite {
                self.friendsInvited = friends
                    .map({ $0.filter({ $0.status == 0 }) })
                    .asDriver(onErrorJustReturn: [])
            }
            
            self.friends = friends
                    .map({ $0.filter({ $0.status != 0 }) }) // filter status != 0
            
        case .friends:
            let friend1 = service.getFriends(api: .friend1)
            let friend2 = service.getFriends(api: .friend2)
            self.friends = fetchFriendsTrigger
                .startWith(())
                .flatMapLatest {
                    Observable.zip(friend1.asObservable(), friend2.asObservable())
                    { friend1, friend2 in
                        return friend1 + friend2
                    }
                    .map({
                        $0.map({
                            var new = $0
                            new.updateDate = $0.updateDate.replacingOccurrences(of: "/", with: "")
                            return new
                        })
                    })
                    .map({ allFriends in
                        var uniqueFriends = [String: Friend]()
                        for friend in allFriends {
                            if let existingFriend = uniqueFriends[friend.fid] {
                                if friend.updateDate > existingFriend.updateDate {
                                    uniqueFriends[friend.fid] = friend
                                }
                            } else {
                                uniqueFriends[friend.fid] = friend
                            }
                        }
                        let mergedFriends = Array(uniqueFriends.values)
                        return mergedFriends
                    })
                }
                .asDriver(onErrorJustReturn: [])
        }
                
        self.friendStatus2Count = friends.map({
            var count = 0
            for friend in $0 {
                if friend.status == 2 {
                    count += 1
                }
            }
            return "\(count)"
        }).asDriver(onErrorJustReturn: "")
        
        
        self.friendStatus2IsHidden = friendStatus2Count.map({
            Int($0)! <= 0
        }).asDriver(onErrorJustReturn: true)
    }
    
    func searchFriend(with name: String) {
        if name.isEmpty {
            friendsForTable.onNext(originalFriends)
            return
        }
        
        let filteredFriends = originalFriends.filter { $0.name.contains(name) }
        friendsForTable.onNext(filteredFriends)
    }
}
