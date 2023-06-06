//
//  RowUserText.swift
//  SpeerTechAssessment
//
//  Created by Brian Ortiz on 2023-06-06.
//

import SwiftUI

struct RowUserText: View {
    
    var title: String
    var bodyText: String
    
    var body: some View {
        Group {
            Text(title)
                .font(.system(size: 17, weight: .bold)) +
            Text(bodyText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
