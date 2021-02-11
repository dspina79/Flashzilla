//
//  GestureExampleView.swift
//  Flashzilla
//
//  Created by Dave Spina on 2/9/21.
//

import SwiftUI

struct GestureExampleView: View {
    @State private var offset = CGSize.zero
    @State private var isDragging = false
    
    
    var body: some View {
        let dragGesture = DragGesture()
        .onChanged { value in
                    self.offset = value.translation
                }
        .onEnded { _ in
                withAnimation {
                    self.offset = CGSize.zero
                    self.isDragging = false
                }
            }
        let pressGesture = LongPressGesture()
            .onEnded { _ in
                withAnimation {
                    self.isDragging = true
                }
            }
        
        let combined = pressGesture.sequenced(before: dragGesture)
        
        return Circle()
            .fill(Color.red)
            .frame(width: 64, height: 64)
            .scaleEffect(isDragging ? 1.5 : 1)
            .offset(offset)
            .gesture(combined)
    }
}

struct GestureExampleView_Previews: PreviewProvider {
    static var previews: some View {
        GestureExampleView()
    }
}
