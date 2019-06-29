//
//  ContactListSectionHeader.swift
//  JContacts
//
//  Created by Jatin Garg on 29/06/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import UIKit

class ContactListSectionHeader: UIView {
    public var title: String? {
        didSet{
            headingLabel.text = title
        }
    }
    
    private var headingLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 15)
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup(){
        addSubview(headingLabel)
        headingLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        headingLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
