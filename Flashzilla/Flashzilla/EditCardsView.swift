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
    }

    func loadData() {
        // TODO: Implement
    }
    
    func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func removeCards(indexSet: IndexSet) {
        // TODO: implements
    }
    
    func addCard() {
        let card = Card(prompt: self.newPrompt, answer: self.newAnswer)
        cards.append(card)
        
        self.newAnswer = ""
        self.newPrompt = ""
    }
}

struct EditCardsView_Previews: PreviewProvider {
    static var previews: some View {
        EditCardsView()
    }
}
