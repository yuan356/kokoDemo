//
//  WillChenFriendsDemoTests.swift
//  WillChenFriendsDemoTests
//
//  Created by Will on 2024/1/26.
//

import XCTest
import RxSwift
import RxCocoa
@testable import WillChenFriendsDemo

final class WillChenFriendsDemoTests: XCTestCase {
    
    let disposeBag = DisposeBag()
    
    // 測試只有好友列表頁，好友fid不重複
    func testFriendsＮotDuplicate() {
        let friendViewModel = FriendViewModel(fetchFriendsTrigger: Observable<Void>.empty(), friendType: .friends, searchTextObservable: Observable<String>.empty())
        
        let promise = expectation(description: "Network error")
        friendViewModel.friends.drive { friends in
            promise.fulfill()

            let uniqueFids = Set(friends.map { $0.fid })

            let isUnique = (uniqueFids.count == friends.count)

            XCTAssert(isUnique)
        }
        .disposed(by: disposeBag)
        
        wait(for: [promise], timeout: 8)
    }
    
    // 測試能得到使用者名稱
    func testUserNamw() {
        let userViewModel = UserViewModel()
        let promise = expectation(description: "Network error")
        userViewModel.username.drive {
            promise.fulfill()
            XCTAssert(!$0.isEmpty)
        }.disposed(by: disposeBag)
        wait(for: [promise], timeout: 8)
    }
}
