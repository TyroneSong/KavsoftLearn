//
//  Home.swift
//  TimerBackground
//
//  Created by 宋璞 on 2023/8/1.
//

import SwiftUI
import UserNotifications

struct Home: View {
    
    @EnvironmentObject var data: TimerData
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(1...6, id: \.self) { index in
                            let time = index * 5
                            
                            Text("\(time)")
                                .font(.system(size: 45, weight: .heavy))
                                .frame(width: 100, height: 100)
                                .background(data.time == time ? Color("pink") : Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .onTapGesture {
                                    withAnimation {
                                        data.time = time
                                        data.selectedTime = time
                                    }
                                }
                        }
                    }
                    .padding()
                }
                .offset(y: 40)
                .opacity(data.buttonAnimation ? 0 : 1)
                
                Spacer()
                
                Button {
                    withAnimation(.easeInOut(duration: 0.65)) {
                        data.buttonAnimation.toggle()
                    }
                    withAnimation(.easeIn(duration: 0.6)) {
                        data.timerViewOffset = 0
                    }
                    performNotifications()
                } label: {
                    Circle()
                        .fill(Color("pink"))
                        .frame(width: 80, height: 80)
                }
                .padding(.bottom, 35)
                .disabled(data.time == 0)
                .opacity(data.time == 0 ? 0.6 : 1)
                .offset(y: data.buttonAnimation ? 300 : 0)

                
                
            }
            
            Color("pink")
                .overlay(
                    Text("\(data.selectedTime)")
                        .font(.system(size: 55, weight: .heavy))
                        .foregroundColor(.white)
                )
                .frame(height: UIScreen.main.bounds.height - data.timerHeightChange)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .ignoresSafeArea(.all, edges: .all)
                .offset(y: data.timerViewOffset)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("bg").ignoresSafeArea(.all, edges: .all))
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect(), perform: { _ in
            if data.time != 0 && data.selectedTime != 0 && data.buttonAnimation {
                data.selectedTime -= 1
                
                let progressHeight = UIScreen.main.bounds.height / CGFloat(data.time)
                
                let diff = data.time - data.selectedTime
                
                withAnimation(.default) {
                    data.timerHeightChange = CGFloat(diff) * progressHeight
                }
                
                if data.selectedTime == 0 {
                    data.resetView()
                }
            }
        })
        .onAppear {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound]) { _, _ in
                //
            }
            
            UNUserNotificationCenter.current().delegate = data
        }
    }
    
    func performNotifications() {
        let content = UNMutableNotificationContent()
        content.title = "Notification from SP"
        content.body = "Timer is Finished"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(data.time), repeats: false)
        
        let request = UNNotificationRequest(identifier: "Timer", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
}

struct Home_Previews: PreviewProvider {

    static var previews: some View {
        Home()
            .environmentObject(TimerData())
    }
}
