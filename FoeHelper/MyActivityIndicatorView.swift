//
//  MyActivityIndicatorView.swift
//
//
//  Created by George Karavas on 26/7/21.
//

import SwiftUI

@available(iOS 13, *)
public struct MyActivityIndicatorView: View {
    public init(){}
    
    @State private var isLoading = false
    
    public var body: some View {
        ZStack{
            Color.gray.opacity(0.5)
            
            Circle()
                .stroke(Color(.systemGray5), lineWidth: 14)
                .frame(width: 100, height: 100)
 
            Circle()
                .trim(from: 0, to: 0.2)
                .stroke(Color.green, lineWidth: 7)
                .frame(width: 100, height: 100)
                .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                .onAppear() {
                    self.isLoading = true
                }

        }
    }
}

@available(iOS 13, *)
struct MyActivityIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        MyActivityIndicatorView()
    }
}
