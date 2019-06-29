//
//  EditContactViewController.swift
//  JContacts
//
//  Created by Jatin Garg on 30/06/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import UIKit

class EditContactViewController: ViewController {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var mobileField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    public var presenter: EditContactPresenter!
    
    private var pickedImage: UIImage?
    private let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureImagePicker()
        presenter.getContact()
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        presenter.processCameraTap()
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        saveInformation()
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
    }
    
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true)
        }
    }
    
    private func openCameraRoll() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true)
        }
    }
    
    private func saveInformation() {
        /*
         1. Look for image delta
         2. Look for contact delta
         3. Save only if delta count >= 1
         */
        if pickedImage != nil, let imageData = pickedImage!.jpegData(compressionQuality: 0.5)  {
            /*
             user has at least chosen a new image for this contact,
             upload it somewhere and store the url
             */
            presenter.setImage(data: imageData)
        }
        
        let newFirstName = firstNameField.text ?? ""
        let newLastName = lastNameField.text ?? ""
        let newMobile = mobileField.text ?? ""
        let newEmail = emailField.text ?? ""
        
        presenter.setNewContactInformation( Contact(id: 0,
                                           firstName: newFirstName,
                                           lastName: newLastName,
                                           avatar: presenter.contact?.avatar ?? "",
                                           isFavorite: presenter.contact?.isFavorite ?? false,
                                           detailURL: presenter.contact?.detailURL ?? "",
                                           details: ContactDetail(email: newEmail,
                                                                  phoneNumber: newMobile,
                                                                  creationDate: presenter.contact?.details?.creationDate ?? "",
                                                                  modificationDate: presenter.contact?.details?.modificationDate ?? "")))
        
        //information set, leave it upto presenter to do its magic
        
        
        
    }
    
}

//MARK :- Conformance necessary for operation of image picker
extension EditContactViewController: UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        defer {
            dismiss(animated: true)
        }
        guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            else {
                return
        }
        
        self.pickedImage = pickedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}


//MARK :- Presenter delegates
extension EditContactViewController: EditPresenterDelegate {
    func displayContact() {
        guard let contact = presenter.contact else {
            return
        }
        
        firstNameField.text = contact.firstName
        lastNameField.text = contact.lastName
        avatarImageView.sd_setImage(with: URL(string: contact.avatar), placeholderImage: Images.avatarPlaceholder.equivalentImage)
        
        //now the details
        guard let details = contact.details else {
            return
        }
        emailField.text = details.email
        mobileField.text = details.phoneNumber
    }
    
    func displayPictureOptions() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: Strings.EDIT_PIC_CAMERA_OPTION, style: .default) { [weak self ]_ in
            guard let `self` = self else { return }
            self.openCamera()
        }
        
        let cameraRollAction = UIAlertAction(title: Strings.EDIT_PIC_CAMERA_ROLL_OPTION, style: .default) {[weak self] _ in
            guard let `self` = self else { return }
            self.openCameraRoll()
        }
        
        let cancelAction = UIAlertAction(title: Strings.EDIT_PIC_CANCEL_OPTION, style: .cancel, handler: nil)
        
        [cameraAction, cameraRollAction, cancelAction].forEach {
            actionSheet.addAction($0)
        }
        present(actionSheet, animated: true)
    }
    
    func togglePageLoader(atPosition position: LoaderPosition, _ shouldShow: Bool) {
        
    }
    
    func displayError(_ error: Error) {
        
    }
    
    func displayinfo(_ message: String) {
        
    }
    
    func displaySuccess(_ message: String) {
        
    }
    
    
}

//MARK:- Textfield Delegates
extension EditContactViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: textField.superview!.frame.origin.y + textField.frame.origin.y), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameField:
            lastNameField.becomeFirstResponder()
        case lastNameField:
            mobileField.becomeFirstResponder()
        case mobileField:
            emailField.becomeFirstResponder()
        case emailField:
            saveInformation()
            emailField.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
}
