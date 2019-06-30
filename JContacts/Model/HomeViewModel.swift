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
    
    public mutating func insert(_ contact: Contact) {
        let firstChracter = String(contact.firstName.prefix(1))
        
        if let existingSectionIndex = index(ofSectionStartingWith: firstChracter) {
            //append this contact to existing section's children
            var sectionChildren = sections[existingSectionIndex].sectionChildren
            sectionChildren.append(contact)
            //sort the children
            sections[existingSectionIndex].sectionChildren = sectionChildren.sorted(by: {
                $0.firstName.localizedCaseInsensitiveCompare($1.firstName) == .orderedAscending
            })
        }else {
            //create a new section and add this contact as a child
            sections.append(HomeSectionModel(sectionTitle: firstChracter,
                                             sectionChildren: [contact]))
            //sort the sections
            sections = sections.sorted(by: {
                $0.sectionTitle.localizedCaseInsensitiveCompare($1.sectionTitle) == .orderedAscending
            })
        }
    }
    
}

struct HomeSectionModel {
    let sectionTitle: String
    var sectionChildren: [Contact]
}
