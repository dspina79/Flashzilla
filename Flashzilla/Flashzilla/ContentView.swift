//
//  ContentView.swift
//  Flashzilla
//
//  Created by Dave Spina on 2/9/21.
//

import SwiftUI

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = CGFloat(total - position)
        return self.offset(CGSize(width: 0, height: offset * CGFloat(total)))
    }
}

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityEnabled) var accessibilityEnabled
    @State private var feedback = UINotificationFeedbackGenerator()
    @State private var isActive = true
    @State private var timeRemaining = 100
    
    @State private var isTimerBuzzer = true
    @State private var showingEditScreen = false
    @State private var moveWrongAnswerBack = false
    @State private var isShowingSettingsSheet = false
    @State private var cardsCount = 0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var cards = [Card]()
    
    var body: some View {
        ZStack {
            Image(decorative: "background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)

            VStack {
                HStack {
                    Text(timeRemaining > 0 ? "Time:  \(timeRemaining)" : "Time's Up!")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .background(Capsule().fill(Color.black)
                        .opacity(0.75))
                        .onTapGesture(perform: {
                            if self.timeRemaining == 0 {
                                self.resetCards(newTime: 100)
                            }
                        })
               
                    Button(action: {
                        self.showingEditScreen = true
                    }) {
                        Image(systemName: "plus.circle")
                            .padding(10)
                            .background(Color.black.opacity(0.7))
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    }
                    .foregroundColor(.white)
                    .accessibility(label: Text("Add Card"))
                    .accessibility(hint: Text("Adds a card to your collection."))
                    
                    Button(action: {
                            self.isShowingSettingsSheet = true
                        self.showingEditScreen = true
                         }) {
                             Image(systemName: "pencil.circle")
                                 .padding(10)
                                 .background(Color.black.opacity(0.7))
                                 .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                         }
                         .foregroundColor(.white)
                         .accessibility(label: Text("Settings"))
                         .accessibility(hint: Text("Customize your Flashzilla user experience."))
                }
                
                ZStack {
                    ForEach(0..<self.cardsCount, id:\.self) {index in
                        VStack {
                           CardView(card: self.cards[index],
                            removal: {
                                withAnimation {
                                    self.removeCard(at: index, isWrong: false)
                                }
                            },
                            removalWrong: {
                                withAnimation {
                                    self.removeCard(at: index, isWrong: true)
                                    
                                }
                            })
                        }
                            .stacked(at: index, in: self.cardsCount)
                            .allowsHitTesting(index == self.cards.count - 1)
                            .accessibility(hidden: index < self.cards.count - 1)
                    }.id(self.cards)
                    
                
            }
                // end of ZStack
                .allowsHitTesting(timeRemaining > 0)
                
                if cards.count == 0 {
                    Button("Start Again", action: {
                        resetCards(newTime: 100)
                    })
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
            }
            
            
            if differentiateWithoutColor || accessibilityEnabled {
                VStack {
                    Spacer()
                    HStack {
                        Button(action: {
                            
                            withAnimation {
                                self.removeCard(at: self.cards.count - 1, isWrong: true)
                            }
                        }) {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibility(label: Text("Wrong"))
                        .accessibility(hint: Text("Mark your andswer as wrong."))
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                self.removeCard(at: self.cards.count - 1, isWrong: false)
                            }
                        }) {
                            Image(systemName: "checkmark.circle")
                                    .padding()
                                    .background(Color.black.opacity(0.7))
                                    .clipShape(Circle())
                        }
                        .accessibility(label: Text("Right"))
                        .accessibility(hint: Text("Mark your answer as being correct."))
                    }
                    .foregroundColor(.white)
                    .font(.title)
                }
            }
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: {
            resetCards(newTime: 100)
            if isShowingSettingsSheet {
                self.isShowingSettingsSheet = false
            }
        }) {
           self.isShowingSettingsSheet ?  AnyView(SettingsView(moveWrongCardBack: $moveWrongAnswerBack)) :  AnyView(EditCardsView())
        }
        .onReceive(timer) {timer in
            guard self.isActive else { return }
            self.feedback.prepare()
            if self.timeRemaining > 0 {
                self.isTimerBuzzer = true
                self.timeRemaining -= 1
            } else {
                if self.isTimerBuzzer {
                    self.feedback.notificationOccurred(.warning)
                    self.isTimerBuzzer = false
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) {_ in
            self.isActive = false
            
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification), perform: { _ in
            
            if !self.cards.isEmpty {
                self.isActive = true
            }
        })
        
        .onAppear(perform: {
            resetCards(newTime: 100)
        })
    }
    
    func printListing() {
        var index = 0
        for card in self.cards {
            print("\(index): \(card.prompt)")
            index += 1
        }
    }
    
    func loadSettings() {
        if let setting: Bool? = UserDefaults.standard.bool(forKey: SettingsView.FLASZILLA_SETTINGS_MOVE_WRONG_BACK_KEY) {
                self.moveWrongAnswerBack = setting ?? false
            return
        }
        
        self.moveWrongAnswerBack = false
    }
    
    func loadData() {
        print("Loading data")
        if let data = UserDefaults.standard.data(forKey: EditCardsView.FLASH_KEY) {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                self.cards = decoded
            }
        }
        self.cardsCount = self.cards.count
        self.loadSettings()
    }
    
    func resetCards(newTime: Int?) {
        loadData()
        self.timeRemaining = newTime ?? 100
        self.isActive = true
    }
    
    func getCardIndex(for card: Card) -> Int {
        return self.cards.firstIndex(where: {$0.id == card.id}) ?? 0
    }
    
    func removeCard(at index: Int, isWrong: Bool) {
        print("Old cards count: \(self.cards.count)")
        guard index >= 0 else { return }
        let cardCopy = self.cards[index]
            print("Index is: \(index). Count is \(self.cards.count)")
        if self.moveWrongAnswerBack && isWrong {
            if self.cards.count > 1 {
                self.cards.insert(cardCopy, at: 0)
                self.cards.remove(at: self.cards.count - 1)
            } else {
                self.cards.append(cardCopy)
            }
        } else {
            self.cards.remove(at: index)
        }
        print("New Cards count: \(self.cards.count)\n\n")
        if self.cards.count == 0 {
                self.isActive = false
        }
        self.cardsCount = self.cards.count
        printListing()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
