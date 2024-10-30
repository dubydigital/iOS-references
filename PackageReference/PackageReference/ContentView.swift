//
//  ContentView.swift
//  PackageReference
//
//  Created by Mark Dubouzet on 10/30/24.
//

import SwiftUI

struct Fact: Codable, Identifiable {
    let id = UUID()
    let fact: String
    
    private enum CodingKeys: CodingKey {
        case fact
    }
}




struct ContentView: View {
    @State private var isSheetPresented = false
    
//    @EnvironmentObject var uSet: AltSettings
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Home View")
                    .font(.largeTitle)

                // Itunes View
                NavigationLink(destination: iTunesListView()) {
                    Text("Go to iTunes")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                // StateSample View
                NavigationLink(destination: StateSampleView() ) {
                    Text("Go to StateSampleView")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                // Actions View
                NavigationLink(destination: ActionsView()) {
                    Text("Go to Actions")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                                
                // Bottom View
                Button("Present Bottom Sheet") {
                    isSheetPresented = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .sheet(isPresented: $isSheetPresented) {
                    BottomSheetView()
                }
                
            }
        }
    }
    
}

//MARK: - States
class AltSettings: ObservableObject {
    @Published var isPremiumUser: Bool = false
}

class UserSettings: ObservableObject {
    @Published var isPremiumUser: Bool = false
}

struct StateSampleView: View {
    @EnvironmentObject var uSet: AltSettings
    @StateObject private var settings = UserSettings() // Owned ObservableObject
    
    var body: some View {
        VStack {
            Text("Persisted User is \(uSet.isPremiumUser ? "Premium" : "Regular")")
            Text("User is \(settings.isPremiumUser ? "Premium" : "Regular")")
            Button("Toggle Premium Status") {
                uSet.isPremiumUser.toggle()
                settings.isPremiumUser.toggle()
            }
        }
    }
}

//MARK: - Bottom Sheet
struct BottomSheetView: View {
    var body: some View {
        VStack {
            Text("Bottom Sheet View")
                .font(.title)
                .padding()
            
            Text("This view slides up from the bottom.")
                .padding()
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}


struct DogView: View {
    @State private var facts: [Fact] = [Fact]()
    
    var body: some View {
        NavigationView {
            VStack {
                List(facts) { fact in
                    Text(fact.fact)
                    Text("sample_x")
                }
            }.onAppear {
                
                WebService().fetch(url: URL(string: "https://dog-facts-api.herokuapp.com/api/v1/resources/dogs/all")!) { data  in
                    return try! JSONDecoder().decode([Fact].self, from: data)
                } completion: { result in
                    switch result {
                    case .success(let facts):
                        if let facts = facts {
                            DispatchQueue.main.async {
                                self.facts = facts
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
                    
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AltSettings())
}
