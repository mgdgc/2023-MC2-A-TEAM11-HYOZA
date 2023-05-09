//
//  ColorWithHex.swift
//  Hyoza
//
//  Created by HAN GIBAEK on 2023/05/09.
//

import SwiftUI

extension Color {
    
    static let backGroundWhite = Color(hex: "FFFDFA")
    static let backGroundLightOrange = Color(hex: "FEE8C8")
    static let backGroundOrange = Color(hex: "FFB647") // same as tapBarOrange
    
    static let textWhite = Color(hex: "FFFFFF")
    static let textBlack = Color(hex: "291800")
    static let textOrange = Color(hex: "F59300")
    static let textLightGray = Color(hex: "CFCAC3")
    
    static let tapBarDarkGray = Color(hex: "7D7264")
    static let tapBarOrange = Color(hex: "FFB647") // same as backGroundOrange
    
    static let cardLightOrange = Color(hex: "FFF7EB")
    
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >>  8) & 0xFF) / 255.0
        let b = Double((rgb >>  0) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

