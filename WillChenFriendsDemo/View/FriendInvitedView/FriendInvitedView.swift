//
//  FriendInvitedView.swift
//  WillChenFriendsDemo
//
//  Created by Will on 2024/1/22.
//

import UIKit

class FriendInvitedView: UIView {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    var rightConstraint: NSLayoutConstraint!
    var leftConstraint: NSLayoutConstraint!
    var topConstraint: NSLayoutConstraint!
    var bottomConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        if let view = Bundle.main.loadNibNamed("FriendInvitedView", owner: self, options: nil)?.first as? UIView {
            view.frame = bounds
            contentView.layer.cornerRadius = 6
            contentView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
            contentView.layer.shadowOpacity = 1
            contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
            contentView.layer.shadowRadius = 16
            self.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }
}
