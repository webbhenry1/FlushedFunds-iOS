//
//  LoadingView.swift
//  LossTracker
//
//  Created by Henry Webb on 10/6/23.
//

import SwiftUI

struct LoadingView: View {
    @Binding var isLoadingCompleted: Bool
    @State var imageOpacity = 0.0
    @State private var progress: Double = 0.0


    var body: some View {
        ZStack{
            //background
            Color(red: 8 / 255.0, green: 89 / 255.0, blue: 72 / 255.0)
                .ignoresSafeArea(.all)
            
            VStack{
                Image("largeLogo")
                    .resizable()
                    .scaledToFit()

                BarView(prog: progress, wid: screenWidth()/1.5, hei: 10, col: .gray)
                    .frame(width: screenWidth()/1.5, height: 10)
                    .padding()
                    .opacity(imageOpacity+0.3)
            }
        }
        .onAppear(){
            withAnimation(.easeIn(duration: 1.0)) {
                imageOpacity = 1.0
            }
            withAnimation(.linear(duration: 1.3)) {
                progress = 1.0
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                    isLoadingCompleted = true
                }
            }
        }
    }
}


struct BarView: View {
    //vars
    var prog: Double
    var wid: Double
    var hei: Double
    var col: Color
    //view (two stacked rounded rectangles)
    var body: some View {
        ZStack {
            HStack{
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.7))
                    .frame(width: wid, height: hei)
                Spacer()
            }
            HStack{
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .frame(width: prog*wid, height: hei+1)
                Spacer()
            }
        }
    }
}
#Preview {
    LoadingView(isLoadingCompleted: .constant(false))
}
