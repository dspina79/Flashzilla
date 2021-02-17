//
//  CardView.swift
//  Flashzilla
//
//  Created by Dave Spina on 2/13/21.
//

import SwiftUI

struct CardView: View {
    @Environment(\.accessibilityEnabled) var accessibilityEnabled
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @State private var feedback = UINotificationFeedbackGenerator()
    let card: Card
    
    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero
    @State private var prevOffset = CGSize.zero
    var removal: (() -> Void)? = nil
    var removalWrong: (() -> Void)? = nil
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                .fill(
                    differentiateWithoutColor ? Color.white :
                    Color.white.opacity(1 - Double(abs(offset.width/50))))
                .background(
                    differentiateWithoutColor ? nil :
                    RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/, style: .continuous)
                        .fill(offset.width > 0 || (prevOffset.width > 0 && prevOffset.width > offset.width) ? Color.green : Color.red)
                    )
                .shadow(radius: 10)
            VStack {
                if accessibilityEnabled {
                    Text(isShowingAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                } else {
                    Text(card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                    if isShowingAnswer {
                        Text(card.answer)
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(Double(offset.width / 5)))
        .offset(x: offset.width * 5, y: 0)
        .opacity(2 - Double(abs(offset.width / 50)))
        .accessibility(addTraits: .isButton)
        .gesture (
            DragGesture()
                .onChanged { gesture in
                    self.feedback.prepare()
                    self.prevOffset = self.offset
                    self.offset = gesture.translation
                }
                .onEnded { _ in
                    if (abs(self.offset.width) > 100) {
                        if self.offset.width > 0 {
                            self.feedback.notificationOccurred(.success)
                            self.removal?()
                        } else {
                            self.feedback.notificationOccurred(.error)
                            self.removalWrong?()
                        }
                    } else {
                        self.offset = .zero
                    }
                }
        )
        .onTapGesture {
            self.isShowingAnswer.toggle()
        }
        .animation(.spring())
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CardView(card: Card.example)
                .previewLayout(.device)
            CardView(card: Card.example)
                .previewLayout(.device)
        }
    }
}
