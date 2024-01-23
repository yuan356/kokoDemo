//
//  UserView.swift
//  WillChenFriendsDemo
//
//  Created by Will on 2024/1/17.
//

import UIKit
import RxCocoa
import RxSwift

class UserView: UIView {

    @IBOutlet weak var kokoidLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var menuPinkBar: UIView!
    @IBOutlet weak var friendNumLabel: UILabel!
    @IBOutlet weak var friendNumView: UIView!
    @IBOutlet weak var chatNumView: UIView!
    @IBOutlet weak var goBackBtn: UIButton!
    
    var invitedTap: UITapGestureRecognizer?

    var isExpanded: Bool = false
    
    var invitedFriendBackViews: [FriendInvitedView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        menuPinkBar.layer.cornerRadius = 2
        friendNumView.layer.cornerRadius = 9
        chatNumView.layer.cornerRadius = 9
    }
    
    func removeAllInvitedFriend() {
        for view in invitedFriendBackViews {
            view.removeFromSuperview()
        }
        invitedFriendBackViews.removeAll()
        isExpanded = false
    }
    
    func addInvitedFriend(friends: [Friend]) {
        invitedTap = UITapGestureRecognizer()
        
        let friendView = FriendInvitedView()
        
        let firstFriend = friends[0]
        friendView.nameLabel.text = firstFriend.name
        friendView.addGestureRecognizer(invitedTap!)
        
        self.addSubview(friendView)
        let constraints: [NSLayoutConstraint] = [
            friendView.topAnchor.constraint(equalTo: self.topAnchor, constant: 100),
            friendView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30),
            friendView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30),
            friendView.heightAnchor.constraint(equalToConstant: 70)
        ]
        NSLayoutConstraint.activate(constraints)
        invitedFriendBackViews.append(friendView)
        
        if friends.count > 1 {
            var previous = friendView
            for i in (1..<friends.count) {
                let friend = friends[i]
                let backView = FriendInvitedView()
                backView.nameLabel.text = friend.name
                
                backView.rightConstraint = backView.rightAnchor.constraint(equalTo: friendView.rightAnchor, constant: -10)
                backView.leftConstraint = backView.leftAnchor.constraint(equalTo: friendView.leftAnchor, constant: 10)
                if i == 1 {
                    backView.bottomConstraint = backView.bottomAnchor.constraint(equalTo: friendView.bottomAnchor, constant: 10)
                } else {
                    backView.bottomConstraint = backView.bottomAnchor.constraint(equalTo: previous.bottomAnchor)
                }
                
                self.insertSubview(backView, belowSubview: previous)
                let constraints: [NSLayoutConstraint] = [
                    backView.rightConstraint,
                    backView.leftConstraint,
                    backView.bottomConstraint,
                    backView.heightAnchor.constraint(equalToConstant: 70)
                ]
                NSLayoutConstraint.activate(constraints)
                invitedFriendBackViews.append(backView)
                previous = backView
            }
        }
    }
    
    func expandFriendList() {

//        print(isExpanded ? "collapse":"expanded")
        let leftConstant: CGFloat = isExpanded ? 10 : 0
        let rightConstant: CGFloat = isExpanded ? -10 : 0
        
        for i in (1...invitedFriendBackViews.count-1) {
            let view = invitedFriendBackViews[i]
            
            if isExpanded { // do collapse
                view.bottomConstraint.constant = (i == 1) ? 10 : 0
            } else { // do expand
                view.bottomConstraint.constant += (i == 1) ? 70 : 80
            }
            
            view.leftConstraint.constant = leftConstant
            view.rightConstraint.constant = rightConstant
        }
        isExpanded = !isExpanded

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }


    private func commonInit() {
        if let view = Bundle.main.loadNibNamed("UserView", owner: self, options: nil)?.first as? UIView {
            view.frame = bounds
            addSubview(view)
        }
    }

}
