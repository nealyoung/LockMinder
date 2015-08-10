//
//  ReminderTableViewCell.swift
//  LockMinder
//
//  Created by Nealon Young on 8/7/15.
//  Copyright © 2015 Nealon Young. All rights reserved.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {
    var reminderLabel: UILabel!
    var checkmarkView: CheckmarkView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    private func commonInit() {
        self.selectionStyle = .None
        
        self.checkmarkView = CheckmarkView()
        self.checkmarkView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.contentView.addSubview(self.checkmarkView)
        
        self.reminderLabel = UILabel()
        self.reminderLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.contentView.addSubview(self.reminderLabel)
        
        self.checkmarkView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.contentView.snp_topMargin).offset(-2.0)
            make.leading.equalTo(self.contentView.snp_leadingMargin)
            make.bottom.equalTo(self.contentView.snp_bottomMargin).offset(2.0)
            
            make.width.equalTo(self.checkmarkView.snp_height)
        }
        
        self.reminderLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.contentView.snp_topMargin)
            make.leading.equalTo(self.checkmarkView.snp_trailing).offset(8.0)
            make.bottom.equalTo(self.contentView.snp_bottomMargin)
            make.trailing.equalTo(self.contentView.snp_trailingMargin)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
