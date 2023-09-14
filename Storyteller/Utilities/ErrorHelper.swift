//
//  ErrorHelper.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-08-05.
//

import SwiftUI

struct ErrorHelper {
    
    // Enum for different error types
    enum AppErrorType: Identifiable {
        var id: Self { self }
        case generic
        case network
        case reauth
    }
    
    static func alert(for errorType: AppErrorType) -> Alert {
        switch errorType {
        case .generic:
            return Alert(
                title: Text("Error"),
                message: Text("An error occured. Please restart the app and try reauthenticating before continuing to use the app."),
                dismissButton: .default(Text("Okay"))
            )
        case .network:
            return Alert(
                title: Text("Network Error"),
                message: Text("An error occured. Please make sure you are connected to a stable network before continuing to use the app."),
                dismissButton: .default(Text("Okay"))
            )
        case .reauth:
            return Alert(
                title: Text("Reauthentication Required"),
                message: Text("An error occured. Please log out and ."),
                dismissButton: .default(Text("Okay"), action: {
                    // Handle reauthentication
                })
            )
        }
    }
}
