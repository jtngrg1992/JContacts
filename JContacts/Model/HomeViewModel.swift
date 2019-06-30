//
//  HomeViewModel.swift
//  JContacts
//
//  Created by Jatin Garg on 29/06/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation

struct HomeViewModel {
    var sections: [HomeSectionModel]
    
    init(contacts: [Contact]) {
        var tempSections: [HomeSectionModel] = []
        
        contacts.forEach {
            let firstChracter = String($0.firstName.prefix(1))
            let existingSectionIndex = tempSections.firstIndex(where: { $0.sectionTitle.caseInsensitiveCompare(firstChracter) == ComparisonResult.orderedSame })
            if (existingSectionIndex == nil) {
                tempSections.append( HomeSectionModel(sectionTitle: firstChracter, sectionChildren: [$0]))
            }else{
                tempSections[existingSectionIndex!].sectionChildren.append($0)
            }
        }
        self.sections = tempSections
    }
    
    public func find(_ contact: Contact) -> (section: Int, row: Int)? {
        let firstChracter = String(contact.firstName.prefix(1))
        let sectionIndex = sections.firstIndex(where: {
            $0.sectionTitle.caseInsensitiveCompare(firstChracter) == ComparisonResult.orderedSame
        })
        
        guard sectionIndex != nil else { return nil }
        
        let sectionRows = sections[sectionIndex!].sectionChildren
        let rowIndex = sectionRows.firstIndex(where: {
            $0.id == contact.id
        })
        
        guard rowIndex != nil else { return nil }
        
        return (section: sectionIndex!, row: rowIndex!)
    }
    
    public func index(ofSectionStartingWith str: String) -> Int? {
        let sectionIndex = sections.firstIndex(where: {
            $0.sectionTitle.caseInsensitiveCompare(str) == ComparisonResult.orderedSame
        })
        return sectionIndex
    }
    
}

struct HomeSectionModel {
    let sectionTitle: String
    var sectionChildren: [Contact]
}
