//
//  FriendViewController.swift
//  WillChenFriendsDemo
//
//  Created by Will on 2024/1/17.
//

import UIKit
import RxSwift
import RxCocoa

private let USER_VIEW_HEIGHT_DEFAULT: CGFloat = 136

class FriendViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var friendTableView: UITableView!
    @IBOutlet weak var goBackBtn: UIButton!
    @IBOutlet weak var searchViewHeight: NSLayoutConstraint!
    @IBOutlet weak var searchView: UIView!
    
    var userViewHeight: NSLayoutConstraint!
    
    let userViewModel = UserViewModel()
    
    let myUserView = UserView()
    
    var friendViewModel: FriendViewModel!
    
    let disposeBag = DisposeBag()
    
    let fetchFriendsTrigger = PublishSubject<Void>()
    
    let refreshControl = UIRefreshControl()
    
    var tableViewEmptyView: UIView!
    
    var refreshTrigger: Observable<Void>!
    
    var friendListType: FriendType!
    
    var heightForInvited: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        setUI()
        
        setTableView()
        
        refreshTrigger = refreshControl.rx.controlEvent(.valueChanged).asObservable()
        
        friendViewModel = FriendViewModel(fetchFriendsTrigger: refreshTrigger, friendType: friendListType, searchTextObservable: searchBar.rx.text.orEmpty.asObservable())
        
        bindViewModel()
    }
    
    private func setUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        tapGesture.rx.event.bind(onNext: { [weak self] _ in 
            self?.view.endEditing(true)
        }).disposed(by: disposeBag)

        self.view.addSubview(myUserView)
        myUserView.backgroundColor = .brown
        myUserView.translatesAutoresizingMaskIntoConstraints = false
        myUserView.topAnchor.constraint(equalTo: userView.topAnchor).isActive = true
        myUserView.bottomAnchor.constraint(equalTo: userView.bottomAnchor).isActive = true
        myUserView.leftAnchor.constraint(equalTo: userView.leftAnchor).isActive = true
        myUserView.rightAnchor.constraint(equalTo: userView.rightAnchor).isActive = true
        
        userViewHeight = myUserView.heightAnchor.constraint(equalToConstant: USER_VIEW_HEIGHT_DEFAULT)
        userViewHeight.isActive = true
        
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.searchFieldBackgroundPositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        
        tableViewEmptyView = createEmptyView()
    }
    
    private func bindViewModel() {
        
        userViewModel.username.drive(myUserView.nameLabel.rx.text).disposed(by: disposeBag)
        userViewModel.kokoid.drive(myUserView.kokoidLabel.rx.text).disposed(by: disposeBag)
        
        goBackBtn.rx.tap.bind { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
        
        friendViewModel.friendsForTable
            .bind(to: friendTableView.rx.items(cellIdentifier: "FriendTableViewCell", cellType: FriendTableViewCell.self)) { (_, friend, cell) in
                cell.setValue(friend: friend)
            }
            .disposed(by: disposeBag)
        
        friendViewModel.friends.drive { [weak self] in
            if $0.count > 0 {
                self?.friendTableView.backgroundView = nil
            } else {
                self?.friendTableView.backgroundView = self?.tableViewEmptyView
                self?.setSearchView()
            }
        }.disposed(by: disposeBag)
        
        
        friendViewModel.friends
            .do { [weak self] in
                self?.friendViewModel.originalFriends = $0
            }
            .drive(friendViewModel.friendsForTable)
            .disposed(by: disposeBag)
        
        friendViewModel.friends
            .map({ _ in false })
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        friendViewModel.friendsInvited
        .drive { [weak self] in
            if $0.count > 0 {
                self?.updateUserView(friends: $0)
            }
        }.disposed(by: disposeBag)
        
        friendViewModel.friendStatus2Count
            .drive(myUserView.friendNumLabel.rx.text)
            .disposed(by: disposeBag)
        
        friendViewModel.friendStatus2IsHidden
            .drive(myUserView.friendNumView.rx.isHidden)
            .disposed(by: disposeBag)
        
        searchBar
              .rx
              .text
              .orEmpty
              .distinctUntilChanged()
              .subscribe { [weak self] in
                  self?.friendViewModel.searchFriend(with: $0)
              }
              .disposed(by: disposeBag)
        
        searchBar.rx.textDidBeginEditing
                .subscribe(onNext: { [weak self] in
                    self?.adjustLayoutForSearchBar()
                })
                .disposed(by: disposeBag)
        
        searchBar.rx.textDidEndEditing
                    .subscribe(onNext: { [weak self] in
                        self?.adjustLayoutForSearchBar(reset: true)
                    })
                    .disposed(by: disposeBag)
        
        refreshTrigger.subscribe(onNext: { [weak self] _ in
            self?.resetUserView()
        }).disposed(by: disposeBag)
    }
    
    private func setTableView() {
        let nib = UINib(nibName: "FriendTableViewCell", bundle: nil)
        friendTableView.register(nib, forCellReuseIdentifier: "FriendTableViewCell")
        friendTableView.separatorStyle = .none
        friendTableView.refreshControl = refreshControl
    }
    
    private func setSearchView() {
        searchView.isHidden = true
        searchViewHeight.constant = 0
    }
    
    private func adjustLayoutForSearchBar(reset: Bool = false) {
        self.userViewHeight.constant = reset ? USER_VIEW_HEIGHT_DEFAULT + self.heightForInvited : 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.myUserView.alpha = reset ? 1 : 0
         }
    }
    
    private func resetUserView() {
        userViewHeight.constant = USER_VIEW_HEIGHT_DEFAULT
        myUserView.removeAllInvitedFriend()
    }
    
    private func updateUserView(friends: [Friend]) {

        heightForInvited = 100
        userViewHeight.constant += heightForInvited
        
        self.myUserView.addInvitedFriend(friends: friends)
        
        myUserView.invitedTap?.rx.event.bind(onNext: { [weak self] _ in
            if self?.myUserView.isExpanded == false {
                self?.userViewHeight.constant += CGFloat(70 * (friends.count - 1))
            } else {
                self?.userViewHeight.constant = USER_VIEW_HEIGHT_DEFAULT + (self?.heightForInvited ?? 0)
            }
            self?.myUserView.expandFriendList()

            UIView.animate(withDuration: 0.3) {
                self?.view.layoutIfNeeded()
             }
        }).disposed(by: disposeBag)
    }
    
    private func createEmptyView() -> UIView {
        let emptyView = EmptyView()
        emptyView.frame = friendTableView.bounds
        return emptyView
    }
}
