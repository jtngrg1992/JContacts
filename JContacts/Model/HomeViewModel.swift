//
//  HomeViewModel.swift
//  JContacts
//
//  Created by Jatin Garg on 29/06/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation

struct HomeViewModel {
    let sections: [HomeSectionModel]
    
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
    
}

struct HomeSectionModel {
    let sectionTitle: String
    var sectionChildren: [Contact]
}
