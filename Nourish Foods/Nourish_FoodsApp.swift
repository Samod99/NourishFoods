//
//  Nourish_FoodsApp.swift
//  Nourish Foods
//
//  Created by Guest User on 2025-07-05.
//

import SwiftUI
import Firebase

@main
struct Nourish_FoodsApp: App {
    let persistenceController = PersistenceController.shared
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
