//
//  ToastMessage.swift
//  Promise
//
//  Created by lena on 2023/05/17.
//

import SwiftUI

struct ToastMessage: View {
    let message: String
    let duration: Double
    let delay: Double
    
    @Binding var showToast: Bool
    
    var body: some View {

        VStack {
            Text(message)
                .foregroundColor(.white)
                .font(.system(size: 14))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.7))
                .cornerRadius(16)
                .opacity(showToast ? 1.0 : 0.0)
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                showToast = false
            }
        }
    }
}
