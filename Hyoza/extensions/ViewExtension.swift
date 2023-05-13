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
    
    
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
    
        // Set appearance for both normal and large sizes.
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
    
        return self
    }
}
