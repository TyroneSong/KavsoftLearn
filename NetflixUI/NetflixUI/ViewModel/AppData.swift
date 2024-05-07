//
//  AppData.swift
//  NetflixUI
//
//  Created by 宋璞 on 2024/4/13.
//

import SwiftUI

@Observable
class AppData {
    var isSplashFinished: Bool = false
    var activeTab: Tab = .account
    var hideMainView: Bool = false
    /// Profile properties
    var showProfileView: Bool = false
    var tabProfileRect: CGRect = .zero
    var watchingProfile: Profile?
    var animateProfile: Bool = false
    var fromTabBar: Bool = false
}
