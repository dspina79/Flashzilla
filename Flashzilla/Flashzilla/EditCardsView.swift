//
//  EditCardsView.swift
//  Flashzilla
//
//  Created by Dave Spina on 2/15/21.
//

import SwiftUI

struct EditCardsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var cards = [Card]()
    @State private var newPrompt = ""
    @State private var newAnswer = ""
    static var FLASH_KEY = "flashdata"
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Add New Card")) {
                    TextField("Prompt", text: $newPrompt)
                    TextField("Answer", text: $newAnswer)
                    Button("Add Card", action: addCard)
                }
                
                Section {
                    ForEach(0..<cards.count, id: \.self) {index in
                        VStack(alignment: .leading) {
                            Text(self.cards[index].prompt)
                                .font(.headline)
                            Text(self.cards[index].prompt)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete(perform: removeCards)
                }
            }
            .navigationBarTitle("Edit Cards")
            .navigationBarItems(trailing: Button("Done", action: dismiss))
            .listStyle(GroupedListStyle())
            .onAppear(perform: loadData)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    func loadData() {
        if let data = UserDefaults.standard.data(forKey: Self.FLASH_KEY) {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                self.cards = decoded
            }
        }
    }
    
    func saveData() {
        if let data = try? JSONEncoder().encode(self.cards) {
            UserDefaults.standard.set(data, forKey: Self.FLASH_KEY)
        }
    }
    
    func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func removeCards(at offset: IndexSet) {
        cards.remove(atOffsets: offset)
        saveData()
    }
    
    func addCard() {
        let trimmedPrompt = self.newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = self.newAnswer.trimmingCharacters(in: .whitespaces)
        
        
        guard !trimmedPrompt.isEmpty && !trimmedAnswer.isEmpty else { return }
            
        let card = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
        cards.append(card)
        
        self.newAnswer = ""
        self.newPrompt = ""
        
        saveData()
    }
}

struct EditCardsView_Previews: PreviewProvider {
    static var previews: some View {
        EditCardsView()
    }
}
