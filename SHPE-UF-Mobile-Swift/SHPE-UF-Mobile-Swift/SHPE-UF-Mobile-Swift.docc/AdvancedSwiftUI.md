# Article  
## Advanced UI, State, Project Architecture, & Testing  

Use the MVVM Model to separate the GUI from the business logic and back-end logic.  

---

## Overview  
As your program develops in complexity, it is essential that the code remains clean and readable. Advanced SwiftUI development focuses on managing complex state. A common design pattern UI developers use is the **MVVM Model (Model-View-ViewModel)**.  

---

## What is MVVM?  
The MVVM model helps organize code by separating three aspects:  

- **Model**:  
  The data layer of your application. It includes the data structures, business logic, and networking code. Models typically don’t contain any UI logic and can be reused in different parts of your app.  

- **View**:  
  What the user interacts with. This contains your View structs. Views should be simple, displaying only what the ViewModel tells them to. They should not handle any business logic.  

- **ViewModel**:  
  The logic that connects the data to the UI. It processes data from the Model into a form the View can use. It also features logic for handling user interactions, state management, and other behaviors.  

### Benefits of MVVM
By using the MVVM model, it becomes easier to:  
- **Maintain and Scale**: Each component has a clearly defined role, decreasing the likelihood of tangled code.  
- **Test Logic Independently**: The ViewModel can be tested without relying on the View or needing a UI.  
- **Promote Reusability**: The Model and ViewModel can be reused in different parts of the app.  

---

## Example Use Case: Weather App  
- **Model**: A struct `WeatherData`  
- **ViewModel**: A `WeatherViewModel` that gets the weather and displays it through `@Published var temperature: String`  
- **View**: A view that binds to `temperature` and displays it on screen.  

---

## Important Terminology  

- **@State**: A property wrapper type that can read and write a value managed by SwiftUI.  
- **@Binding**: Creates a two-way connection between a property that stores data, and a view that displays and changes the data (e.g., slider, text field).  
- **ObservableObject**: A protocol that allows reporting changes back to any SwiftUI view that’s watching.  
- **@Published**: A property wrapper used in `ObservableObject` to notify views of changes.  
- **@StateObject private var viewModel = ViewModel()**: Creates a `viewModel` object and includes all the `@Published` variables.  
- **@EnvironmentObject**: Shared data made available to all views through the application (similar to `ObservableObject`).  

---

## Slides  
📑 [Advanced UI, State, Project Architecture, & Testing Slides](https://docs.google.com/presentation/d/1IAY4hs3gzC8nBgj1y5qt-izIoc3W97bbpgwhK1qOfDA/edit#slide=id.g1f20eea1eaa_0_197)
