//
//  EventCreatorView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Evan Schroeder on 3/3/25.
//

import SwiftUI

struct EventCreatorView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View{
        ZStack{
            Color(.darkdarkBlue)
                .ignoresSafeArea(edges: .all)
            
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.white))
                    .frame(width: 320, height: 750, alignment: .topLeading)
                ScrollView{
                    VStack{
                        HStack{
                            Image("CreateEventWord")
                                .resizable()
                                .frame(width:180, height: 30, alignment: .trailing)
                                .padding(.trailing, 40)
                                
                            Button{
                                dismiss()
                            }label:{
                                ExitButton()
                            }
                        }
                        .padding(.top, 60)
                        .padding(.bottom, 20)
                        
                        InputGrid()
                        
                        Button{
                            print("tapped")
                        }label:{
                            ZStack{
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color(.rblue))
                                    .frame(width: 113, height: 42, alignment: .trailing)
                                
                                Text("Create")
                                    .foregroundColor(.white)
                                    .font(Font.custom("UniversLTStd", size: 20))
                            }
                            .padding(.trailing, 145)
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct ExitButton: View {
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 5)
                .fill(Color(.lightGray))
                .frame(width: 30, height: 30)
            
            Image("xMark")
                .resizable()
                .frame(width: 20, height: 20)
        }
    }
}

struct TextBox: View {
    @State var inputText: String = ""
    var name: String
    var body: some View{
        VStack{
            HStack{
                Text(name)
                    .font(Font.custom("UniversLTStd", size: 20))
                    .padding(.leading, 70)
                    .padding(.top, 15)
                Spacer()
            }
            TextField("", text: $inputText)
                .padding()
                .frame(width: 260, height: 40, alignment: .center)
                .background(Color.lightGray)
                .cornerRadius(8)
                .foregroundColor(.black)
            }
        .padding(.bottom, 5)
        }
}

struct DropDownBox: View{
    var name : String
    var options: [String]
    
    @State private var isExpanded = false
    @Binding var selection: String?
    
    var body: some View{
        VStack(alignment: .leading){
            HStack{
                Text(name)
                    .font(Font.custom("UniversLTStd", size: 20))
                    .padding(.leading, 70)
                    .padding(.top, 15)
                Spacer()
            }
            VStack{
                HStack{
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                        .frame(width: 8, height: 8)
                        .rotationEffect(.degrees(isExpanded ?  180 : 0))
                        .padding(.trailing)
                }
                .frame(height: 40)
                .background(Color.lightGray)
                .onTapGesture {
                    withAnimation(.snappy){
                        isExpanded.toggle()
                    }
                }
                if isExpanded {
                    VStack{
                        ForEach(options, id: \.self){option in
                            ZStack{
                                RoundedRectangle(cornerRadius: 8)
                                HStack{
                                    Text(option)
                                    Spacer()
                                }
                            }
                            .frame(height: 40)
                            
                            .padding(.horizontal)
                            .onTapGesture {
                                withAnimation(.snappy){
                                    selection = option
                                    isExpanded.toggle()
                                }
                            }
                        }
                    }
                    .transition(.move(edge: .bottom))
                }
            }
            .background(Color.lightGray)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .frame(width: 260, height: 40)
            .padding(.leading, 70)
        }
    }
}

struct InputGrid: View {
    
    let Categories = [
        "Hangout",
        "Tutoring",
        "Workshop",
        "GBM"
    ]
    
    let ExpiresIn = [
        "Today",
        "tomorrow",
        "tuesday"
    ]
    
    @State var selectedCategory: String?
    @State var selectedDate: String?
    
    var body: some View {
        VStack{
            TextBox(name: "Name")
            TextBox(name: "Code")
            TextBox(name: "Password")
            DropDownBox(name: "Category",
                        options: Categories,
                        selection: $selectedCategory)
            
            TextBox(name: "Points")
            DropDownBox(name: "Expires in",
                        options: ExpiresIn,
                        selection: $selectedDate)
        }
        .padding(.bottom, 10)
    }
}


#Preview {
   EventCreatorView()
}

class CreatedEvent: ObservableObject {
    @Published var name: String = ""
    @Published var Code: String = ""
    @Published var Password: String = ""
    @Published var Category: String = ""
    @Published var Points: String = ""
    @Published var ExpiresIn: String = ""
}
