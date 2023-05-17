//
//  ContentView.swift
//  Promise
//
//  Created by dylan on 2023/04/29.
//

import SwiftUI

struct ContentView: View {
    @State private var showToast = false

    var body: some View {
        VStack {
            Spacer()
            ZStack {
                Button(action: {
                    showToast.toggle()
                }) {
                    Text("Promise")
                        .fontWeight(.semibold)
                        .font(.title)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.yellow)
                        .cornerRadius(30)
                }
                .frame(maxWidth: .infinity)

                if showToast {
                    ToastMessage(message: "새로운 약속이 생성되었습니다", duration: 2.0, delay: 1.0, showToast: $showToast)
                        .offset(y: UIScreen.main.bounds.height * 0.4)
                }
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
