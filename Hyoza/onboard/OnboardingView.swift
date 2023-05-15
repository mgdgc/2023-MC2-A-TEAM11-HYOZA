//
//  SwiftUIView.swift
//
//
//  Created by 권다현 on 2023/05/12.
//

import SwiftUI

struct OnboardingView: View {
    
    @Binding var showOnboardingView: Bool
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
            
            ButtonView (content: (selected < 2 ? "다음" : "시작하기")) {
                // 1, 2 페이지인 경우
                if selected < 2 {
                    selected += 1
                } else {
                    // 3 페이지인 경우
                    // 최초 접속 여부 저장
                    UserDefaults.standard.set(false, forKey: UserDefaultsKey.isFirstLaunching.rawValue)
                    // 메인 화면 전환
                    showOnboardingView = false
                }
            }
            
            Button {
                // 최초 접속 여부 저장
                UserDefaults.standard.set(false, forKey: UserDefaultsKey.isFirstLaunching.rawValue)
                // 메인 화면 전환
                showOnboardingView = false
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
        OnboardingView(showOnboardingView: .constant(true))
    }
}
