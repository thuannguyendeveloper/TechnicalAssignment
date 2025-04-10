//
//  TagView.swift
//  TechnicalAssignment
//
//  Created by Jamie on 09/04/2025.
//

import Foundation
import SwiftUI

struct TagView: View {
    
    let price: Double
    
    private let isIPhone = Device.isIPhone
    private let coordinateSpace = "TagView"
    @State private var isShow = false
    @State private var infoLocation = CGPoint.zero
    @State private var tagLocation = CGPoint.zero
    @State private var contentWidth: Double = 0
    @State private var contentHeight: Double = 0
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                self.infoLocation = value.location
            }.onEnded { value in
                if self.infoLocation.x < 0 {
                    self.infoLocation.x = 30
                }
                
                if self.infoLocation.x > contentWidth - 40 {
                    self.infoLocation.x = contentWidth - 60
                }
                
                if self.infoLocation.y < 0 {
                    self.infoLocation.y = 20
                }
                
                if self.infoLocation.y > contentHeight - 20 {
                    self.infoLocation.y = contentHeight - 40
                }
            }
    }
    
    var body: some View {
        VStack {
            GeometryReader(content: { geometry in
                mainView()
                    .onAppear(perform: {
                        contentWidth = geometry.size.width
                        contentHeight = geometry.size.height
                    })
            })
        }
    }
    
    private func mainView() -> some View {
        ZStack {
            if isShow {
                Path() { myPath in
                    myPath.move(to: CGPoint(x: tagLocation.x,
                                            y: tagLocation.y))
                    myPath.addLine(to: CGPoint(x: infoLocation.x + 20,
                                               y: infoLocation.y + 20))
                }.stroke(Color.gray.opacity(0.8), lineWidth: 1)
            }
            VStack {
                if isShow {
                    VStack {
                        Text(price.formatted(.currency(code: "USD")))
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.black)
                            .frame(height: 30)
                            .frame(width: 80)
                            .background(
                                RoundedRectangle(cornerRadius: 3)
                                    .stroke(.gray.opacity(0.8), lineWidth: 1)
                                    .fill(.white)
                            )
                            .animation(.easeInOut, value: infoLocation)
                            .position(infoLocation)
                            .gesture(dragGesture)
                            .padding()
                    }
                }
                Spacer()
                HStack {
                    Spacer()
                    let circleSizeWidth: CGFloat = isIPhone ? 20 : 35
                    let circleSizeHeight: CGFloat = isIPhone ? 20 : 35
                    GeometryReader(content: { geometry in
                        Image(systemName: "record.circle")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(isShow ? .accentColor : .accentColor.opacity(0.6))
                            .aspectRatio(contentMode: .fill)
                            .onAppear(perform: {
                                infoLocation.x = geometry.frame(in: .named(coordinateSpace)).minX - 50
                                infoLocation.y = geometry.frame(in: .named(coordinateSpace)).minY - 50
                                tagLocation.x = geometry.frame(in: .named(coordinateSpace)).minX + circleSizeHeight / 2
                                tagLocation.y = geometry.frame(in: .named(coordinateSpace)).minY + circleSizeHeight / 2
                            })
                            .frame(width: circleSizeWidth)
                            .frame(height: circleSizeHeight)
                    })
                    .frame(width: circleSizeWidth)
                    .frame(height: circleSizeHeight)
                    .padding(5)
                }
                .onTapGesture {
                    isShow.toggle()
                }
            }
        }
        .coordinateSpace(name: coordinateSpace)

    }
}

#Preview {
    let test = VStack {
        TagView(price: 100)
    }
    return test
}
