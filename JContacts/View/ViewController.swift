//
//  ViewController.swift
//  JContacts
//
//  Created by Jatin Garg on 29/06/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import UIKit


enum AlertType: String {
    case failure = "Oops!"
    case success = "Voila!"
    case info = "FYI"
}

class ViewController: UIViewController {
    private var loaderMap: [LoaderPosition : LoadingView] = [:]
    
    private var loaderInstance: LoadingView {
        let l = LoadingView()
        l.color = Colors.PrimaryColor
        return l
    }
    
    private func constructAlertBox(OfType type: AlertType, andMessage message: String) -> UIAlertController {
        let alertController = UIAlertController(title: type.rawValue, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Alright", style: .default, handler: nil))
        return alertController
    }
    
    open func showPageLoader(atPosition position: LoaderPosition) {
        var targetLoader = loaderMap[position]
        
        guard targetLoader == nil else {
            return
        }
        
        targetLoader = loaderInstance
        targetLoader?.translatesAutoresizingMaskIntoConstraints = false
        targetLoader?.alpha = 0
        
        view.addSubview(targetLoader!)
        targetLoader?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        switch position {
        case .page:
            targetLoader?.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            
        case .bottom:
            if #available(iOS 11.0, *) {
                targetLoader?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
            } else {
                targetLoader?.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
            }
        case .top:
            if #available(iOS 11.0, *) {
                targetLoader?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
            } else {
                 targetLoader?.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
            }
        }
        
        UIView.animate(withDuration: 0.5) {
            targetLoader?.alpha = 1
        }
        
        loaderMap[position] = targetLoader
    
    }
    
    open func hidePageLoader(atPosition position: LoaderPosition) {
        guard let targetLoader = loaderMap[position] else {
            return
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            targetLoader.alpha = 0
        }) {_ in
            targetLoader.removeFromSuperview()
            self.loaderMap[position] = nil
        }
    }
    
    open func showAlert(ofType type: AlertType, andMessage message: String) {
        view.endEditing(true)
        let alertBox = constructAlertBox(OfType: type, andMessage: message)
        present(alertBox, animated: true)
    }
}
