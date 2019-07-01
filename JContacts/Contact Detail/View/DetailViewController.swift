//
//  DetailViewController.swift
//  JContacts
//
//  Created by Jatin Garg on 29/06/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import UIKit

class DetailViewController: ViewController {
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var mobileNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    private var editNavigationItem: UIBarButtonItem?
    
    public var contact: Contact! {
        didSet{
            presenter = DetailPresenter(contact: contact, delegate: self)
            presenter.fetchContactDetails()
        }
    }
    
    private var presenter: DetailPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayContactDetails(contact)
        addEditNavigationItem()
    }
    
    
    @IBAction func headerActionButtonTapped(_ sender: UIButton) {
        switch sender {
        case messageButton:
            presenter.initiateTextMessage()
        case callButton:
            presenter.initiateCall()
        case emailButton:
            presenter.sendEmail()
        case favoriteButton:
            presenter.toggleFavoriteStatus()
            break
        default:
            break
        }
    }
    
    
    private func addEditNavigationItem() {
        editNavigationItem = UIBarButtonItem(title: Strings.DETAIL_EDIT_ACTION,
                                       style: .plain,
                                       target: self,
                                       action: #selector(editItemTapped))
        navigationItem.rightBarButtonItem = editNavigationItem!
        
    }
    
    @objc func editItemTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: ViewControllerSegue.showContactEdit.rawValue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifierCase = segueIdentifierCase(for: segue)
        if (identifierCase == .showContactEdit) {
            guard
                let destinationNavigator = segue.destination as? UINavigationController,
                let editContactVC = destinationNavigator.viewControllers.first as? EditContactViewController
                else {
                    return
            }
            
            let editContactPresenter = EditContactPresenter(contact: presenter.contact,
                                                            delegate: editContactVC)
            editContactVC.presenter = editContactPresenter
        }
    }
}

extension DetailViewController: DetailPresenterDelegate {
    func displayContactDetails(_ details: Contact) {
        avatarImage.sd_setImage(with: URL(string: details.avatar),
                                placeholderImage: Images.avatarPlaceholder.equivalentImage)
        userNameLabel.text = details.fullName
        let favoriteBtnImage = details.isFavorite ? Images.isFavouriteDetail : Images.isNotFavouriteDetail
        favoriteButton.setImage(favoriteBtnImage.equivalentImage,
                                for: .normal)
        //try and check for more details
        guard
            let email = details.email,
            let phoneNumber = details.phoneNumber
        else {
            return
        }
        
        emailLabel.text = email
        mobileNumberLabel.text = phoneNumber
    }
    
    func togglePageLoader(atPosition position: LoaderPosition, _ shouldShow: Bool) {
        //disable any sort of action unti the activity completes
        view.isUserInteractionEnabled = !shouldShow
        editNavigationItem?.isEnabled = !shouldShow
        shouldShow ? showPageLoader(atPosition: position) : hidePageLoader(atPosition: position)
    }
    
    func displayError(_ error: Error) {
        showAlert(ofType: .failure, andMessage: error.localizedDescription)
    }
    
    func displayinfo(_ message: String) {
        showAlert(ofType: .info, andMessage: message)
    }
    
    func displaySuccess(_ message: String) {
        showAlert(ofType: .success, andMessage: message)
    }
}

extension DetailViewController: SegueHandler {
    enum ViewControllerSegue: String {
        case showContactEdit = "showEdit"
    }
}
