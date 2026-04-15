# Article: Learning the Basics of SwiftUI  
Using the SwiftUI Library to code your first app  

## Overview  
SwiftUI is Apple’s UI framework that makes building apps for iOS, macOS, and more fast and intuitive. SwiftUI allows you to create user interfaces with code, using easy-to-read syntax. SwiftUI uses declarative syntax, which essentially means you describe what the UI should look like and how it should behave, and SwiftUI takes care of the rest.  

## Modifiers  
Modifiers are methods that you can call on views to change their appearance or behavior.  
You can use a modifier to change the text color, add padding, set a background, or apply many other configurations.  

```swift
Text("Hello, SwiftUI!")
    .font(.largeTitle)
    .foregroundColor(.blue)
    .padding()
    .background(Color.yellow)
```  

In this example, the text “Hello, SwiftUI!” is being modified so it has the font `largeTitle`, a blue text color, a yellow background, and pads the text.  

## User Interface  
In order to develop layout views in Swift, stacks can be used. There are three types of stacks:  
- **VStack**: Arrange views in the stack vertically  
- **HStack**: Arrange views in the stack horizontally  
- **ZStack**: Arrange views in the stack on top of each other  

## Property Wrappers  
Property Wrappers allow developers to define custom behavior or structure around a property, with specific logic being used to read and write the property’s value. Basically, it’s a way to reuse property logic and behavior without having to re-implement that logic every time.  

- **@State**: Used for basic data types like strings, Int, and booleans. Commonly tied to a single view. When it undergoes changes, SwiftUI updates the relevant sections of the view.  

Example:  
```swift
struct ContentView: View {
    @State private var username: String
}
```  

## Example Code  
Here’s a simple example to understand in a bit more detail how programming with Swift works.  

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
            .font(.title)
    }
}
```  

### What does each line of code mean?  
- **struct ContentView: View {** → This defines a UI component (or ‘View’).  
- **var body: some View** → Every view must have a body, which tells SwiftUI what should be displayed.  
- **Text("Hello, world!")** → This is a simple element, a label with text.  
- **.padding() and .font(.title)** → These are both modifiers that style the view. You can combine multiple modifiers to customize the appearance and layout.  

It’s very easy to use Swift to develop whatever program you desire. Swift’s functions are easy to read and utilize, allowing even beginner programmers to create complex programs.  

## Slides for learning SwiftUI  
[Google Slides Link](https://docs.google.com/presentation/d/10dfkNgtRUefET-rtm45hjElI4hhrht8Wl7gTJ-TPyVE/edit#slide=id.g2b774e39a31_0_0)  

_Current page is Learning the Basics of SwiftUI._  
