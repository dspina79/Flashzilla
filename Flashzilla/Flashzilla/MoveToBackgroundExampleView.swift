//
//  MoveToBackgroundExampleView.swift
//  Flashzilla
//
//  Created by Dave Spina on 2/11/21.
//

import SwiftUI

struct MoveToBackgroundExampleView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                print("Moving to background....")
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification), perform: { _ in
                    print("Moving to foreground...")
            })
    }
}

struct MoveToBackgroundExampleView_Previews: PreviewProvider {
    static var previews: some View {
        MoveToBackgroundExampleView()
    }
}
