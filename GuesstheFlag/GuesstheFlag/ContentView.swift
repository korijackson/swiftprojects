//
//  ContentView.swift
//  GuesstheFlag
//
//  Created by Jackson, Kori on 7/15/25.
//
/* Improvements:
   **adding all flags
   **more intriging graphic
   **better shuffling
*/

import SwiftUI

struct ContentView: View {
    //define variables
    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State var correctAnswer = Int.random(in: 0...2)

    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0

    @State private var endOfGame = false
    @State private var rounds = 0

    var body: some View {
        //ZStack(front to back)- being used to house background
        ZStack{
            //LinearGradient --> top to bottom or left to right
            //RadialGradient --> goes around in a circle(like aura nails)
            //AngulerGradient --> segments like cones in the circle(think color picker)
            LinearGradient(colors: [.blue,.black], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            //VStack(top to bottom)- adds name of the game and score
            VStack{
                //Spacrers are added here so that the game formats correctly on different iPhones
                Spacer()

                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                //holds adds spacing and background frame around flags
                VStack(spacing: 15) {
                    //holds instuctions and pictures of flags
                    VStack{
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.headline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))

                    }

                    //loops 3 times creating a new button of a flag each time
                    ForEach(0..<3) { number in
                        Button{
                            //checks that the flag is correct
                            flagTapped(number)
                        } label : {
                            Image(countries[number])
                                .clipShape(.capsule)
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))

                Spacer()
                Spacer()
                Text("Score: \(score) / 8")
                    .foregroundStyle(.white)
                    .font(.title.bold())

                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQeustion)
        }
        .alert("Game Over! \n Score: \(score)", isPresented: $endOfGame) {
            Button("Restart", action: resetGame)
        }
    }

    //checks that the flag tapped is the correct answer, limit the game to 8 rounds
    func flagTapped(_ number: Int){
        if number == correctAnswer {
            score += 1
            rounds += 1
            if rounds == 8 {
                endOfGame = true
            } else {
                askQeustion()
            }
        } else {
            scoreTitle = "Wrong! That is the flag of \(countries[correctAnswer])"
            showingScore = true
            rounds += 1
        }
    }

    //resets the game back to zero
    func resetGame() {
        score = 0
        rounds = 0
        endOfGame = false
        askQeustion()
    }

    //shuffles the countries array and picks the correct answer
    func askQeustion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

#Preview {
    ContentView()
}
