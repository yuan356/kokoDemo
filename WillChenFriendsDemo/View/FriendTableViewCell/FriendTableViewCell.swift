//
//  FriendTableViewCell.swift
//  WillChenFriendsDemo
//
//  Created by Will on 2024/1/18.
//

import UIKit

enum KokoColor: String {
    case hotPink
    case pinkishGrey
    case greyishBrown
}

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var starImage: UIImageView!
    @IBOutlet weak var transferButtonView: UIView!
    @IBOutlet weak var invitedButtonView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var moreImage: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        transferButtonView.layer.borderWidth = 1.2
        transferButtonView.layer.cornerRadius = 2
        transferButtonView.layer.borderColor = UIColor(named: KokoColor.hotPink.rawValue)!.cgColor
        invitedButtonView.layer.borderWidth = 1.2
        invitedButtonView.layer.cornerRadius = 2
        invitedButtonView.layer.borderColor = UIColor(named: KokoColor.pinkishGrey.rawValue)!.cgColor
    }

    func setValue(friend: Friend) {
        nameLabel.text = friend.name
        starImage.isHidden = friend.isTop == "0" // 星號
        invitedButtonView.isHidden = friend.status != 2 // status=2, 邀請中
        moreImage.isHidden = friend.status != 1
    }
    
}
