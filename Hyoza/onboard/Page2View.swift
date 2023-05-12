//
//  SwiftUIView.swift
//
//
//  Created by 권다현 on 2023/05/12.
//

import SwiftUI

struct Page2View: View {
    var body: some View {
        VStack(spacing: 18) {
            Text("생각하기")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color("TextPointColor"))
            Text("질문을 통해 부모님에 대한 생각을 적어보세요!\n                      ")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(Color("TextColor"))
            Image("Page2")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.top, 16)
        }
    }
}

struct Page2View_Previews: PreviewProvider {
    static var previews: some View {
        Page2View()
    }
}
