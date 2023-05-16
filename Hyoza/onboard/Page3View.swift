//
//  SwiftUIView.swift
//
//
//  Created by 권다현 on 2023/05/12.
//

import SwiftUI

struct Page3View: View {
    var body: some View {
        VStack(spacing: 18) {
            Text("기억하기")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.textPointColor)
            Text("세상에 단 하나뿐인 부모님의 이야기를\n하나로 모아 기억해보세요!")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.textColor)
            Image("Page3")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.top, 16)
        }
    }
}

struct Page3View_Previews: PreviewProvider {
    static var previews: some View {
        Page3View()
    }
}
