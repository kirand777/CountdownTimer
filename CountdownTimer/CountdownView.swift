//
//  CountdownView.swift
//  CountdownTimer
//
//  Created by Kyrylo Andreiev on 30.05.2024.
//

import SwiftUI

struct CountdownView: View {
    @StateObject var viewModel: CountdownViewModel
    
    init(viewModel: CountdownViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 20)
                    .opacity(0.3)
                    .foregroundColor(.gray)
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(viewModel.timeRemaining / 60))
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                    .foregroundColor(.blue)
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.linear, value: viewModel.timeRemaining)
                
                Text(String(format: "%.2f", viewModel.timeRemaining))
                    .font(.largeTitle)
                    .bold()
            }
            .padding(40)
            
            HStack {
                Button(action: {
                    viewModel.startPauseTimer()
                }) {
                    Text(viewModel.isRunning ? "Pause" : "Start")
                        .frame(width: 100, height: 50)
                        .background(viewModel.isRunning ? Color.orange : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    viewModel.stopTimer()
                }) {
                    Text("Stop")
                        .frame(width: 100, height: 50)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView(viewModel: CountdownViewModel(initialTime: 60.0))
    }
}
