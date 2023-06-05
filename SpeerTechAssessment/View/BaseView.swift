//
//  BaseView.swift
//  SpeerTechAssessment
//
//  Created by Brian Ortiz on 2023-06-05.
//

import SwiftUI


struct BaseView<Content>: View where Content: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let title: String
    let content: Content
    var showBackButton: Bool


    init(title: String, showBackButton: Bool = true, content: Content) {
        self.title = title
        self.content = content
        self.showBackButton = showBackButton
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    if showBackButton {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.backward")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                        }.padding()
                    } else {
                        Spacer()
                            .frame(width: 50)
                    }
                    
                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                        .frame(width: 50)
                }
                Divider()
                content
                    .frame(maxHeight: .infinity)
                
            }
            
        }
    }
}


