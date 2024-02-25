//
//  MainView.swift
//  ColorMatch
//
//  Created by Marzia Pirozzi on 23/02/24.
//

import SwiftUI

extension Color {
    static var random: Color {
        return Color(
            red: Double((Int.random(in: 0...255))) / 255.0,
            green: Double(Int.random(in: 0...255)) / 255.0,
            blue: Double(Int.random(in: 0...255)) / 255.0
        )
    }
}

func getSimilarity(color1: Color, color2: Color) -> Double {
    let distance = euclideanDistance(color1: color1, color2: color2)
    let similarity = 100.0 * (1.0 - distance)
    return max(0.0, similarity)
}


func euclideanDistance(color1: Color, color2: Color) -> Double {
    let components1 = color1.cgColor?.components
    let components2 = color2.cgColor?.components
    
    let redDiff = components1![0] - components2![0]
    let greenDiff = components1![1] - components2![1]
    let blueDiff = components1![2] - components2![2]
    
    let distance = sqrt(pow(redDiff, 2) + pow(greenDiff, 2) + pow(blueDiff, 2))
    
    return distance
}


func P3TosRGB(color: Color) -> Color {
    
    let newColor = color.cgColor!.converted(to: CGColorSpace(name: CGColorSpace.sRGB)!, intent: .defaultIntent, options: nil)!
    
    return Color(newColor)
}




struct MainView: View {
    
    @State private var trueColor = Color.black
    @State private var myColor = Color.black
    @State private var percentage = 0.0
    @State private var submitted = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                Button(action: {
                    
                    trueColor = Color.random
                    submitted=false
                    myColor=Color.black
                    
                    
                }, label: {
                    Text("New color")
                        .font(.largeTitle)
                })
                
                Spacer()
                HStack{
                    Spacer()
                    Rectangle()
                        .frame(width: geometry.size.width * 0.35, height: geometry.size.width * 0.35)
                        .foregroundStyle(trueColor)
                        .clipShape(.rect(cornerRadius: 15))
                        .contextMenu(ContextMenu(menuItems: {
                            Text("r:\(Int((trueColor.cgColor?.components![0])!*255)) g:\(Int((trueColor.cgColor?.components![1])!*255)) b:\(Int((trueColor.cgColor?.components![2])!*255))")
                        }))
                    
                    Spacer()
                    
                    Rectangle()
                        .frame(width: geometry.size.width * 0.35, height: geometry.size.width * 0.35)
                        .foregroundStyle(myColor)
                        .clipShape(.rect(cornerRadius: 15))
                        .contextMenu(ContextMenu(menuItems: {
                            Text("r:\(Int((myColor.cgColor?.components![0])!*255)) g:\(Int((myColor.cgColor?.components![1])!*255)) b:\(Int((myColor.cgColor?.components![2])!*255))")
                        }))
                    Spacer()
                }
                
                Spacer()
                
                ColorPicker("Try to match", selection: $myColor, supportsOpacity: false)
                    .labelsHidden()
                    .pickerStyle(.wheel)
                
                Spacer()
                
                Button(action: {
                    
                    if(myColor.cgColor?.colorSpace?.name==CGColorSpace.sRGB){
                        let newCol=P3TosRGB(color: trueColor)
                        percentage=getSimilarity(color1: newCol, color2: myColor)
                    }else{
                        let newMyCol=P3TosRGB(color: myColor)
                        percentage=getSimilarity(color1: trueColor, color2: newMyCol)
                    }
                    
                    submitted=true
                    
                }, label: {
                    Text("Submit")
                        .font(.largeTitle)
                })
                
                Spacer()
                
                if(submitted){
                    Text("You were \(String(format: "%.2f", percentage))% accurate")
                        .font(.largeTitle)
                }
                
                Spacer()
            }.background(Image("background"))
        }
        
    }
}

#Preview {
    MainView()
}
