//
//  Nourish_FoodsApp.swift
//  Nourish Foods
//
//  Created by Guest User on 2025-07-05.
//

import SwiftUI

@main
struct Nourish_FoodsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
