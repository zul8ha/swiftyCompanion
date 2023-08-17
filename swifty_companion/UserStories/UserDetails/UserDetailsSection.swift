//
//  UserDetailsSection.swift
//  swifty_companion
//
//  Created by Zuleykha Pavlichenkova on 12.08.2023.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import Foundation

enum UserDetailsSection {
    case cursusSkillsSection(CursusSkillsSection)
    case projectsSection([ProjectItem])
    
    var title: String {
        switch self {
        case .projectsSection:
            return "Projects"
        case let .cursusSkillsSection(cursusSkills):
            return "\(cursusSkills.name) (\(cursusSkills.level))"
        }
    }
    
    var itemsCount: Int {
        switch self {
        case .cursusSkillsSection(let cursusSkillsSection):
            return cursusSkillsSection.skillItems.count
        case .projectsSection(let projectItems):
            return projectItems.count
        }
    }
}

struct CursusSkillsSection {
    let name: String
    let level: Double
    let skillItems: [SkillItem]
}

struct SkillItem {
    let id: Int
    let title: String
    let level: Double
}

struct ProjectItem {
    let id: Int
    let title: String
    let status: ProjectStatus
    let finalMark: Int
}

extension UserDetailsSection {
    static var testSections: [UserDetailsSection] = [
        .cursusSkillsSection(CursusSkillsSection(
            name: "C Piscine",
            level: 3.45,
            skillItems: [
                SkillItem(id: 0, title: "Unix", level: 3.3),
                SkillItem(id: 1, title: "Rigor", level: 2.2)
            ]
        )),
        .cursusSkillsSection(CursusSkillsSection(
            name: "42 cursus",
            level: 11.1,
            skillItems: [
                SkillItem(id: 1, title: "Rigor", level: 4.4)
            ]
        )),
        .cursusSkillsSection(CursusSkillsSection(
            name: "42 events",
            level: 0.0,
            skillItems: []
        )),
        .projectsSection([
            ProjectItem(id: 0, title: "Piscine", status: .finished, finalMark: 100)
        ])
    ]
}
