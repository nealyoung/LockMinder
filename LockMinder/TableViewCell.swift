//
//  TableViewCell.swift
//  LockMinder
//
//  Created by Nealon Young on 8/15/15.
//  Copyright (c) 2015 Nealon Young. All rights reserved.
//

import Foundation

class TableViewCell: UITableViewCell {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Value1, reuseIdentifier: reuseIdentifier)
        
        self.commonInit()
    }
    
    private func commonInit() {
        self.textLabel?.font = UIFont.applicationFont(17.0)
        self.detailTextLabel?.font = UIFont.applicationFont(16.0)
    }
}
