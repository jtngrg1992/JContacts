//
//  ContactItemCell.swift
//  JContacts
//
//  Created by Jatin Garg on 29/06/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import UIKit
import SDWebImage

class ContactItemCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favoriteMarker: UIImageView!
    
    public var contact: Contact? {
        didSet{
            guard let `contact` = contact else {
                return
            }
            loadDetails(forContact: contact)
        }
    }
    
    private func loadDetails(forContact contact: Contact) {
        avatarImageView.sd_setImage(with: URL(string: contact.avatar), placeholderImage: UIImage(named: "placeholder_photo"))
        nameLabel.text = contact.fullName
        favoriteMarker.isHidden = !contact.isFavorite
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        favoriteMarker.isHidden = true
    }
}
