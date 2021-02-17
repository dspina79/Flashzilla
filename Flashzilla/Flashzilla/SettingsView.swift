//
//  SettingsView.swift
//  Flashzilla
//
//  Created by Dave Spina on 2/16/21.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    public static let FLASZILLA_SETTINGS_MOVE_WRONG_BACK_KEY = "FlashMoveWrongBack"
    
    @Binding var moveWrongCardBack: Bool
    var body: some View {
        NavigationView {
            Form {
            Section(header: Text("Stack Organization")) {
                Toggle("Incorrect Answers to Back of Stack", isOn: $moveWrongCardBack)
            }
        }
            .navigationTitle(Text("Settings"))
            .navigationBarItems(trailing: Button("Done", action: {
                saveData()
                self.presentationMode.wrappedValue.dismiss()
                }))
        }
        .onAppear(perform: {
            self.loadSettings()
        })
    }
    
    func saveData() {
        UserDefaults.standard.setValue(self.moveWrongCardBack, forKey: Self.FLASZILLA_SETTINGS_MOVE_WRONG_BACK_KEY)
    }
    
    func loadSettings() {
        if let setting: Bool? = UserDefaults.standard.bool(forKey: Self.FLASZILLA_SETTINGS_MOVE_WRONG_BACK_KEY) {
                self.moveWrongCardBack = setting ?? false
            return
        }
        
        self.moveWrongCardBack = false
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let mb = false
        SettingsView(moveWrongCardBack: .constant(mb))
    }
}
