//
//  ResultBookView.swift
//  Hyoza
//
//  Created by sei on 2023/05/09.
//

import SwiftUI

struct ResultBookView: View {
    private enum K {
        static let cornerRadius: CGFloat = 4
        static let wideWidth: CGFloat = 20
        static let narrowWidth: CGFloat = 5
        static let scale = 0.7
        static let maxHeight: CGFloat = 200
        static let defaultHeight: CGFloat = 50
    }
    
    var count: Int
    var title: String
    
    var body: some View {
        HStack {
            bookLine
                .padding(.leading, K.wideWidth)
            Spacer()
            titleText
            Spacer()
            bookLine
                .padding(.trailing, .zero)
            bookLine
                .padding(.trailing, K.wideWidth)
        }
        .frame(width: UIScreen.screenWidth * K.scale, height: height)
        .background {
            Color.brown
                .cornerRadius(K.cornerRadius)
        }
    }
    
    var bookLine: some View {
        Rectangle()
            .fill(.white)
            .frame(width: K.narrowWidth)
    }
    
    var titleText: some View {
        Text(title)
            .bold()
            .foregroundColor(.white)
    }
    
    var height: CGFloat {
        switch count{
        case ...Int.zero:
            return .zero
        case ...(Int(K.maxHeight) - Int(K.defaultHeight)):
            return K.defaultHeight + CGFloat(count)
        default:
            return K.maxHeight
        }
    }
}

struct ResultBookView_Previews: PreviewProvider {
    static var previews: some View {
        ResultBookView(count: 0, title: "제목")
    }
}
