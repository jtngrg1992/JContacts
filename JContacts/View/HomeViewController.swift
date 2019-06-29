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
    @IBOutlet weak var initialsContainer: UIView!
    
    private var presenter: HomePresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = HomePresenter(delegate: self)
        presenter.fetchContacts()
    }
    
    private func configureTableView() {
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
    }


}

extension HomeViewController: HomePresenterDelegate {
    func displayContacts(_ contact: [Contact]) {
        tableView.reloadData()
    }
    
    func displayError(_ error: Error) {
        
    }
    
    func displayinfo(_ message: String) {
        
    }
    
    func displaySuccess(_ message: String) {
        
    }
    
    func togglePageLoader(atPosition position: LoaderPosition, _ shouldShow: Bool) {
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
        
        cell.contact = presenter.contact(inSection: indexPath.section, andRow: indexPath.row)
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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

