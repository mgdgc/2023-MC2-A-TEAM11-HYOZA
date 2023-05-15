//
//  SwiftUIView.swift
//
//
//  Created by 권다현 on 2023/05/12.
//

import SwiftUI

struct OnboardingView: View {
    
    @State private var selected: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selected) {
                Page1View()
                    .tag(0)
                
                Page2View()
                    .tag(1)
                
                Page3View()
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .never))
            .padding(.top, 60)
            .onAppear(perform: {
                UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(named: "SelectedColor")
                UIPageControl.appearance().pageIndicatorTintColor = UIColor(named: "CapsuleColor")
            })
            
            Button {
                // 1, 2 페이지인 경우
                if selected < 2 {
                    selected += 1
                } else {
                    // 3 페이지인 경우
                    // TODO: Main Page 이동
                }
                
            } label: {
                HStack {
                    Spacer()
                    Text(selected < 2 ? "다음" : "시작하기").font(.system(size: 20))
                        .padding(10)
                    Spacer()
                }
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .padding(20)
            .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 4)
            
            Button {
                
            } label: {
                Text("Skip").font(.system(size:15))
                    .foregroundColor(Color("TextThirdColor"))
            }
            .opacity(selected < 2 ? 1 : 0)
            
        }
        .padding(.bottom, 40)
        .background(
            Color("BackgroundColor")
                .ignoresSafeArea()
        )
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
