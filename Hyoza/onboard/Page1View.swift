//
//  SwiftUIView.swift
//
//
//  Created by 권다현 on 2023/05/12.
//

import SwiftUI

struct Page1View: View {
    var body: some View {
        VStack(spacing: 18) {
            Text("알아보기")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.textPointColor)
            Text("매일 새로운 질문으로 부모님과 소통하며\n평소에는 알 수 없었던 부모님에 대해 알아보세요!")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.textColor)
            Image("Page1")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.top, 16)
        }
    }
}

struct Page1View_Previews: PreviewProvider {
    static var previews: some View {
        Page1View()
    }
}
