//
//  ViewExtension.swift
//  Hyoza
//
//  Created by 최명근 on 2023/05/09.
//

import SwiftUI

extension View {
    
    /// scale 인수는 @Environment(\.displayScale) 값을 넣는다.
    @MainActor func render(scale: CGFloat? = nil) -> UIImage? {
        let renderer = ImageRenderer(content: self)
        if let scale = scale {
            renderer.scale = scale
        }
        
        return renderer.uiImage
    }
    
}
