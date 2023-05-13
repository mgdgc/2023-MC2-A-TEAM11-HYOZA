//
//  CapsuleView.swift
//  Hyoza
//
//  Created by 최명근 on 2023/05/09.
//

import SwiftUI

struct CapsuleView<Content>: View where Content: View {
    
    @ViewBuilder var content: () -> Content
    var capsuleColor: Color = Color("AccentColor")
    
    var body: some View {
        content()
            .background(
                RoundedRectangle(cornerRadius: .infinity)
                    .fill(capsuleColor)
            )
    }
}

struct CapsuleView_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleView {
            Text("어려움")
        }
    }
}
