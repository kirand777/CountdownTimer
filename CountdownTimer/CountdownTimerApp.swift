//
//  CountdownTimerApp.swift
//  CountdownTimer
//
//  Created by Kyrylo Andreiev on 30.05.2024.
//

import SwiftUI

@main
struct CountdownTimerApp: App {
    var body: some Scene {
        WindowGroup {
            CountdownView(viewModel: CountdownViewModel(initialTime: 60.0))
        }
    }
}
