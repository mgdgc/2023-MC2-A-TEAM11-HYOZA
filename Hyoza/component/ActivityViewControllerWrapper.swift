//
//  ActivityViewControllerWrapper.swift
//  Hyoza
//
//  Created by 조한동 on 2023/05/10.
//

import Foundation
import SwiftUI

struct ActivityViewControllerWrapper: UIViewControllerRepresentable {
    let items: [Any]
    let activities: [UIActivity]?
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: activities)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
}
