//
//  ContentView.swift
//  Math Tutor
//
//  Created by Lori Rothermel on 3/25/23.
//

import SwiftUI
import AVFAudio

struct ContentView: View {
    @State private var firstNumber = 0
    @State private var secondNumber = 0
    @State private var firstNumberEmojis = ""
    @State private var secondNumberEmojis = ""
    @State private var answer = ""
    @State private var textFieldIsDisabled = false
    @State private var guessButtonIsDisabled = false
    @State private var message = ""
    @State private var audioPlayer: AVAudioPlayer!
    
    @FocusState private var textFieldIsFocused: Bool
    
    
    private let emojis = ["🍕", "🍎", "🍏", "🐵", "👽", "🧠", "🧜🏽‍♀️", "🧙🏿‍♂️", "🥷", "🐶",
                          "🐹", "🐣", "🦄", "🐝", "🦉", "🦋", "🦖", "🐙", "🦞", "🐟",
                          "🦔", "🐲", "🌻", "🌍", "🌈", "🍔", "🌮", "🍦", "🍩", "🍪"   ]
    
    
    
    
    
    var body: some View {
        
        VStack {
            
                Text(firstNumberEmojis)
                    .font(.system(size: 80))
                    .minimumScaleFactor(0.25)
                    .multilineTextAlignment(.center)
            
                Text("+")
                .font(.system(size: 80))
                .minimumScaleFactor(0.25)
            
                Text(secondNumberEmojis)
                    .font(.system(size: 80))
                    .minimumScaleFactor(0.25)
                    .multilineTextAlignment(.center)
                        
            Spacer()
            
            Text("\(firstNumber) + \(secondNumber) =")
            .font(.largeTitle)
            
            TextField("", text: $answer)
                .font(.largeTitle)
                .textFieldStyle(.roundedBorder)
                .frame(width: 60)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray, lineWidth: 2)
                }  // overlay
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .focused($textFieldIsFocused)
                .disabled(textFieldIsDisabled)
            
            Button("Guess") {
                textFieldIsFocused = false
                
                let result = firstNumber + secondNumber
                
                if let answerValue = Int(answer) {
                    if answerValue == result {
                        playSound(soundName: "correct")
                        message = "Correct!"
                    } else {
                        playSound(soundName: "wrong")
                        message = "Wrong! The correct answer is \(firstNumber + secondNumber)"
                    }
                } else {
                    playSound(soundName: "wrong")
                    message = "Wrong! The correct answer is \(firstNumber + secondNumber)"
                }

                textFieldIsDisabled = true
                guessButtonIsDisabled = true
            }  // Button - Guess
            .buttonStyle(.borderedProminent)
            .disabled(answer.isEmpty || guessButtonIsDisabled)
            
            Spacer()
            
            Text(message)
                .font(.largeTitle)
                .fontWeight(.black)
                .multilineTextAlignment(.center)
                .foregroundColor(message == "Correct!" ? .green : .red)
            
            if guessButtonIsDisabled {
                Button("Play Again?") {
                    guessButtonIsDisabled = false
                    answer = ""
                    textFieldIsDisabled = false
                    message = ""
                    generateNewEquation()
                }  // Button - Play Again
            }  // if
                    
        }  // VStack
        .onAppear() {
            generateNewEquation()
        }  // onAppear
        
    }  // some View

    func generateNewEquation() {
        firstNumber = Int.random(in: 1...10)
        secondNumber = Int.random(in: 1...10)
        firstNumberEmojis = String(repeating: emojis.randomElement()!, count: firstNumber)
        secondNumberEmojis = String(repeating: emojis.randomElement()!, count: secondNumber)
    }
    
    
    func playSound(soundName: String) {
        
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("🤬 Could not read file name \(soundName))")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("🤬 ERROR: \(error.localizedDescription) creating audioPlayer")
        }
    }  // End of playSound func
    

}  // ContentView

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
