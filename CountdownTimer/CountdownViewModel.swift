//
//  CountdownViewModel.swift
//  CountdownTimer
//
//  Created by Kyrylo Andreiev on 30.05.2024.
//

import Foundation
import Combine
import UserNotifications

class CountdownViewModel: ObservableObject {
    @Published var timeRemaining: TimeInterval
    @Published var isRunning: Bool = false
    
    private var timer: AnyCancellable?
    private var lastUpdatedTime: Date?
    private let initialTime: TimeInterval
    
    init(initialTime: TimeInterval = 60.0) {
        self.timeRemaining = initialTime
        self.initialTime = initialTime
        setupNotifications()
    }
    
    func startPauseTimer() {
        if isRunning {
            pauseTimer()
        } else {
            startTimer()
        }
    }
    
    func stopTimer() {
        timer?.cancel()
        timer = nil
        isRunning = false
        timeRemaining = initialTime
        removeScheduledNotification()
    }
    
    private func startTimer() {
        isRunning = true
        lastUpdatedTime = Date()
        scheduleNotification()
        timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
            .sink { [weak self] _ in
                self?.updateTimeRemaining()
            }
    }
    
    private func pauseTimer() {
        timer?.cancel()
        timer = nil
        isRunning = false
        lastUpdatedTime = nil
        removeScheduledNotification()
    }
    
    private func updateTimeRemaining() {
        guard let lastUpdatedTime = lastUpdatedTime else { return }
        
        let currentTime = Date()
        timeRemaining -= currentTime.timeIntervalSince(lastUpdatedTime)
        self.lastUpdatedTime = currentTime
        
        if timeRemaining <= 0 {
            stopTimer()
        }
    }
    
    private func setupNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notifications authorization: \(error)")
            }
        }
    }
    
    private func scheduleNotification() {        
        let content = UNMutableNotificationContent()
        content.title = "Countdown Finished"
        content.body = "Your countdown has ended."
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeRemaining, repeats: false)
        let request = UNNotificationRequest(identifier: "CountdownTimerNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding notification: \(error)")
            }
        }
    }
    
    private func removeScheduledNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["CountdownTimerNotification"])
    }
}
