//
//  ListUsersViewModel.swift
//  SpeerTechAssessment
//
//  Created by Brian Ortiz on 2023-06-05.
//

import Foundation
import Combine

class ListUserViewModel: ObservableObject {
    
    @Published var usersList: [GitHubUserResponse] = []
    
    @Published var messageAlert: String = ""
    @Published var showAlert: Bool = false

    private var cancellables = Set<AnyCancellable>()
    
    func loadListUsers(path: String) {
        NetworkManager.shared.genericApiRequest([GitHubUserResponse].self, path: .USERS, extraPath: path)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure:
                    self?.messageAlert = "An error occurred please try again later"
                    self?.showAlert = true
                default:
                    break
                }
            }, receiveValue: { [weak self] responseData in
                self?.usersList = responseData
            })
            .store(in: &cancellables)
    }
    
}
