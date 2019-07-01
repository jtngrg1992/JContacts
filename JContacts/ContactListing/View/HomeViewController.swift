//
//  ViewController.swift
//  JContacts
//
//  Created by Jatin Garg on 29/06/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import UIKit

class HomeViewController: ViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var initialsContainer: InitialsView!
    
    private var presenter: HomePresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = HomePresenter(delegate: self)
        presenter.fetchContacts()
        configureTableView()
        configureNavigationBar()
        configureInitialsView()
    }
    
    @IBAction func addContactTapped(_ sender: Any) {
        performSegue(withIdentifier: ViewControllerSegue.showAddContact.rawValue, sender: self)
    }
    
    @IBAction func groupsTapped(_ sender: Any) {
        showAlert(ofType: .info, andMessage: "This feature was absent from the specs")
    }
    
    private func configureTableView() {
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func configureInitialsView() {
        initialsContainer.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifierCase(for: segue) {
        case .showContactDetail:
            let detailVC = segue.destination as! DetailViewController
            detailVC.contact = presenter.selectedContact!
        case .showAddContact:
            guard
                let navigation = segue.destination as? UINavigationController,
                let addContactVC = navigation.viewControllers.first as? EditContactViewController
                else {
                    return
            }
            let presenter = EditContactPresenter(contact: nil, delegate: addContactVC)
            addContactVC.presenter = presenter
        }
    }
}

extension HomeViewController: HomePresenterDelegate {
    func reloadData() {
        tableView.reloadData()
    }
    
    func scroll(toRowAtIndexPath indexPath: IndexPath) {
        tableView.scrollToRow(at: indexPath,
                              at: .top,
                              animated: true)
    }
    
    func reloadRow(atIndexPath indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath],
                             with: .automatic)
    }
    
    func displayDetails(forContact contact: Contact) {
        performSegue(withIdentifier: ViewControllerSegue.showContactDetail.rawValue,
                     sender: self)
    }
    
    func displayContacts() {
        tableView.reloadData()
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
    
    func togglePageLoader(atPosition position: LoaderPosition, _ shouldShow: Bool) {
        tableView.isHidden = shouldShow && position == .page
        shouldShow ? showPageLoader(atPosition: position) : hidePageLoader(atPosition: position)
    }
    
    
}

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.sectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.rowCount(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "contactItem") as? ContactItemCell else {
            fatalError(Strings.FAILED_CELL_DESTRUCTURE("ContactItemCell"))
        }
        
        cell.contact = presenter.contact(inSection: indexPath.section,
                                         andRow: indexPath.row)
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.processRowSelection(atIndexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = ContactListSectionHeader()
        sectionHeader.title = presenter.title(forSectionAtIndex: section).uppercased()
        sectionHeader.backgroundColor = Colors.DarkerBackground
        return sectionHeader
    }
}

extension HomeViewController: SegueHandler {
    enum ViewControllerSegue: String {
        case showContactDetail
        case showAddContact
    }
}

extension HomeViewController: InitialsViewDelegate {
    func didSelect(aCharacter char: Character) {
        let str = String(char)
        presenter.processAlphabetTap(str)
    }
}

