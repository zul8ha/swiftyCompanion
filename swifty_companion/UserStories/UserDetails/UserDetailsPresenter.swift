//
//  UserDetailsPresenter.swift
//  swifty_companion
//
//  Created by Zuleykha Pavlichenkova on 13.08.2023.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

import Foundation

protocol UserDetailsViewControllable: AnyObject {
    func set(title: String)
    func showError(_ message: String)
    func showUser(_ user: UserDetails)
}

final class UserDetailsPresenter: UserDetailsPresentable {
    
    private var login: String

    weak var view: UserDetailsViewControllable?
    private let userService: IUserService
    private var user: UserDetails?
    var userDetailsSection: [UserDetailsSection] = []
    
    init(
        login: String,
        userService: IUserService
    ) {
        self.login = login
        self.userService = userService
    }
    
    func onViewDidLoad() {
        view?.set(title: login)
        loadUserData(with: login)
    }
}

private extension UserDetailsPresenter {
    
    func loadUserData(with login: String) {
        userService.loadUserData(with: login, completion: { [weak self] result in
            DispatchQueue.main.async {
                self?.handleUserLoading(with: result)
            }
        })
    }
    
    func handleUserLoading(with result: Result<UserDetails, Error>) {
        switch result {
        case let .success(user):
            self.user = user
            parseUserForSkills(for: user)
            parseUserForProjects(for: user)
            view?.showUser(user)
            
        case let .failure(error):
            view?.showError(error.localizedDescription)
        }
    }

    func parseUserForSkills(for user: UserDetails) {
        for cursusUser in user.cursusUsers {
            
            var skillItems: [SkillItem] = []
            for skill in cursusUser.skills {
                skillItems.append(SkillItem(
                    id: skill.id,
                    title: skill.name,
                    level: skill.level
                ))
            }
            let cursusSkillsSection = CursusSkillsSection(
                name: cursusUser.cursus.name,
                level: cursusUser.level,
                skillItems: skillItems
            )
            userDetailsSection.append(.cursusSkillsSection(cursusSkillsSection))
        }
    }
    
    func parseUserForProjects(for user: UserDetails) {
        var projectItems: [ProjectItem] = []

        for projectUser in user.projectsUsers {
            if projectUser.project.parentId != nil {
                continue
            }
            let projectItem = ProjectItem(
                id: projectUser.project.id,
                title: projectUser.project.name,
                status: projectUser.status,
                finalMark: projectUser.finalMark ?? 0
            )
            if projectItem.status == .finished {
                projectItems.append(projectItem)
            }
        }
        projectItems.sort { lhs, rhs in
            lhs.title < rhs.title
        }
        userDetailsSection.append(.projectsSection(projectItems))
    }
}
