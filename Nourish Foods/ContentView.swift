//
//  ContentView.swift
//  Nourish Foods
//
//  Created by Guest User on 2025-07-05.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var dataInitializationVM = DataInitializationViewModel()
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var biometricManager = BiometricManager()

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                // User is signed in - show main app
                MainAppView()
                    .environmentObject(authViewModel)
                    .environmentObject(biometricManager)
            } else {
                // User is not signed in - show authentication
                AuthenticationView()
                    .environmentObject(authViewModel)
                    .environmentObject(biometricManager)
            }
        }
        .task {
            // Initialize sample data if needed when app starts
            await dataInitializationVM.initializeSampleDataIfNeeded()
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
