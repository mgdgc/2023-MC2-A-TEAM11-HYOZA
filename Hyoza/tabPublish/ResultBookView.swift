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
    }
    
    var count: Int = 30
    var title: String = "제목 블라블라"
    
    var body: some View {
        ZStack {
            Color.brown
                .cornerRadius(K.cornerRadius)
            
            HStack {
                spacer(width: K.wideWidth)
                bookLine
                Spacer()
                titleText
                Spacer()
                bookLine
                spacer(width: K.narrowWidth)
                bookLine
                spacer(width: K.wideWidth)
            }
        }
        .frame(width: UIScreen.screenWidth * K.scale, height: height)
    }
    
    func spacer(width: CGFloat) -> some View {
        Spacer()
            .frame(width: width)
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
        case ...0:
            return 0
        case ...50:
            return 50 + CGFloat(count)
        default:
            return 100
        }
    }
}

struct ResultBookView_Previews: PreviewProvider {
    static var previews: some View {
        ResultBookView(count: 50)
    }
}
