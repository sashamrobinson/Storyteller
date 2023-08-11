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
                message: Text("An error occured. Please log back in to continue using the app."),
                dismissButton: .default(Text("Okay"), action: {
                    // Handle reauthentication
                })
            )
        }
    }
}
//    let errorType: AppErrorType
//    @State private var showAlert = false
//    @State private var navigateToHomeView = false
//
//    var body: some View {
//        VStack {
//            Text("")
//            .onAppear {
//                showAlert = true
//            }
//            .alert(isPresented: $showAlert) {
//                switch errorType {
//
//                case .generic:
//                    return Alert(title: Text("An error occured"), message: Text("Please restart the app and try logging back in to continue use."), dismissButton: .default(Text("Okay")))
//
//                case .reauth:
//                    return Alert(title: Text("An error occured"), message: Text("Please log back in to continue using the app."), dismissButton: .default(Text("Okay"), action: {
//                            navigateToHomeView = true
//                    }))
//
//                case .network:
//                    return Alert(title: Text("An error occured"), message: Text("Network conditions seem to be unstable. Please connect to a more stable network before continued use."), dismissButton: .default(Text("Okay")))
//                }
//            }
//            .navigationDestination(isPresented: $navigateToHomeView) {
//                HomeView().navigationBarBackButtonHidden(true)
//            }
//        }
//    }


