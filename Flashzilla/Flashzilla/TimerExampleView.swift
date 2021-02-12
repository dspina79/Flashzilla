//
//  TimerExampleView.swift
//  Flashzilla
//
//  Created by Dave Spina on 2/11/21.
//

import SwiftUI

struct TimerExampleView: View {
    // run timer:
    // event 1 second
    // on the main thread
    // in the common run loop
    // start counting time immediately through autoconnect
    let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()
    
    @State private var counter = 0
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onReceive(timer, perform: { time in
                if counter == 5 {
                    timer.upstream.connect().cancel()
                } else {
                    print("The time is \(time)")
                    self.counter += 1
                }
            })
    }
}

struct TimerExampleView_Previews: PreviewProvider {
    static var previews: some View {
        TimerExampleView()
    }
}
