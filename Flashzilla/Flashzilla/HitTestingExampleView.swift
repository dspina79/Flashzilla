//
//  HitTestingExampleView.swift
//  Flashzilla
//
//  Created by Dave Spina on 2/10/21.
//

import SwiftUI

struct OddShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let myRect = CGRect(x: 0, y: 0, width: 100, height: 100)
        path.addRect(myRect)
        return path
    }
}

struct HitTestingExampleView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.blue)
                .frame(width: 300, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .onTapGesture {
                    print("Rectangle tapped")
                }
            
            Circle()
                .fill(Color.purple)
                .contentShape(OddShape())
                .frame(width: 300, height: 300, alignment:  .center)
                .onTapGesture {
                    print("Circle tapped")
                }
            
                // the above will disable the tap event and will go down to the rectangle
        }
    }
}

struct HitTestingExampleView_Previews: PreviewProvider {
    static var previews: some View {
        HitTestingExampleView()
    }
}
