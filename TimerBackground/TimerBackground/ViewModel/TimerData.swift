//
//  TimerData.swift
//  TimerBackground
//
//  Created by 宋璞 on 2023/8/1.
//

import SwiftUI


class TimerData: NSObject , ObservableObject {
    
    @Published var time: Int = 0
    @Published var selectedTime: Int = 0
    
    // Animation Properties
    @Published var buttonAnimation = false
    
    // TimerView Data
    @Published var timerViewOffset: CGFloat = UIScreen.main.bounds.height
    @Published var timerHeightChange: CGFloat = 0
    
    /// 离开APP时间
    @Published var leftTimer: Date!
    
    
}

extension TimerData : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        resetView()
        completionHandler()
    }
    
    func resetView() {
        withAnimation {
            time = 0
            selectedTime = 0
            timerHeightChange = 0
            timerViewOffset = UIScreen.main.bounds.height
            buttonAnimation = false
            leftTimer = nil
        }
    }
}
