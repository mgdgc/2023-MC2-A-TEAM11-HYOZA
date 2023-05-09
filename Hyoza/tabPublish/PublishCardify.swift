//
//  PublishCardify.swift
//  Hyoza
//
//  Created by sei on 2023/05/09.
//

import Foundation
import SwiftUI

struct PublishCardify: ViewModifier {
    func body(content: Content) -> some View {
        CardView(shadowColor: .black.opacity(0.1)) {
            content
        }
        .padding()
    }
}


extension View {
    func publishCardify() -> some View {
        self.modifier(PublishCardify())
    }
}
