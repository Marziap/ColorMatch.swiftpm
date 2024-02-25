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

func calculateColorSimilarity(color1: Color, color2: Color) -> CGFloat {
    let distance = calculateEuclideanDistance(color1: color1, color2: color2)
    let similarity = 100.0 * (1.0 - distance)
    return max(0.0, similarity) // Ensure similarity is not negative
}

// Function to calculate Euclidean distance between two colors
func calculateEuclideanDistance(color1: Color, color2: Color) -> CGFloat {
    let components1 = color1.cgColor?.components
    let components2 = color2.cgColor?.components
    
    let redDiff = components1![0] - components2![0]
    let greenDiff = components1![1] - components2![1]
    let blueDiff = components1![2] - components2![2]
    
    let distance = sqrt(pow(redDiff, 2) + pow(greenDiff, 2) + pow(blueDiff, 2))
    
    return distance
}


func displayP3TosRGB(color: Color) -> Color {
    
    let newColor = color.cgColor!.converted(to: CGColorSpace(name: CGColorSpace.sRGB)!, intent: .defaultIntent, options: nil)!
    
    return Color(newColor)
}


func normalize (perc: CGFloat) ->  CGFloat {
    
    var res = perc
    
    if(perc>100){
        res = 100-(perc-100)
    }else if(perc.isNaN){
        res=100
    }
    
    return res
}

func getAccuracy(color: Color, myColor: Color)-> CGFloat {
  
    let myRed =  (myColor.cgColor?.components![0])!
    let red = (color.cgColor?.components![0])!
    //print("red:\(myRed)-\(red)")
    
    let myGreen = (myColor.cgColor?.components![1])!
    let green = (color.cgColor?.components![1])!
    
    let myBlue = (myColor.cgColor?.components![2])!
    let blue = (color.cgColor?.components![2])!
    
    var redPerc = round((100 * myRed)/red)
    var greenPerc = round((100 * myGreen)/green)
    var bluePerc = round((100 * myBlue)/blue)
    
    
    
   
    //valori strani se mio valore > valore vero
    //se valore mio = 0 da accuratezza 0%
    //se valore vero = 0 da infinito
    // se 0/0 da nan
    //print("pre norm ->red:\(redPerc)% green:\(greenPerc)% blue:\(bluePerc)%")
    
    redPerc=normalize(perc: redPerc)
    greenPerc=normalize(perc: greenPerc)
    bluePerc=normalize(perc: bluePerc)
    
    
    //print("after norm ->red:\(redPerc)% green:\(greenPerc)% blue:\(bluePerc)%")
    
    let finalPercentage = (redPerc+greenPerc+bluePerc)/3
    return finalPercentage
    
}

struct MainView: View {

    @State private var col = Color.black
    @State private var myCol = Color.black
    @State private var percentage = 0.0
    @State private var submitted = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                Button(action: {
                    
                    col = Color.random
                    submitted=false
                    myCol=Color.black
                    

                }, label: {
                    Text("Generate new")
                        .font(.largeTitle)
                })
                
                Spacer()
                HStack{
                    Spacer()
                    Rectangle()
                        .frame(width: geometry.size.width * 0.35, height: geometry.size.width * 0.35)
                        .foregroundStyle(col)
                    .clipShape(.rect(cornerRadius: 15))
                    .contextMenu(ContextMenu(menuItems: {
                        Text("r:\(Int((col.cgColor?.components![0])!*255)) g:\(Int((col.cgColor?.components![1])!*255)) b:\(Int((col.cgColor?.components![2])!*255))")
                    }))

                    Spacer()
                    
                        Rectangle()
                        .frame(width: geometry.size.width * 0.35, height: geometry.size.width * 0.35)
                            .foregroundStyle(myCol)
                        .clipShape(.rect(cornerRadius: 15))
                        .contextMenu(ContextMenu(menuItems: {
                            Text("r:\(Int((myCol.cgColor?.components![0])!*255)) g:\(Int((myCol.cgColor?.components![1])!*255)) b:\(Int((myCol.cgColor?.components![2])!*255))")
                        }))
                    Spacer()
                }
                
                Spacer()
                
                ColorPicker("Try to match", selection: $myCol, supportsOpacity: false)
                    .labelsHidden()
                    .pickerStyle(.wheel)
                
                Spacer()
                
                Button(action: {
                    
                   
//                    let resolved = col.cgColor?.components
//                    print("real:\(resolved!)")
//                    
//                    let myResolved = myCol.cgColor?.components
//                    print("mine:\(myResolved!)")
                    if(myCol.cgColor?.colorSpace?.name==CGColorSpace.sRGB){
                        print("rgb")
                        let newCol=displayP3TosRGB(color: col)
//                        percentage = getAccuracy(color: newCol, myColor: myCol)
//                        
//                         let resolved = col.cgColor?.components
//                         print("real:\(resolved!)")
                        percentage=calculateColorSimilarity(color1: newCol, color2: myCol)
                    }else{
                        print("DisplayP3")
                        let newMyCol=displayP3TosRGB(color: myCol)
//                        percentage = getAccuracy(color: col, myColor: newMyCol)
//                        
//                        let resolved = newMyCol.cgColor?.components
//                        print("real:\(resolved!)")
                        percentage=calculateColorSimilarity(color1: col, color2: newMyCol)
                       
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
