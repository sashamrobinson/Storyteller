//
//  ErrorViewModel.swift
//  Storyteller
//
//  Created by Sasha Robinson on 2023-08-06.
//

import SwiftUI

class ErrorViewModel: Identifiable {
    let id = UUID()
    let errorType: ErrorHelper.AppErrorType
    
    init(_ errorType: ErrorHelper.AppErrorType) {
        self.errorType = errorType 
    }
}
