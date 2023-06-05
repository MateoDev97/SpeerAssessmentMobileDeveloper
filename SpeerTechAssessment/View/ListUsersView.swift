//
//  ListUsersView.swift
//  SpeerTechAssessment
//
//  Created by Brian Ortiz on 2023-06-05.
//

import SwiftUI

struct ListUsersView: View {
    
    var title: String
    var path: String
    
    @StateObject var viewModel = ListUserViewModel()
    
    var body: some View {
        BaseView(title: title, content: content)
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                viewModel.loadListUsers(path: path)
            }
            .alert(viewModel.messageAlert, isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) { }
            }
    }
    
    private var content: some View {
        
        
        VStack{
            
            Text("\(viewModel.usersList.count) \(path.components(separatedBy: "/").last ?? "")")
                .font(.system(size: 18, weight: .semibold))
                .padding(.vertical, 20)
            
            List(viewModel.usersList) { user in
                
                NavigationLink(destination: UserView(userName: user.login), label: {
                    HStack{
                        
                        AsyncImage(
                            url: URL(string: user.avatarURL),
                            content: { image in
                                image.resizable()
                                    .scaledToFit()
                                    .frame(width: 60)
                                    .cornerRadius(30)
                                    .overlay(RoundedRectangle(cornerRadius: 30)
                                        .stroke(Color.black, lineWidth: 2))
                                    .shadow(radius: 10)
                            },
                            placeholder: {
                                ProgressView()
                            }
                        )
                        
                        Text(user.login)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 15)
                        
                    }
                    .padding(.horizontal, 25)
                })
                
            }
            .refreshable {
                viewModel.loadListUsers(path: path)
            }
        }
    }
    
}

struct ListUsersView_Previews: PreviewProvider {
    static var previews: some View {
        ListUsersView(title: "Following", path: "mateodev97/followers")
    }
}
