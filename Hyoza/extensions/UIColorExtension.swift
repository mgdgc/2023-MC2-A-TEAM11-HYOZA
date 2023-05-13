//
//  UIColor+.swift
//  Hyoza
//
//  Created by sei on 2023/05/08.
//

import UIKit

extension UIColor {
    static var backgroundColor: UIColor? { return UIColor(named: CustomColor.BackgroundColor.rawValue) }
    static var buttonColor: UIColor? { return UIColor(named: CustomColor.ButtonColor.rawValue) }
    static var buttonTextColor: UIColor? { return UIColor(named: CustomColor.ButtonTextColor.rawValue) }
    static var cardPointColor: UIColor? { return UIColor(named: CustomColor.CardPointColor.rawValue) }
    static var cardPrimaryColor: UIColor? { return UIColor(named: CustomColor.CardPrimaryColor.rawValue) }
    static var cardSecondaryColor: UIColor? { return UIColor(named: CustomColor.CardSecondaryColor.rawValue) }
    static var SelectedColor: UIColor? { return UIColor(named: CustomColor.SelectedColor.rawValue) }
    static var textColor: UIColor? { return UIColor(named: CustomColor.TextColor.rawValue) }
    static var textPointColor: UIColor? { return UIColor(named: CustomColor.TextPointColor.rawValue) }
    static var textSecondaryColor: UIColor? { return UIColor(named: CustomColor.TextSecondaryColor.rawValue) }
    static var textThirdColor: UIColor? { return UIColor(named: CustomColor.TextThirdColor.rawValue) }
}
