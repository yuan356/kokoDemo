//
//  EmptyView.swift
//  WillChenFriendsDemo
//
//  Created by Will on 2024/1/19.
//

import UIKit

class EmptyView: UIView {
    
    @IBOutlet weak var buttonView: UIView!
    
    @IBOutlet weak var settingLabel: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
        buttonView.layer.cornerRadius = 20

        let gradientLayer = CAGradientLayer()

        let colorLeft = UIColor(red: 86/255, green: 179/255, blue: 11/255, alpha: 1).cgColor
        let colorRight = UIColor(red: 166/255, green: 204/255, blue: 66/255, alpha: 1).cgColor
        gradientLayer.colors = [colorLeft, colorRight]

        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.frame = buttonView.bounds
        buttonView.layer.masksToBounds = true
        buttonView.layer.insertSublayer(gradientLayer, at: 0)
        

        let attributedString = NSMutableAttributedString(string: "幫助好友更快找到你？設定 KOKO ID", attributes: [
          .font: UIFont(name: "PingFangTC-Regular", size: 13.0)!,
          .foregroundColor: UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1),
          .kern: 0.0
        ])
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 236.0 / 255.0, green: 0.0, blue: 140.0 / 255.0, alpha: 1.0), range: NSRange(location: 10, length: 10))
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 10, length: 10))

        
        settingLabel.attributedText = attributedString
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        if let view = Bundle.main.loadNibNamed("EmptyView", owner: self, options: nil)?.first as? UIView {
            view.frame = bounds
            addSubview(view)
        }
    }
}
