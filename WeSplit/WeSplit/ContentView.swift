//
//  ContentView.swift
//  WeSplit
//
//  Created by Jackson, Kori on 6/18/25.
//

import SwiftUI
//implement slider for tip
//landspape view??/
//no neg tips

//creates a stucture(kind od like a class; but swift also has classes) named ContentView that follows the View protocol
struct ContentView: View {
    //@State- a way to store a value that can change and automatically update your swiftUI view
    @State private var checkAmountText = "$0.00"
    @State private var checkAmount: Double = 0.0
    @State private var numPeople = 0
    @State private var tipPercent = 20
    @State private var customTipPercentText: String = "0%"
    @State private var customTip = 0.0
    let tipPercentages = [10,15,20,25,-1]

    //computed property- looks like a vaiable, but doesn't store a value, instead it calculates a value when asked
    var totalPerPerson: Double{
        let peopleCount = Double(numPeople + 2)//have to add 2, because the numPeople in the picker is off by 2; 2=0,1=3,2=4
        let tipSelection = Double(tipPercent)

        let tipAmount: Double
        let checkText = checkAmountText

        if checkText.isEmpty{
            return 0.0
        }

        tipAmount = tipPercent == -1 ? checkAmount * (Double(customTip) / 100) : checkAmount * (tipSelection / 100)

        let total = checkAmount + tipAmount

        let amountPerPerson = total / peopleCount

        return amountPerPerson
    }

    var total:Double{
        let totalCheck: Double
        let tip: Double
        let tipAmount: Double
        let checkText = checkAmountText

        if checkText.isEmpty || checkText == "$"{
            return 0.0
        }

        tip = tipPercent == -1 ? Double(customTip) : Double(tipPercent)

        tipAmount = checkAmount * (tip / 100)
        totalCheck = checkAmount + tipAmount

        return totalCheck
    }


    func formatCheckAmountTextAsCurrency() {
        //create and intance of the NumberFormatter and set the formatter style and locale
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current

        //strips the text so that only the number is left
        let cleaned = checkAmountText
            .replacingOccurrences(of: formatter.currencySymbol, with: "")
            .replacingOccurrences(of: ",", with: "")
            .trimmingCharacters(in: .whitespaces)

        //if let --> checks if the optional has a value, if it does the code block continue, otherwise the code block is skipped
        if let value = Double(cleaned) {
            checkAmount = value
            //formatter.string(from:)- calls the string method from NumberFormatter instance; from: tells the formatter which number to convert to a string
            //NSNumber(value: value)- value is a Double but NumberFormater expects a NSNumber, so this wraps value into an NSNumber to be used
            if let formatted = formatter.string(from: NSNumber(value: value)) {
                checkAmountText = formatted
            }
        }
    }

    func formatCustomTipAsPercent(){
            let formatter = NumberFormatter()
            formatter.numberStyle = .percent
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 0
            formatter.multiplier = 1 // Input is expected as whole number (e.g., "25" for 25%)

            let cleaned = customTipPercentText
                .replacingOccurrences(of: "%", with: "")
                .replacingOccurrences(of: ",", with: "")
                .trimmingCharacters(in: .whitespaces)

        if let value = Double(cleaned) {
            customTip = value
            if let formatted = formatter.string(from: NSNumber(value: customTip)) {
                customTipPercentText = formatted
            }
        }

    }

    //var body: some View - a computer property that returns the content and behavior of a view
    var body: some View {
        NavigationStack{
            Form{
                Section{
                    //TextField(Name, binding variable: when checkAmount changes so does value and vice versa, format tells the swift how to format the data)
                    //the inital value of the textfield is $0.00, bc swift assumes that checkAmount is a non optional numeric value
                    //??- nil coalescing operator, when the left side is nil, the default values will be executed(ie. USD)
                    //.keyboardType(.decimalPad)- a modifier that specifires the type of keyboard the user sees. in this example the user will see a decimalPad
                    TextField("Amount", text: $checkAmountText)
                        .keyboardType(.decimalPad)
                        .simultaneousGesture(TapGesture().onEnded({ _ in
                            checkAmountText = ""
                        }))
                        .onSubmit {
                            formatCheckAmountTextAsCurrency()
                        }
                    Picker("Number of People", selection: $numPeople){
                        ForEach(2..<100){
                            //how each row in the picker will be formated
                            Text("\($0) people")
                        }
                    }
                }
                Section("Tip Amount"){
                    //.naviagtionLink can be used instead of .segmented to allow for a wider range of numbers
                    //.segmented - allows for the horizontal numbers
                    Picker("Tip percent", selection: $tipPercent){
                        ForEach(tipPercentages, id: \.self){ percent in
                            if percent == -1{
                                Text("Custom")
                            }else{
                                Text("\(percent)%")
                            }
                        }
                    }
                    .pickerStyle(.segmented)

                    /*.simultaneousGesture()- allows the gesture to run at the same time as the other gestures in the same view
                            --> runs alongside other gestures
                     VS
                      .onTapGesture()- a view modifier in SwiftUI that lets you run code when a user taps on a view
                            --> can block other gestures

                     WHY ITS NEEDED HERE:
                         TextField already has built-in gestures for:
                         Focusing the field
                         Bringing up the keyboard
                         Handling taps for cursor placement
                     it was being blocked by the gestures above
                     */
                    //TapGesture()- creates a tap gesture reconizer(determines when the user taps the view
                    //.onEnded()- a closure that runs when the tap gesture ends
                    /*closure- a block of code often passed as an argument to a function; _ means that the closure accepts a parameter, but I am not using it;customTipPercentText = "" --> what the closure is actually doing; kind of like a deconstucted ForEach loop that can be assigned to a value:

                         let numbers = [1, 2, 3, 4, 5]

                         let doubled = numbers.map { number in
                             return number * 2
                         }

                         print(doubled)

                         VS

                         let numbers = [1, 2, 3, 4, 5]
                         var doubled: [Int] = []

                         numbers.forEach { number in
                             doubled.append(number * 2)
                         }
                         print(doubled)
                     */

                    if tipPercent == -1{
                        TextField("Custom tip %", text: $customTipPercentText)
                            .keyboardType(.numberPad)
                            .simultaneousGesture(TapGesture().onEnded({ _ in customTipPercentText = ""}))
                            .onSubmit {
                                formatCustomTipAsPercent()
                            }
                    }
                }
                Section("Total check"){
                    Text(total, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
                Section("Amount per person"){
                    Text(totalPerPerson,format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
            }
            .navigationTitle("We Split")
        }
    }
}

//allows swift to render a live preview of your SwiftUI view in the canvas
#Preview {
 ContentView()
 }


