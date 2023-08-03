//
//  Permission.swift
//  QRCodeScanner
//
//  Created by 宋璞 on 2023/8/2.
//

import SwiftUI

/// 许可
enum Permission: String {
    case idle = "Not Determined"
    case approved = "Access Granted"
    case denied = "Access Denied"
}
