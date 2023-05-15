//
//  DifficultyCapsule.swift
//  Hyoza
//
//  Created by sei on 2023/05/15.
//

import SwiftUI

struct DifficultyCapsuleView: View {
    var difficulty: String
    
    var body: some View {
        CapsuleView(content: {
            Text(difficulty)
                .font(.subheadline)
                .foregroundColor(.textOrange)
                .padding([.leading, .trailing], 10)
                .padding([.top, .bottom], 4)
        }, capsuleColor: .backGroundLightOrange)
    }
}
