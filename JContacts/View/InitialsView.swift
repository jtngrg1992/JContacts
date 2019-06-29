//
//  InitialsView.swift
//  JContacts
//
//  Created by Jatin Garg on 29/06/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import UIKit

class InitialsView: UIView {
    private let alphabets = "abcdefghijklmnopqrstuvwxyz"
    private var newButtonInstance: UIButton {
        let l = UIButton(type: .system)
        l.contentEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.tintColor = .gray
        l.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        return l
    }
    private var initialLabels: [UIButton] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        initialLabels.removeAll()
        alphabets.forEach { char  in
            let button = self.newButtonInstance
            button.setTitle(String(char).uppercased(), for: .normal)
            initialLabels.append(button)
        }
        
        let containingView = UIView()
        containingView.translatesAutoresizingMaskIntoConstraints = false
        
        for i in 0..<initialLabels.count {
            let label = initialLabels[i]
            containingView.addSubview(label)
            label.addTarget(self, action: #selector(alphabetTapped), for: .touchUpInside)
            label.tag = i
            //position the label
            label.centerXAnchor.constraint(equalTo: containingView.centerXAnchor).isActive = true
            if (i == 0) {
                label.topAnchor.constraint(equalTo: containingView.topAnchor, constant: 10).isActive = true
            }else {
                let previousLabel = initialLabels[i - 1]
                label.topAnchor.constraint(equalTo: previousLabel.bottomAnchor, constant: 3).isActive = true
            }
            
            if (i == initialLabels.count - 1) {
                label.bottomAnchor.constraint(equalTo: containingView.bottomAnchor, constant:  -10).isActive = true
            }
        }
        
        //we will have a view containing all the labels vertically stacked at the end of this loop
        //place that at the vertical center of mine
        addSubview(containingView)
        containingView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        containingView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        containingView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    @objc func alphabetTapped(_ sender: UIButton) {
        let index = sender.tag
        let tappedAlphabet = alphabets[alphabets.index(alphabets.startIndex, offsetBy: index)]
        //todo: Call delegate to manipulate the UI
    }
}
