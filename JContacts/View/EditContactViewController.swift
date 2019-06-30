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
    @IBOutlet weak var doneNavigationItem: UIBarButtonItem!
    
    public var presenter: EditContactPresenter!
    
    private var pickedImage: UIImage? {
        didSet{
            avatarImageView.image = pickedImage
        }
    }
    
    private let imagePicker = UIImagePickerController()
    
    var pickedImageData: Data?
    var editedFirstName: String?
    var editedLastName: String?
    var editedEmail: String?
    var editedPhoneNumber: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureImagePicker()
        configureScrollView()
        presenter.getContact()
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        view.endEditing(true)
        presenter.processCameraTap()
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        view.endEditing(true)
        dismiss(animated: true)
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        view.endEditing(true)
        saveInformation()
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
    }
    
    private func configureScrollView() {
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        tapgesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapgesture)
    }
    
    @objc func scrollViewTapped(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true)
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
            pickedImageData = imageData
        }
        
        editedFirstName = firstNameField.text ?? ""
        editedLastName = lastNameField.text ?? ""
        editedPhoneNumber = mobileField.text ?? ""
        editedEmail = emailField.text ?? ""
        
        presenter.saveContactInformation()
    }

}

//MARK :- Conformance necessary for operation of image picker
extension EditContactViewController: UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
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
    func toggleSaveButton(_ shouldEnable: Bool) {
        doneNavigationItem.isEnabled = shouldEnable
    }
    
    
    func dismissSelf() {
        dismiss(animated: true)
    }
    
    func displayContact() {
        guard let contact = presenter.contact else {
            return
        }
        
        firstNameField.text = contact.firstName
        lastNameField.text = contact.lastName
        avatarImageView.sd_setImage(with: URL(string: contact.avatar),
                                    placeholderImage: Images.avatarPlaceholder.equivalentImage)
        
        //now the details
        guard
            let email = contact.email,
            let phoneNumber = contact.phoneNumber
        else {
            return
        }
        emailField.text = email
        mobileField.text = phoneNumber
    }
    
    func displayPictureOptions() {
        let actionSheet = UIAlertController(title: nil, 
                                            message: nil,
                                            preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: Strings.EDIT_PIC_CAMERA_OPTION,
                                         style: .default) { [weak self ]_ in
            guard let `self` = self else { return }
            self.openCamera()
        }
        
        let cameraRollAction = UIAlertAction(title: Strings.EDIT_PIC_CAMERA_ROLL_OPTION,
                                             style: .default) {[weak self] _ in
            guard let `self` = self else { return }
            self.openCameraRoll()
        }
        
        let cancelAction = UIAlertAction(title: Strings.EDIT_PIC_CANCEL_OPTION,
                                         style: .cancel,
                                         handler: nil)
        
        [cameraAction, cameraRollAction, cancelAction].forEach {
            actionSheet.addAction($0)
        }
        present(actionSheet, animated: true)
    }
    
    func togglePageLoader(atPosition position: LoaderPosition, _ shouldShow: Bool) {
        shouldShow ? showPageLoader(atPosition: position) : hidePageLoader(atPosition: position)
    }
    
    func displayError(_ error: Error) {
        showAlert(ofType: .failure,
                  andMessage: error.localizedDescription)
    }
    
    func displayinfo(_ message: String) {
        showAlert(ofType: .info,
                  andMessage: message)
    }
    
    func displaySuccess(_ message: String) {
        showAlert(ofType: .success,
                  andMessage: message)
    }
    
    
}

//MARK:- Textfield Delegates
extension EditContactViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0,
                                            y: textField.superview!.frame.origin.y + textField.frame.origin.y),
                                    animated: true)
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
