//
//  GestureExampleView.swift
//  Flashzilla
//
//  Created by Dave Spina on 2/9/21.
//

import SwiftUI

struct GestureExampleView: View {
    @State private var currentAmount: CGFloat = 0
    @State private var finalAmount: CGFloat = 1
    
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .scaleEffect(finalAmount + currentAmount)
            .gesture(
                MagnificationGesture()
                    .onChanged {amount in
                        self.currentAmount = amount - 1
                    }
                    .onEnded { amount in
                        self.finalAmount += self.currentAmount
                        self.currentAmount = 0
                    }
            )
    }
}

struct GestureExampleView_Previews: PreviewProvider {
    static var previews: some View {
        GestureExampleView()
    }
}
