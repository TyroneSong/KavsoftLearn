//
//  PaymentStatus.swift
//  FlightAppUI
//
//  Created by 宋璞 on 2023/8/3.
//

import SwiftUI

enum PaymentStatus: String, CaseIterable {
    case started = "Connected..."
    case initated = "Secure payment...."
    case finished = "Puchased"
    
    var symbolImage: String {
        switch self {
        case .started:
            return "wifi"
        case .initated:
            return "checkmark.shield"
        case .finished:
            return "checkmark"
        }
    }
}
