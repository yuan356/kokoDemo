//
//  MenuViewController.swift
//  WillChenFriendsDemo
//
//  Created by Will on 2024/1/23.
//

import UIKit
import RxCocoa
import RxSwift

class MenuViewController: UIViewController {

    @IBOutlet weak var friendWithInviteBtn: UIButton!
    @IBOutlet weak var onlyFriendBtn: UIButton!
    @IBOutlet weak var noFriendBtn: UIButton!
    
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendWithInviteBtn.layer.cornerRadius = 6
        noFriendBtn.layer.cornerRadius = 6
        onlyFriendBtn.layer.cornerRadius = 6

        
        
        friendWithInviteBtn.rx.tap.bind { [weak self] in
            let viewController = FriendViewController()
            viewController.friendListType = .friendWithInvite
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
        .disposed(by: disposeBag)
        
        onlyFriendBtn.rx.tap.bind { [weak self] in
            let viewController = FriendViewController()
            viewController.friendListType = .friends
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
        .disposed(by: disposeBag)
        
        noFriendBtn.rx.tap.bind { [weak self] in
            let viewController = FriendViewController()
            viewController.friendListType = .noFriend
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
        .disposed(by: disposeBag)
    }


}
