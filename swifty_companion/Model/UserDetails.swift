//
//  User.swift
//  swifty_companion
//
//  Created by Heidi Merianne on 5/12/23.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import UIKit

struct UserDetails: Codable {
    let id: Int
    let email: String
    let login: String
    let image: Image?
    let poolYear: String?
    let displayName: String
    let wallet: Int
    let cursusUsers: [CursusUser]
    let projectsUsers: [ProjectsUser]
    let active: Bool
    
    enum CodingKeys: String, CodingKey {

        case id
        case email
        case login
        case image
        case poolYear = "pool_year"
        case displayName = "displayname"
        case wallet
        case cursusUsers = "cursus_users"
        case projectsUsers = "projects_users"
        case active = "active?"
    }
}

struct Image: Codable {
    let link: String?
}

struct CursusUser: Codable {
    let grade: String?
    let level: Double
    let skills: [Skill]
    let cursus: Cursus
}

struct Cursus: Codable {
    let name: String
}

struct Skill: Codable {
    let id: Int
    let name: String
    let level: Double
}

struct ProjectsUser: Codable {
    let id: Int
    let finalMark: Int?
    let status: ProjectStatus
    let project: Project
    
    enum CodingKeys: String, CodingKey {

        case id
        case finalMark = "final_mark"
        case status
        case project
    }
}

struct Project: Codable {
    let id: Int
    let name: String
    let parentId: Int?
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case name
        case parentId = "parent_id"
    }
}

enum ProjectStatus: String, Codable {
    case searchingAGroup
    case finished
    case unknown
    
    init?(rawValue: String) {
        switch rawValue {
        case "searching_a_group":
            self = .searchingAGroup
        case "finished":
            self = .finished
        default:
            self = .unknown
        }
    }
}
