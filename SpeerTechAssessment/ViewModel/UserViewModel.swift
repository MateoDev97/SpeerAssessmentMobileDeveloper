//
//  HomeViewModel.swift
//  SpeerTechAssessment
//
//  Created by Brian Ortiz on 2023-06-05.
//

import Foundation
import Combine

class UserViewModel: ObservableObject {
        
    @Published var searchUserValue = ""
    @Published var showResults: Bool = false

    @Published var userData: GitHubUserResponse?

    private var cancellables = Set<AnyCancellable>()

    func searchUserByUserName(_ username: String) {
        
        NetworkManager.shared.genericApiRequest(GitHubUserResponse.self, path: .USERS, extraPath: username)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure:
                    self?.showResults = true
                    self?.userData = nil
                default:
                    break
                }
            }, receiveValue: { [weak self] responseData in
                self?.showResults = true
                self?.userData = responseData
            })
            .store(in: &cancellables)
    }
    
}
