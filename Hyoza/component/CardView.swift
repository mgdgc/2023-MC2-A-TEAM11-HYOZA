//
//  CardView.swift
//  Hyoza
//
//  Created by 최명근 on 2023/05/07.
//

import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct CardView<Content>: View where Content: View {
    var backgroundColor: Color = Color.cardPrimaryColor
    var cornerRadius: CGFloat = 8.0
    var shadowColor: Color = Color.black.opacity(0.3)
    var shadowRadius: CGFloat = 4
    var corners: UIRectCorner = .allCorners
    
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        content()
            .padding(EdgeInsets(top: 12, leading: 8, bottom: 12, trailing: 8))
            .background(
                Rectangle()
                    .fill(backgroundColor)
                    .cornerRadius(cornerRadius, corners: corners)
                    .shadow(color: shadowColor, radius: shadowRadius, y: shadowRadius == 0 ? 0 : shadowRadius / 2)
            )
    }
}


struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView {
            Text("Hello, world!")
        }
        .frame(width: 200, height: 400)
    }
}

//
struct Cardify: ViewModifier {
    var backgroundColor: Color = Color.cardPrimaryColor
    var cornerRadius: CGFloat = 8.0
    var shadowColor: Color = Color.black.opacity(0.3)
    var shadowRadius: CGFloat = 4
    var corners: UIRectCorner = .allCorners

    func body(content: Content) -> some View {
        content
            .padding(EdgeInsets(top: 12, leading: 8, bottom: 12, trailing: 8))
            .background(
                Rectangle()
                    .fill(backgroundColor)
                    .cornerRadius(cornerRadius, corners: corners)
                    .shadow(color: shadowColor, radius: shadowRadius, y: shadowRadius == 0 ? 0 : shadowRadius / 2)
            )
    }
}

extension View {
    func cardify(
        backgroundColor: Color = Color.cardPrimaryColor,
        cornerRadius: CGFloat = 8.0,
        shadowColor: Color = Color.black.opacity(0.3),
        shadowRadius: CGFloat = 4,
        corners: UIRectCorner = .allCorners
    ) -> some View {
        self.modifier(
            Cardify(
                backgroundColor: backgroundColor,
                cornerRadius: cornerRadius,
                shadowColor: shadowColor,
                shadowRadius: shadowRadius,
                corners: corners
            )
        )
    }
}
