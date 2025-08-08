//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Jackson, Kori on 7/30/25.
//

/*
 Structs vs Classes
    *Structs
        *almost always used over classes
        *simpler and faster than classes
        *forces us to think about isolating state in a clean way
    *Classes
        *classes are able to change their values freely, which can lead to messier code
 */

/*
 there is NOTHING behind the main SwiftUI view
 example:
     var body: some View {
         VStack {
             Image(systemName: "globe")
                 .imageScale(.large)
                 .foregroundStyle(.tint)
             Text("Hello, world!")
         }
         .padding()
         .background(.red)
     }
    *this will make just the small portion of the screen behind the text and picutre red.
    *do NOT try to make the sea of white around it red by editing the main view, as it causes larger issue
        *potentially making the app not compatible with iOS
    *istead try to edit the size of the VStack
 */

/*
 *the order of modifiers matters because each modifier creates a new stuct with the modifier applied
 *example:
     Button("Hello, world!") {
         //no action
     }
     .background(Color.red)
     .frame(width: 200, height: 200)
    *this code will output a 200x200 white view with the text "Hello, world!" highlighted

    VS.
     Button("Hello, world!") {
         //no action
     }
     .frame(width: 200, height: 200)
     .background(Color.red)
    *this code will output a 200x200 red view

 */

/*
 * think of the View protocal as an array being defined
    *we know it is an array, but we don't know the type of object inside until specifed
    *var body: [blank] - allows you to fill in the type
        *some View
        *Text
        *Image

 */

/*
 Conditional Modifiers - sometimes a modifier will change based on a certain condition
    *typically ternary operators are used to execute this
    *example
     @State private var usePinkText = false

     var body: some View {
         Button("Hello, world!") {
             usePinkText.toggle()
         }
         .foregroundStyle(usePinkText ? .pink : .purple)
     }
 */

/*
 Environment Modifiers - dynamically alter a views's behavior based on information stored in the environment
    *can be overridden by a child view's modifiers
    *example
     var body: some View {
         VStack {
             Text("Gryffindor")
                .font(.largeTitle)
             Text("Hufflepuff")
             Text("Ravenclaw")
             Text("Slytherin")
         }
         .font(.title)
     }
        *all of the text inside the VStack will have the title font, except for Gryffindor which has been overriden
        *some modifiers do not adhere to these rules, so you should always check documentaion
 */

/*
 *one way to make complicated views is by making views into properties, then placing them in another view
    *reduces the amount of complicated logic in the body
         struct ContentView: View {
             let motto1 = Text("Never have I ever")
             let motto2 = Text("Could've, Should've, Would've")


             var body: some View {
                 VStack {
                     motto1
                         .foregroundStyle(.pink)
                     motto2
                 }
                 .font(.title)
             }
         }
 *swift does NOT let one stored property refer to another stored property
    *to work around this we can make views as computeted properties

         struct ContentView: View {
             //can only return 1 View if not using a container or ViewBuilder
             var motto1: some View {
                 Text("Never have I ever")
             }

             //using containers to return multiple views
             var motto2: some View {
                 VStack {
                     Text("Lumos")
                     Text("Obliviate")
                 }
             }

             var spells: some View {
                 //Group - will organize things based on how they are used
                 Group {
                     Text("bibiti bobiti boo")
                     Text("the clock strikes midnight")
                 }
             }

             //using @ViewBuilder to return multiple views
             //@ViewBuilder - works like the body property; allow you to return multiple views from a single block of code without wrapping thm in a container
             @ViewBuilder var colors: some View {
                     Text("orange")
                     Text("pink")
                     Text("purple")
             }

             var body: some View {
                 VStack {
                     motto1
                         .foregroundStyle(.pink)
                     motto2
                     spells
                         .foregroundStyle(.green)
                     colors
                         .foregroundStyle(.blue)
                 }
                 .font(.title)
             }
         }
 */

/*
 *custom modifiers can be used to reduce repetitve code
     struct CapsuleText: View {
         var text: String

         var body: some View {
             Text(text)
                 .font(.largeTitle)
                 .padding()
                 .foregroundColor(.white)
                 .background(Color.blue)
                 .clipShape(Capsule())
         }
     }

     struct ContentView: View {
         var body: some View {
             VStack(spacing: 10) {
                 Text("First")
                     .font(.largeTitle)
                     .padding()
                     .foregroundStyle(.white)
                     .background(.blue)
                     .clipShape(.capsule)

                 CapsuleText(text: "Second")

             }
         }
     }
 *above the CapsuleText: View acheives the same thing as the modifiers on "First" but can be used over and over

     //custom viewModifiers MUST have a fuction called body to conform to the ViewModifier protocol
     struct Title: ViewModifier {
         func body(content: Content) -> some View {
             content
                 .font(.largeTitle)
                 .foregroundStyle(.white)
                 .padding()
                 .background(.blue)
                 .clipShape(.rect(cornerRadius: 10))
         }
     }

     //extentions make custom modifiers easier and cleaner to use
     extension View {
         func titleStyle() -> some View {
             modifier(Title())
         }
     }

     struct ContentView: View {
         var body: some View {
             Text("Hello World")
                 .modifier(Title())
             Text("Goodbye World")
                 .titleStyle()
         }
     }
 */

import SwiftUI

//custom viewModifiers MUST have a fuction called body to conform to the ViewModifier protocol
struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundStyle(.white)
            .padding()
            .background(.blue)
            .clipShape(.rect(cornerRadius: 10))
    }
}

//extentions make custom modifiers easier and cleaner to use
extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct ContentView: View {
    var body: some View {
        Text("Hello World")
            .modifier(Title())
        Text("Goodbye World")
            .titleStyle()
    }
}

#Preview {
    ContentView()
}
