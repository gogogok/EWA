//
//  UIViewControllerPreview.swift
//  EWA
//
//  Created by Дарья Жданок on 21.04.26.
//

import SwiftUI

struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    
    let builder: () -> ViewController
    
    init(_ builder: @escaping () -> ViewController) {
        self.builder = builder
    }
    
    func makeUIViewController(context: Context) -> ViewController {
        builder()
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
}

final class MockAlarmFirstInteractor: AlarmFirstMainScreenBusinessLogic {
    func loadAlarms(_ request: Model.LoadAlarmMainScreen.Request) {
        return
    }
    
    func registarUser(_ request: Model.RegisterUserToAlarm.Request) {
        return
    }
}

final class MockCreateNewAlarmInteractor: CreateNewAlarmBusinessLogic {
    func saveAlarm(_ request: Model.LoadCreateNewAlarm.Request) {
        return
    }
    
    func updateAlarm(_ request: Model.LoadUpdateAlarm.Request) {
        return
    }
}

final class MockStudyMainScreenInteractor: StudyMainScreenBusinessLogic {
    func registerParticipant(_ request: Model.LoadERegistration.Request) {
        
    }
    
    func openPasswordPanel(_ request: Model.LoadEnterPassword.Request) {
        
    }
    
    func loadRooms(_ request: Model.LoadStudyMainScreen.Request) {
        
    }
    
    
}

final class MockCreateNewRoomInteractor: CreateNewRoomBusinessLogic {
    func saveRoom(_ request: Model.LoadCreateNewStudeRoom.Request) {
        
    }
    
    
}
