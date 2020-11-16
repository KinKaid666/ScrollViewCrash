//
//  TestView.swift
//  ScrollViewCrash
//
//  Created by Eric Ferguson on 11/16/20.
//

import SwiftUI

struct Hole: Hashable, Codable, Identifiable {
    var name: String
    var id: Int
}

struct OtherView: View {
    @Binding var showing:Bool
    @State   var displayedHole:Int = 1
    
    var holes:[Hole] = [
        Hole(name: "One",   id: 1),
        Hole(name: "Two",   id: 2),
        Hole(name: "Three", id: 3),
        Hole(name: "Four",  id: 4),
        Hole(name: "Five",  id: 5),
        Hole(name: "Six",   id: 6),
        Hole(name: "Seven", id: 7),
        Hole(name: "Eight", id: 8),
        Hole(name: "Nine",  id: 9)
    ]
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(holes, id: \.self) { h in
                        HoleSelectionView(hole: h, selected: $displayedHole).id(h.id)
                    }
                }.padding()
            }.frame(height: 60)
           // The below causes a crash when the round ends
            .onChange(of: displayedHole) { target in
                withAnimation {
                    proxy.scrollTo(target, anchor: .center)
                }
            }
        }
        HStack {
            if(self.displayedHole > 1) {
                Button(action: {
                    self.displayedHole -= 1
                }) // Button
                {
                    Text("Left")
                        .font(.headline)
                        .padding()
                        .foregroundColor(Color.white)
                        .frame(width: 150, height: 65)
                        .background(Color.green)
                        .cornerRadius(15.0)
                }.buttonStyle(BorderlessButtonStyle()).frame(alignment: .leading)
            }
            else{
                Spacer().frame(width: 150, height: 65)
            }
            Spacer().frame(width: 50, height: 50)

            if(self.displayedHole < holes.count) {
                Button(action: {
                    self.displayedHole += 1
                }) // Button
                {
                    Spacer().frame(width: 50, height: 50)
                    Text("Right")
                        .font(.headline)
                        .padding()
                        .foregroundColor(Color.white)
                        .frame(width: 150, height: 65)
                        .background(Color.green)
                        .cornerRadius(15.0)
                }.buttonStyle(BorderlessButtonStyle())
            } else{
                Spacer().frame(width: 150, height: 65)
            }
        }.frame(height: 75)
        Button(action: {
            self.showing.toggle()
        }) // Button
        {
            Text("Destroy View")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 250, height: 75, alignment: .center)
                .background(Color.green)
                .cornerRadius(15.0)
        }.buttonStyle(BorderlessButtonStyle()).frame(alignment: .trailing)
    }
}

struct HoleSelectionView : View {
    var hole: Hole
    @Binding var selected: Int
    
    var body: some View {
        Button(action: {self.selected = self.hole.id})
        {
            ZStack {
                Circle()
                    .fill((self.selected == self.hole.id ? Color.green :  Color.gray))
                    .frame(width: 50, height: 50)
                Text(String(hole.id)).foregroundColor((self.selected == self.hole.id ? Color.white :  Color.black))
            }
        }.buttonStyle(BorderlessButtonStyle())
    }
}

struct TestView: View {
    @State var showOtherView:Bool = false
    var body: some View {
        if showOtherView {
            OtherView(showing: $showOtherView)
        } else {
            Button(action: {
                self.showOtherView.toggle()
            }) // Button
            {
                Text("Create View")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 100, height: 75)
                    .background(Color.green)
                    .cornerRadius(15.0)
            }.buttonStyle(BorderlessButtonStyle()).frame(alignment: .leading)
        }
    }
}
