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
    
    public mutating func update(_ contact: Contact) {
        for  i in 0..<sections.count {
            let sectionChildrent = sections[i].sectionChildren
            let contactIndex = sectionChildrent.firstIndex(where: {
                $0.id == contact.id
            })
            
            let firstCharacter = String(contact.firstName.prefix(1))
            if contactIndex != nil {
                //this is the section where the contact can be found
                /*
                    1. Check if the updated contact still belongs to this section
                    2. If yes, sort the section
                    3. If no, move the contact to appropriate section and sort
                 */
                
                
                if firstCharacter == sections[i].sectionTitle {
                    sections[i].sort()
                }else{
                    if let existingSectionIndex = sections.firstIndex(where: {$0.sectionTitle == firstCharacter}) {
                        sections[existingSectionIndex].sectionChildren.append(contact)
                        sections[existingSectionIndex].sort()
                    }else {
                        sections.append(HomeSectionModel(sectionTitle: firstCharacter, sectionChildren: [contact]))
                        sort()
                        
                    }
                    
                }
                
            }
        }
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
            sections[existingSectionIndex].sectionChildren = sectionChildren
            sections[existingSectionIndex].sort()
        }else {
            //create a new section and add this contact as a child
            sections.append(HomeSectionModel(sectionTitle: firstChracter,
                                             sectionChildren: [contact]))
            //sort the sections
            sort()
        }
    }
    
    public mutating func sort() {
        sections = sections.sorted(by: {
             $0.sectionTitle.localizedCaseInsensitiveCompare($1.sectionTitle) == .orderedAscending
        })
    }
    
}

struct HomeSectionModel {
    let sectionTitle: String
    var sectionChildren: [Contact]
    
    public mutating func sort() {
        sectionChildren = sectionChildren.sorted(by: {
            $0.firstName.localizedCaseInsensitiveCompare($1.firstName) == .orderedAscending
        })
    }
}
