//
//  MainView.swift
//  ColorMatch
//
//  Created by Marzia Pirozzi on 23/02/24.
//

import SwiftUI

extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}


func getAccuracy(color: Color, myColor: Color)-> CGFloat {
  
    let myRed =  round(UIColor(myColor).cgColor.components![0] * 255)
    let red = round(UIColor(color).cgColor.components![0] * 255)
    //print("red:\(myRed)-\(red)")
    
    let myGreen = round(UIColor(myColor).cgColor.components![1] * 255)
    let green = round(UIColor(color).cgColor.components![1] * 255)
    //print("red:\(myGreen)-\(green)")
    
    let myBlue = round(UIColor(myColor).cgColor.components![2] * 255)
    let blue = round(UIColor(color).cgColor.components![2] * 255)
    //print("red:\(myBlue)-\(blue)")
    

    
    let redPerc = round((100 * myRed)/red)
    let greenPerc = round((100 * myGreen)/green)
    let bluePerc = round((100 * myBlue)/blue)
    print("red:\(redPerc)% green:\(greenPerc)% blue:\(bluePerc)%")
    //valori strani se mio valore > valore vero
    //se valore mio = 0 da accuratezza 0%
    //se valore vero = 0 da infinito
    // se 0/0 da nan
    
    let finalPercentage = (redPerc+greenPerc+bluePerc)/3
    return finalPercentage
    
}

struct MainView: View {

    @State private var col = Color.black
    @State private var myCol = Color.black
    @State private var percentage = 0.0
    @State private var submitted = false
    var body: some View {
        VStack {
            Spacer()
            Button(action: {
                
                col = Color.init(uiColor: .random)
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
                    .frame(width: 300, height: 300)
                    .foregroundStyle(col)
                .clipShape(.rect(cornerRadius: 15))
                .contextMenu(ContextMenu(menuItems: {
                    Text("r:\(Int(round(UIColor(col).cgColor.components![0] * 255))) g:\(Int(round(UIColor(col).cgColor.components![1] * 255))) b:\(Int(round(UIColor(col).cgColor.components![2] * 255)))")
                }))

                Spacer()
                
                    Rectangle()
                        .frame(width: 300, height: 300)
                        .foregroundStyle(myCol)
                    .clipShape(.rect(cornerRadius: 15))
                    .contextMenu(ContextMenu(menuItems: {
                        Text("r:\(Int(round(UIColor(myCol).cgColor.components![0] * 255))) g:\(Int(round(UIColor(myCol).cgColor.components![1] * 255))) b:\(Int(round(UIColor(myCol).cgColor.components![2] * 255)))")
                    }))
                Spacer()
            }
            
            Spacer()
            
            ColorPicker("", selection: $myCol, supportsOpacity: false)
                .offset(x: -400)
            
            Spacer()
            
            Button(action: {
                
                percentage = getAccuracy(color: col, myColor: myCol)
                submitted=true
                
            }, label: {
                Text("Submit")
                    .font(.largeTitle)
            })
            
            Spacer()
            
            if(submitted){
                Text("You were \(percentage)% accurate")
                    .font(.largeTitle)
            }
            
            Spacer()
        }
        
    }
}

#Preview {
    MainView()
}
