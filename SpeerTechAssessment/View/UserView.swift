//
//  ContentView.swift
//  SpeerTechAssessment
//
//  Created by Brian Ortiz on 2023-06-05.
//

import SwiftUI

struct UserView: View {
    
    var userName: String?
    var showBack: Bool = true
    @StateObject var viewModel = UserViewModel()
    
    var body: some View {
        BaseView(title: "GitHub Search", showBackButton: showBack, content: content)
            .onAppear {
                if let userName = userName {
                    viewModel.searchUserByUserName(userName)
                }
            }
            
            .toolbar(.hidden, for: .navigationBar)
    }
    
    private var content: some View {
        VStack {
            
            if userName == nil {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("GitHub user name", text: $viewModel.searchUserValue)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    Button {
                        viewModel.searchUserByUserName(viewModel.searchUserValue)
                    } label: {
                        Text("Search")
                    }
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(Color.black))
            }
            
            if let userData = viewModel.userData, viewModel.showResults {
                VStack(spacing: 15) {
                    Spacer()
                    
                    AsyncImage(
                        url: URL(string: userData.avatarURL),
                        content: { image in
                            image.resizable()
                                .scaledToFit()
                                .frame(width: 220)
                                .cornerRadius(110)
                                .overlay(RoundedRectangle(cornerRadius: 110)
                                    .stroke(Color.black, lineWidth: 4))
                                .shadow(radius: 10)
                        },
                        placeholder: {
                            ProgressView()
                        }
                    )
                    .padding(.bottom, 30)
                    
                    Group {
                        Text("Username: ")
                            .font(.system(size: 17, weight: .bold)) +
                        Text(userData.login)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Group {
                        Text("Name: ")
                            .font(.system(size: 17, weight: .bold)) +
                        Text(userData.name ?? "-")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Group {
                        Text("Description: ")
                            .font(.system(size: 17, weight: .bold)) +
                        Text(userData.bio ?? "-")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    if let userFollowers = userData.followers, userFollowers > 0 {
                        NavigationLink(destination: ListUsersView(title: "\(userData.login.uppercased()) Followers", path: "\(userData.login)/followers"), label: {
                            Group {
                                Text("Followers: ")
                                    .font(.system(size: 17, weight: .bold)) +
                                Text("\(userFollowers)")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        })
                    } else {
                        Group {
                            Text("Followers: ")
                                .font(.system(size: 17, weight: .bold)) +
                            Text("0")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    
                    if let usersFollowing = userData.following, usersFollowing > 0 {
                        NavigationLink(destination: ListUsersView(title: "\(userData.login.uppercased()) Following", path: "\(userData.login)/following"), label: {
                            Group {
                                Text("Following: ")
                                    .font(.system(size: 17, weight: .bold)) +
                                Text("\(usersFollowing)")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        })
                    } else {
                        Group {
                            Text("Following: ")
                                .font(.system(size: 17, weight: .bold)) +
                            Text("0")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    
                    
                    Spacer()
                }
                
                
            } else if viewModel.showResults {
                VStack {
                    Spacer()
                    Image("image_not_found")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                    Text("User name not found on GitHub")
                    Spacer()
                }.padding(.horizontal, 50)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
