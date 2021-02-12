//
//  AccessibilitySettingReviewView.swift
//  Flashzilla
//
//  Created by Dave Spina on 2/11/21.
//

import SwiftUI

struct AccessibilitySettingReviewView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    var body: some View {
        HStack {
            if differentiateWithoutColor {
                Image(systemName: "checkmark.circle")
            }
            
            Text("Success")
                .padding()
                .background(differentiateWithoutColor ? Color.black : Color.green)
                .foregroundColor(Color.white)
                .clipShape(Capsule())
        }
    }
}

struct AccessibilitySettingReviewView_Previews: PreviewProvider {
    static var previews: some View {
        AccessibilitySettingReviewView()
    }
}
