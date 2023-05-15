//
//  PublishCardify.swift
//  Hyoza
//
//  Created by sei on 2023/05/09.
//

import Foundation
import SwiftUI

struct PublishCardify: ViewModifier {
    let opacity: CGFloat = 0.1
    
    func body(content: Content) -> some View {
        CardView(shadowColor: .black.opacity(opacity)) {
            content
        }
        .padding(.vertical)
    }
}


extension View {
    func publishCardify() -> some View {
        self.modifier(PublishCardify())
    }
}
