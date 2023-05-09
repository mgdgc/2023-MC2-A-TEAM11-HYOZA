//
//  Color+.swift
//  Hyoza
//
//  Created by sei on 2023/05/08.
//

import SwiftUI

extension Color {
    static var textColor: Color? { return Color(CustomColor.TextColor.rawValue) }
    static var backgroundColor: Color? { return Color(CustomColor.BackgroundColor.rawValue) }
    static var buttonColor: Color? { return Color(CustomColor.ButtonColor.rawValue) }
    static var buttonTextColor: Color? { return Color(CustomColor.ButtonTextColor.rawValue) }
    static var cardPrimaryColor: Color? { return Color(CustomColor.CardPrimaryColor.rawValue) }
    static var cardSecondaryColor: Color? { return Color(CustomColor.CardSecondaryColor.rawValue) }
}
